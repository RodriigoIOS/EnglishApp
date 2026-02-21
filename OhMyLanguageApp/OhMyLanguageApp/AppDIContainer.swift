//
//  AppDIContainer.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 20/02/26.
//

import UIKit

final class AppDIContainer {
    
    //Lembrar de colocar chave da API na constante abaixo -Anthropic
    
    private let apiKey = "Insert_Your_APIKEY"
    
    // MARK: - Services (using lazy singleton)
    
    private lazy var apiClient: AnthropicAPIClientProtocol = AnthropicAPIClient(apiKey: apiKey)
    
    // MARK: - Repositorios
    
    private func makeChatRepo() -> ChatRepositoryProtocol { ChatRepository(apiClient: apiClient) }
    private func makeGoalsRepo() -> GoalsRepositoryProtocol { GoalsRepository() }
    
    // MARK: - Use cases
    
    private func makeSendMsgUC() -> SendMessageUseCaseProtocol { SendMessageUseCase(chatRepository: makeChatRepo()) }
    private func makeManageGoalsUC() -> ManageGoalsUseCaseProtocol { ManageGoalsUseCase(goalsRepository: makeGoalsRepo()) }
    private func makeTrackProgUC() -> TrackProgressUseCaseProtocol { TrackProgressUseCase() }
    
    // MARK: - ViewModels
    
    private func makeChatVM() -> ChatViewModel { ChatViewModel(sendMsgUC: makeSendMsgUC(), trackProgUC: makeTrackProgUC()) }
    private func makeGoalsVM() -> GoalsViewModel { GoalsViewModel(useCase: makeManageGoalsUC()) }
    private func makeFeedbackVM() -> FeedbackViewModel { FeedbackViewModel() }
    private func makeStatsVM() -> StatsViewModel { StatsViewModel() }
    
    // MARK: - Coordinators
    
    func makeChatCoordinator(nav: UINavigationController) -> ChatCoordinator {
        ChatCoordinator(nav: nav,
                        chatVM: makeChatVM(),
                        goalsVM: makeGoalsVM(),
                        feedbackVM: makeFeedbackVM(),
                        statsVM: makeStatsVM())
    }
}
