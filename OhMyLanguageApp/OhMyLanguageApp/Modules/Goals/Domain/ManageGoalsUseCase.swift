//
//  ManageGoalsUseCase.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
// SRP: Gerencia apenas objetivos de aprendizado

import Foundation
import UIKit

protocol ManageGoalsUseCaseProtocol {
    func loadGoals(for language: Language) -> [LearningGoal]
    func toggleCompletion(goal: LearningGoal, in goals: [LearningGoal]) -> [LearningGoal]
    func addGoal(text: String, to goals: [LearningGoal]) -> [LearningGoal]
    func removeGoal(id: UUID, from goals: [LearningGoal]) -> [LearningGoal]
}

final class ManageGoalsUseCase: ManageGoalsUseCaseProtocol {
    private let goalsRepository: GoalsRepositoryProtocol
    
    init(goalsRepository: GoalsRepositoryProtocol) {
        self.goalsRepository = goalsRepository
    }
    
    func loadGoals(for language: Language) -> [LearningGoal] {
        goalsRepository.loadGoals(for: language)
    }
    
    func toggleCompletion(goal: LearningGoal, in goals: [LearningGoal]) -> [LearningGoal] {
        goals.map {
            guard $0.id == goal.id else { return $0}
            var updated = $0
            updated.isCompleted = !$0.isCompleted
            updated.progress = updated.isCompleted ? 1.0 : $0.progress
            return updated
        }
    }
    
    func addGoal(text: String, to goals: [LearningGoal]) -> [LearningGoal] {
        goals + [LearningGoal(text: text)]
    }
    
    func removeGoal(id: UUID, from goals: [LearningGoal]) -> [LearningGoal] {
        goals.filter { $0.id != id }
    }
}
