//
//  ChatRepository.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
//  LSP: Implementa ChatRepositoryProtocol sem quebrar contrato

import Foundation
import UIKit

final class ChatRepository: ChatRepositoryProtocol {
    private let apiClient: AnthropicAPIClientProtocol
    
    init(apiClient: AnthropicAPIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func sendMessage(_ text: String, language: Language, history: [Message], goals: [LearningGoal], lessonMode: Bool) async throws -> TutorResponse {
        
        let historySnippet = history.suffix(5).map {
            ["sender": $0.sender == .user ? "user" : "tutor", "text": $0.text]
        }
        
        let historyJSON = (try? JSONSerialization.data(withJSONObject: historySnippet))
            .flatMap { String(data: $0, encoding: .utf8) } ?? "[]"
        
        let system = """
Você é um tutor de idiomas amigável ajudando falantes de português brasileiro a aprenderem \(language.nativeName).
Responda APENAS com JSON válido, sem texto fora do JSON.
"""
        let userPrompt = """
Histórico:\(historyJSON)
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
    }
    "grammarAnalysis": { "accuracy": 80 },
    "vocabularyUsed": ["word1", "word2"]
}
"""
        let raw = try await apiClient.complete(system: system, userMessages: [MessageDTO(role: "user", content: userPrompt)])
        
        return try parseResponse(raw)
    }
    
    private func parseResponse(_ raw: String) throws -> TutorResponse {
        let clean = raw
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let data = clean.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { throw APIError.DecodingError("JSON inválido") }
        
        let feedbackJson = json["feedback"] as? [String: Any] ?? [:]
        let feedback = TutorFeedback(positives: feedbackJson["positive"] as? [String] ?? [],
                                     corrections: feedbackJson["corrections"] as? [String] ?? [],
                                     suggestions: feedbackJson["suggestions"] as? [String] ?? [])
        
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
