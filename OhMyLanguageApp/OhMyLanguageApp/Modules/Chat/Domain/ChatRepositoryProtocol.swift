//
//  ChatRepositoryProtocol.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation

protocol ChatRepositoryProtocol {
    func sendMessage(_ text: String,
                     language: Language,
                     history: [Message],
                     goals: [LearningGoal],
                     lessonMode: Bool) async throws -> TutorResponse
}

struct TutorResponse {
    let text: String
    let portugueseTranslation: String
    let feedback: TutorFeedback
    let grammarAccuracy: Int
    let detectedLevel: UserProgress.ProficiencyLevel
    let vocabularyUsed: [String]
}
