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
    
    // MARK: - Intents
    
    func sendMessage(_ text: String, goals: [LearningGoal]) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isLoading else { return }
        
        messages.append(Message(text: trimmed, sender: .user))
        isLoading = true
        errorMsg = nil
        
        Task {
            do {
                let (tutorMsg, feedback, newProg) = try await sendMsgUC.execute(
                    userText: trimmed,
                    language: selectedLanguage,
                    history: messages,
                    goals: goals,
                    lessonMode: isLessionMode
                )
                messages.append(tutorMsg)
                progress = trackProgUC.updateHistory(
                    current: newProg,
                    newAccuracy: newProg.grammarAccuracy,
                    newVocab: newProg.vocabularyCount
                )
                coordinatorDelegate.chatViewModel(self, didReceiveFeedback: feedback)
            } catch {
                errorMsg = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func toggletranslation(for id: UUID) -> Bool {
        if translatedIDs.contains(id) {
            translatedIDs.remove(id)
            return false
        } else {
            translatedIDs.insert(id)
            return true
        }
    }
    
    func changeLanguage(_ lang: Language) {
        selectedLanguage = lang
        messages = []
        transalatedIDs = []
        errorMsg = nil
        coordinatorDelegate.chatViewModelDidChangeLanguage(self, language: lang)
    }
}
