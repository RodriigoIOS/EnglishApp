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
    case DecodingError(String)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "URL Inválida."
        case .invalidResponse(let c, let b): return "Erro \(c): \(b)"
        case .DecodingError(let s): return "Falha ao decodificar: \(s)"
        case.networkError(let e): return e.localizedDescription
        }
    }
}

protocol AnthropicAPIClientProtocol {
    func complete(system: String, userMessages: [MessageDTO]) async throws -> String
}

final class AnthropicAPIClient: AnthropicAPIClientProtocol {
    private let apiKey: String
    private let model: String
    private let session: URLSession
    
    private let baseURL = "https://api.anthropic.com/v1/messages"
    private let apiVersion = "2023-06-01"
    
    init(apiKey: String,
         model: String = "claude-sonnet-4-20250514",
         session: URLSession = .shared) {
        self.apiKey = apiKey
        self.model = model
        self.session = session
    }
    
    func complete(system: String, userMessages: [MessageDTO]) async throws -> String {
        guard let url = URL(string: baseURL) else { throw APIError.invalidURL}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue(apiVersion, forHTTPHeaderField: "anthropic-version")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = AnthropicRequest(model: model, maxTokens: 1024, messages: userMessages, system: system)
        request.httpBody = try JSONEncoder().encode(body)
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let http = response as? HTTPURLResponse else {
                throw APIError.invalidResponse(statusCode: 0, body: "No HTTP response")
            }
            guard (200..<300).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? ""
                throw APIError.invalidResponse(statusCode: http.statusCode, body: body)
            }
            
            let decoded = try JSONDecoder().decode(AnthropicResponse.self, from: data)
            return decoded.textContent
        } catch let error as APIError {
            throw error
        } catch let error as DecodingError {
            throw APIError.DecodingError(error.localizedDescription)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
