//
//  GoalsRepositoryProtocol.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation

protocol GoalsRepositoryProtocol {
    func loadGoals(for language: Language) -> [LearningGoal]
    func saveGoals(_ goals: [LearningGoal])
}
