//
//  AppConstants.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 21/02/26.
//

import UIKit

enum AppConstants {
    enum Layout {
        static let padding: CGFloat = 16
        static let smallpad: CGFloat = 8
        static let cornerRadius: CGFloat = 18
        static let inputHeight: CGFloat = 52
        static let cellMinHeight: CGFloat = 44
    }
    
    enum API {
        static let anthropicBaseURL = "https://api.anthropic.com/v1/messages"
    }
}
