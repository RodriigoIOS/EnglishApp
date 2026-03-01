//
//  ChatView.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 21/02/26.
//  Root UIView do modulo de chat - gerencia layout geral

import UIKit

final class ChatView: UIView, ViewCodeProtocol {
    
    // MARK: - Subviews
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        layout.minimumLineSpacing = 4
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .appBackground
        cv.keyboardDismissMode = .interactive
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return cv
    }()
    
    let chatInputView = ChatInputView()
    
    private var inputBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        observeKeyboard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewCodeProtocol
    func setupHierarchy() {
        addSubview(collectionView)
        addSubview(chatInputView)
    }
    
    func setupConstraints() {
        chatInputView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        inputBottomConstraint = chatInputView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor
        )

        NSLayoutConstraint.activate([
            // CollectionView ocupa tudo acima do input
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: chatInputView.topAnchor),

            // Input bar na parte inferior
            chatInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            chatInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputBottomConstraint,
        ])
    }
    
    func setupStyle() {
        backgroundColor = .appBackground
    }
    
    // MARK: - Keyboard handling
    
    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ n: Notification) {
        guard let info = n.userInfo,
              let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let dur = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        inputBottomConstraint.constant = -(frame.height - safeAreaInsets.bottom)
        UIView.animate(withDuration: dur) { self.layoutIfNeeded() }
    }
    
    @objc private func KeyboardWillHide(_ n: Notification) {
        guard let dur = n.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Double else { return }
        inputBottomConstraint.constant = 0
        UIView.animate(withDuration: dur) { self.layoutIfNeeded() }
    }
}
