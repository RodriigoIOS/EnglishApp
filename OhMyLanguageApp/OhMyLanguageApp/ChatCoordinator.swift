//
//  ChatCoordinator.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 20/02/26.
//

import UIKit

final class ChatCoordinator: Coordinator, ChatCoordinatorDelegate {
    var navigationController: UINavigationController
    private let chatVM: ChatViewModel
    private let goalsVM: GoalsViewModel
    private let feedbackVM: FeedbackViewModel
    private let statsVM: StatsViewModel
    
    init(nav: UINavigationController,
         chatVM: ChatViewModel,
         goalsVM: GoalsViewModel,
         feedbackVM: FeedbackViewModel,
         statsVM: StatsViewModel
    ) {
        self.navigationController = nav
        self.chatVM = chatVM
        self.goalsVM = goalsVM
        self.feedbackVM = feedbackVM
        self.statsVM = statsVM
        self.chatVM.coordinatorDelegate = self
    }
    
    func start() {
        goalsVM.loadGoals(for: chatVM.selectedLanguage)
        let vc = ChatViewController(viewModel: chatVM, goalsVM: goalsVM)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    // MARK: - ChatCoodinatorDelegate
    
    func chatViewModel(_ vm: ChatViewModel, didReceiveFeedback feedback: TutorFeedback) {
        feedbackVM.update(feedback)
        statsVM.update(vm.progress)
    }
    
}
