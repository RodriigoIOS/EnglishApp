//
//  AppCoordinator.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 20/02/26.
//

import UIKit


final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let container: AppDIContainer
    private var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController, container: AppDIContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let chatCoordinator = container.makeChatCoordinator(nav: navigationController)
        childCoordinators.append(chatCoordinator)
        chatCoordinator.start()
    }
    
    
}
