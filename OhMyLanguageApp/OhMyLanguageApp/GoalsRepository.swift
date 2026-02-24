//
//  GoalsRepository.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
//

import Foundation
import UIKit

final class GoalsRepository: GoalsRepositoryProtocol {
    private let defaults = UserDefaults.standard
    private let key = "learning_goals"
    
    func loadGoals(for language: Language) -> [LearningGoal] {
        let defaults: [[String: Any]] = [
            ["text" : "Dominar cumprimentos básicos", "progress": 0.2],
            ["text": "Aprender verboas no presente simples", "progress": 0.1],
            ["text": "Expandir vocabulário do cotidiano", "progress": 0.0]
        ]
        return defaults.map {
            LearningGoal(text: $0["text"] as? String ?? "",
                         progress: $0["progress"] as? Double ?? 0)
        }
    }
    
    func saveGoals(_ goals: [LearningGoal]) {
        let encoded = goals.map { ["id": $0.id.uuidString,
                                   "text": $0.text,
                                   "completed": $0.isCompleted,
                                   "progress": $0.progress] as [String: Any]
        }
        defaults.set(encoded, forKey: key)
    }
}
