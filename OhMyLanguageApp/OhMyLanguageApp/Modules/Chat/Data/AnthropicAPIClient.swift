//
//  AnthropicAPIClient.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
//  OCP: Pode ser estendido sem modificar (ex: trocar modelo via init)

import Foundation
import UIKit

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse(statusCode: Int, body: String)
    case decodingError(String)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL Inválida."
        case .invalidResponse(let c, let b): return "Erro \(c): \(b)"
        case .decodingError(let s): return "Falha ao decodificar: \(s)"
        case .networkError(let e): return e.localizedDescription
        }
    }
}

protocol AnthropicAPIClientProtocol {
    func complete(system: String, userMessages: [MessageDTO]) async throws -> String
}

// MARK: - Data/Network/GeminiAPIClient.swift

import Foundation

final class AnthropicAPIClient: AnthropicAPIClientProtocol {
    private let apiKey: String
    private let session: URLSession
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent"

    init(apiKey: String, model: String = "", session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func complete(system: String, userMessages: [MessageDTO]) async throws -> String {
        // Monta o prompt combinando system + mensagem do usuário
        let fullPrompt = system + "\n\n" + (userMessages.last?.content ?? "")

        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": fullPrompt]]]
            ],
            "generationConfig": [
                "maxOutputTokens": 1024,
                "temperature": 0.7
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse(statusCode: 0, body: "No HTTP response")
            }
            guard (200..<300).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? ""
                throw APIError.invalidResponse(statusCode: http.statusCode, body: body)
            }

            // Parse resposta do Gemini
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let candidates = json["candidates"] as? [[String: Any]],
                  let first = candidates.first,
                  let content = first["content"] as? [String: Any],
                  let parts = content["parts"] as? [[String: Any]],
                  let text = parts.first?["text"] as? String
            else {
                throw APIError.decodingError("Formato de resposta inesperado do Gemini")
            }

            return text

        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}
