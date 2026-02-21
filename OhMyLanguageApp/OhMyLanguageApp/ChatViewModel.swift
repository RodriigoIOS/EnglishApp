//
//  ChatViewModel.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 21/02/26.
//

import Foundation
import Combine
import UIKit

@MainActor
final class ChatViewModel {
    
    // MARK: - Outputs (observados pelo ViewController via Combine)
    
    @Published private(set) var messages: [Message] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMsg: String?
    @Published private(set) var progress: UserProgress = .initial
    @Published var selectedLanguage: Language = .defaultLanguage
    @Published var isLessionMode: Bool = false
    
    // controla quais células mostram tradução
    private(set) var translatedIDs: Set<UUID> = []
    
    //MARK: - Dependences (DIP)
    
    private let sendMsgUC: SendMessageUseCaseProtocol
    private let trackProgUC: TrackProgressUseCaseProtocol
    
    weak var coordinatorDelegate: ChatCoordinatorDelegate?
    
    init( sendMsgUC: SendMessageUseCaseProtocol,
          trackProgUC: TrackProgressUseCaseProtocol
    ) {
        self.sendMsgUC = sendMsgUC
        self.trackProgUC = trackProgUC
    }
    
}
