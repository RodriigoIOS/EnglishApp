//
//  MessageRequestDTO.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
//

import Foundation
import UIKit

struct AnthropicRequest: Encodable {
    let model: String
    let maxTokens: Int
    let messages: [MessageDTO]
    let system: String?
    
    enum CodingKeys: String, CodingKey {
        case model
        case maxTokens = "max_tokens"
        case messages
        case system
    }
}

struct MessageDTO: Codable {
    let role: String
    let content: String
}
