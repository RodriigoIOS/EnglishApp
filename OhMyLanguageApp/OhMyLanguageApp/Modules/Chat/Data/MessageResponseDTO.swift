//
//  MessageResponseDTO.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
//

import Foundation
import UIKit

struct AnthropicResponse: Decodable {
    let content:  [ContentBlock]
    
    struct ContentBlock: Decodable {
        let type: String
        let text: String?
    }
    
    var textContent: String {
        content.compactMap { $0.type == "text" ? $0.text : nil }.joined()
    }
}
