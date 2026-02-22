//
//  ChatCoordinatorDelegate.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 21/02/26.
//

protocol ChatCoordinatorDelegate: AnyObject {
    func chatViewModel(_ vm: ChatViewlModel, didReceiveFeedback: TutorFeedback)
    func chatViewModelDidChangeLanguage(_ vm: ChatViewModel, language: Language)
}
