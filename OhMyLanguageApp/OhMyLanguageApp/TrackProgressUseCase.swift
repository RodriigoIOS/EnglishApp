//
//  TrackProgressUseCase.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 24/02/26.
//  SRP: Apenas atualiza historico de progresso

import Foundation
import UIKit

protocol TrackProgressUseCaseProtocol {
    func updateHistory(current: UserProgress, newAccuracy: Int, newVocab: Int) -> UserProgress
}

final class TrackProgressUseCase: TrackProgressUseCaseProtocol {
    func updateHistory(current: UserProgress, newAccuracy: Int, newVocab: Int) -> UserProgress {
        func append(_ arr: [Int], _ val: Int) -> [Int] {
            Array((arr + [val]).suffix(5))
        }
        var updated = current
        updated.accuracyHistory = append(current.accuracyHistory, newAccuracy)
        updated.vocabularyHistory = append(current.vocabularyHistory, newVocab)
        return updated
    }
}
