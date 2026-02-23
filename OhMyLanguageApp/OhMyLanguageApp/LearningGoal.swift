//
//  LearningGoal.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation

struct LearningGoal: Identifiable, Equatable {
    let id: UUID
    var text: String
    var isCompleted: Bool
    var progress: Double  // 0.0 - 1.0
    
    init(id: UUID = .init(), text: String, isCompleted: Bool = false, progress: Double = 0) {
        self.id = id
        self.text = text
        self.isCompleted = isCompleted
        self.progress = progress
    }
}
