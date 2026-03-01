//
//  StatsViewModel.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 21/02/26.
//

import UIKit
import Combine

@MainActor
final class StatsViewModel {
    
    @Published private(set) var progress: UserProgress = .initial
    
    func update(_ p: UserProgress) { progress = p }
    
}
