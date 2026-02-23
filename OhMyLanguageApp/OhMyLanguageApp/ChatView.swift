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
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .appBackground
        cv.keyboardDismissMode = .interactive
        cv.alwaysBounceVertical = true
        cv.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return cv
    }()
    
    let inputView = ChatInputView()
    
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
        addSubview(inputView)
    }
    
    func setupConstraints() {
        
        inputBottomConstraint = input.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        
        collectionView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            bottom: inputView?.topAnchor,
            trailing: trailingAnchor
        )
        inputView.anchor(leading: leadingAnchor, trailing: trailingAnchor)
        inputBottomConstraint.isActive = true
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
