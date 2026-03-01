//
//  SendMessagesUseCase.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
//

import Foundation
import UIKit

protocol SendMessageUseCaseProtocol {
    func execute(userText: String,
                 language: Language,
                 history: [Message],
                 goals: [LearningGoal],
                 lessionMode: Bool) async throws -> (Message, TutorFeedback, UserProgress)
}

final class SendMessageUseCase: SendMessageUseCaseProtocol {
    private let chatRepository: ChatRepositoryProtocol
    
    //DIP: recebe abstração, náo implementação
    init(chatRepository: ChatRepositoryProtocol) {
        self.chatRepository = chatRepository
    }
    
    func execute(userText: String, language: Language, history: [Message], goals: [LearningGoal], lessionMode: Bool) async throws -> (Message, TutorFeedback, UserProgress) {
        
        let response = try await chatRepository.sendMessage(userText,
                                                            language: language,
                                                            history: history,
                                                            goals: goals,
                                                            lessonMode: lessionMode)
        
        let tutorMessage = Message(text: response.text, translatedText: response.portugueseTranslation, sender: .tutor)
        
        let currentTotal = history.filter { $0.sender == .user }.count + 1
        let level: UserProgress.ProficiencyLevel = {
            switch currentTotal {
            case ..<10: return .beginner
            case 10..<25: return .intermediate
            default: return .advanced
            }
        }()
        
        let progress = UserProgress(totalMessages:currentTotal, vocabularyCount: response.vocabularyUsed.count, grammarAccuracy: response.grammarAccuracy, proficiencyLevel: level, vocabularyHistory: [], accuracyHistory: [])
        
        return (tutorMessage, response.feedback, progress)
    }
}
