// MARK: - Data/Repositories/ChatRepository.swift
// LSP: implementa ChatRepositoryProtocol sem quebrar contrato

import Foundation

final class ChatRepository: ChatRepositoryProtocol {
    private let apiClient: AnthropicAPIClientProtocol

    init(apiClient: AnthropicAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func sendMessage(_ text: String,
                     language: Language,
                     history: [Message],
                     goals: [LearningGoal],
                     lessonMode: Bool) async throws -> TutorResponse {

        let historySnippet = history.suffix(5).map {
            ["sender": $0.sender == .user ? "user" : "tutor", "text": $0.text]
        }
        let historyJSON = (try? JSONSerialization.data(withJSONObject: historySnippet))
            .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"

        let system = """
Você é um tutor de idiomas amigável ajudando falantes de português brasileiro a aprenderem \(language.nativeName).
Responda APENAS com JSON válido, sem texto fora do JSON e sem blocos de código markdown.
"""
        let userPrompt = """
Histórico: \(historyJSON)
Mensagem: "\(text)"
Objetivos: \(goals.map(\.text).joined(separator: ", "))
Modo lição: \(lessonMode)

Responda APENAS com JSON neste formato:
{
  "tutorResponse": "resposta em \(language.nativeName)",
  "portugueseTranslation": "tradução em português brasileiro",
  "feedback": {
    "positive": ["..."],
    "corrections": ["..."],
    "suggestions": ["..."]
  },
  "grammarAnalysis": { "accuracy": 80 },
  "vocabularyUsed": ["word1", "word2"]
}
"""
        let raw = try await apiClient.complete(
            system: system,
            userMessages: [MessageDTO(role: "user", content: userPrompt)]
        )

        return try parseResponse(raw)
    }

    // MARK: - Parse

    private func parseResponse(_ raw: String) throws -> TutorResponse {
        // Remove markdown code blocks
        var cleaned = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        // Remove ```json ou ``` do início
        if cleaned.hasPrefix("```json") {
            cleaned = String(cleaned.dropFirst(7))
        } else if cleaned.hasPrefix("```") {
            cleaned = String(cleaned.dropFirst(3))
        }

        // Remove ``` do final
        if cleaned.hasSuffix("```") {
            cleaned = String(cleaned.dropLast(3))
        }

        cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
        print("✅ JSON limpo: \(cleaned)")

        guard let data = cleaned.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { throw APIError.decodingError("JSON inválido após limpeza") }

        let feedbackJson = json["feedback"] as? [String: Any] ?? [:]
        let feedback = TutorFeedback(
            positives:   feedbackJson["positive"]    as? [String] ?? [],
            corrections: feedbackJson["corrections"] as? [String] ?? [],
            suggestions: feedbackJson["suggestions"] as? [String] ?? []
        )

        let grammarJson = json["grammarAnalysis"] as? [String: Any] ?? [:]
        let accuracy = grammarJson["accuracy"] as? Int ?? 75

        return TutorResponse(
            text: json["tutorResponse"] as? String ?? "",
            portugueseTranslation: json["portugueseTranslation"] as? String ?? "",
            feedback: feedback,
            grammarAccuracy: accuracy,
            detectedLevel: .beginner,
            vocabularyUsed: json["vocabularyUsed"] as? [String] ?? []
        )
    }
}
