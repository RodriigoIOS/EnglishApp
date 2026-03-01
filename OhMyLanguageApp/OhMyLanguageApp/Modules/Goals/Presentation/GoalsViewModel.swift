//
//  GoalsViewModel.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 21/02/26.
//

import UIKit
import Combine

@MainActor
final class GoalsViewModel {
    @Published private(set) var goals: [LearningGoal] = []
    
    private let useCase: ManageGoalsUseCaseProtocol
    
    init(useCase: ManageGoalsUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func loadGoals(for language: Language) {
        goals = useCase.loadGoals(for: language)
    }
    
    func toggleGoal(at index: Int) {
        guard index < goals.count else { return }
        goals = useCase.toggleCompletion(goal: goals[index], in: goals)
    }
    
    func addGoal(text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        goals = useCase.addGoal(text: text, to: goals)
    }
    
    func removeGoal(at index: Int) {
        guard index < goals.count else { return }
        goals = useCase.removeGoal(id: goals[index].id, from: goals)
    }
}
