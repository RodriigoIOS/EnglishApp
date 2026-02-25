//
//  Coordinator.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 20/02/26.
//

import UIKit
import Combine

@MainActor
protocol Coordinator: AnyObject {
    var navigationController: UINavigationController {get}
    func start()
}
