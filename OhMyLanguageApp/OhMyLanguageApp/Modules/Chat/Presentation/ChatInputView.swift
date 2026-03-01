//
//  ChatInputView.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 22/02/26.
//

import UIKit

final class ChatInputView: UIView, ViewCodeProtocol {
    
    // MARK: - Subviews
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = .appBody()
        tv.layer.cornerRadius = 20
        tv.backgroundColor = .inputBg
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tv.isScrollEnabled = false
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.font = .appBody()
        l.textColor = .placeholderText
        l.isUserInteractionEnabled = false
        return l
    }()
    
    let sendButton: UIButton = {
        let b = UIButton(type: .system)
        let img = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        b.setImage(img, for: .normal)
        b.tintColor = .accent
        b.isEnabled = false
        return b
    }()
    
    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()
    
    var placeholder: String = "Digite em inglês..." {
        didSet { placeholderLabel.text = placeholder }
    }
    
    var onSend: (() -> Void)?
    
    // MARK: Initializator
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupHierarchy() {
        addSubview(separator)
        addSubview(textView)
        addSubview(placeholderLabel)
        addSubview(sendButton)
    }
    
    func setupConstraints() {
        separator.anchor(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, height: 0.5)
        
        textView.anchor(
            top: topAnchor, topC: 8,
            leading: leadingAnchor, leadingC: 12,
            bottom: bottomAnchor, bottomC: -8,
            trailing: sendButton.leadingAnchor, trailingC: -8
        )
        
        placeholderLabel.anchor(
            top: textView.topAnchor, topC: 10,
            leading: textView.leadingAnchor, leadingC: 14
        )
        
        sendButton.anchor(
            trailing: trailingAnchor, trailingC: -12,
            width: 36, height: 36
        )
        
        sendButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true
    }
    
    func setupStyle() {
        backgroundColor = .systemBackground
    }
    
    func setupBindings() {
        textView.delegate = self
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }
    
    @objc private func sendTapped() { onSend?() }
    
    func clearText() {
        textView.text = ""
        textViewDidChange(textView)
    }
}

extension ChatInputView: UITextViewDelegate {
    func textViewDidChange(_ tv: UITextView) {
        let hasText = !tv.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        placeholderLabel.isHidden = hasText
        sendButton.isEnabled = hasText
        
        // Auto-resize até 4 linhas
        
        let size = tv.sizeThatFits(CGSize(width: tv.frame.width, height: .infinity))
        let maxH: CGFloat = tv.font!.lineHeight * 4 + 20
        tv.isScrollEnabled = size.height > maxH
    }
}
