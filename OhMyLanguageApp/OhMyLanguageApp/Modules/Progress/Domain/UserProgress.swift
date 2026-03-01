//
//  UserProgress.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation

struct UserProgress: Equatable {
    
    var totalMessages: Int
    var vocabularyCount: Int
    var grammarAccuracy: Int
    var proficiencyLevel: ProficiencyLevel
    var vocabularyHistory: [Int] // Ultimas 5 sessões
    var accuracyHistory: [Int] // Ultimas 5 sessões
    
    enum ProficiencyLevel: String {
        case beginner = "Iniciante"
        case intermediate = "Intermediário"
        case advanced = "Avançado"
        
        var color: String {
            switch self {
            case .beginner: return "green"
            case .intermediate: return "yellow"
            case .advanced: return "red"
            }
        }
    }
    
    static var initial: UserProgress {
        .init(totalMessages: 0, vocabularyCount: 0, grammarAccuracy: 0, proficiencyLevel: .beginner, vocabularyHistory: [20,35,50,65,78], accuracyHistory: [60,65,70,75,80])
    }
}
