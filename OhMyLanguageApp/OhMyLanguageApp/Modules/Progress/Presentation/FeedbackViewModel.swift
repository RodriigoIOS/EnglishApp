//
//  FeedbackViewModel.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 21/02/26.
//

import UIKit
import Combine

@MainActor
final class FeedbackViewModel {
    
    @Published private(set) var feedback: TutorFeedback = .empty
    
    func update(_ fb: TutorFeedback) { feedback = fb }
}
