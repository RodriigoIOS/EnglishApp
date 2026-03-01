//
//  Message.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id: UUID
    let text: String
    let translatedText: String?
    let sender: Sender
    let timestamp: Date
    
    enum Sender { case user, tutor }
    
    init(id: UUID = .init(), text: String, translatedText: String? = nil, sender: Sender, timestamp: Date = .now) {
        self.id = id
        self.text = text
        self.translatedText = translatedText
        self.sender = sender
        self.timestamp = timestamp
    }
}
