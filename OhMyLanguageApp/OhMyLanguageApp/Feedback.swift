//
//  Feedback.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation

struct TutorFeedback: Equatable {
    let positives: [String]
    let corrections: [String]
    let suggestions: [String]
    
    static var empty: TutorFeedback {
        .init(positives: [], corrections: [], suggestions: [])
    }

}
