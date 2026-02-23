//
//  MessageCell.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 22/02/26.
//

import UIKit

final class MessageCell: UICollectionViewCell {
    static let reuseID = "MessageCell"
    
    //MARK: - Subviews
    
    private let bubbleView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 18
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMaxYCorner]
        return v
    }()
    
    private let messageLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = .appBody()
        return l
    }()
    
    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = .appCaption2()
        l.textColor = .tertiaryLabel
        return l
    }()
    
    private let translationHintLabel: UILabel = {
        let l = UILabel()
        l.font = .appCaption2()
        l.textColor = .secondaryLabel
        l.text = "Toque para ver tradução"
        l.isHidden = true
        return l
    }()
    
    // MARK: - State
    private var isUser = false
    private var bubbleLeading: NSLayoutConstraint!
    private var bubbleTrailing: NSLayoutConstraint!
    
    //MARK: - Init
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupCell() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(translationHintLabel)
        contentView.addSubview(timeLabel)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        translationHintLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleLeading = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        bubbleTrailing = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            
            translationHintLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            translationHintLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            translationHintLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            translationHintLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }
    
    //MARK: - Configure
    
    func configure(with message: Message, isTranslated: Bool) {
        isUser = message.sender == .user
        
    // Texto
        
        if isTranslated, let tr = message.translatedText {
            messageLabel.text = tr
        } else {
            messageLabel.text = message.text
        }
        
    // hint traducao
        translationHintLabel.isHidden = isUser || message.translatedText == nil
        if !translationHintLabel.isHidden {
            translationHintLabel.text = isTranslated ? "Ver original" : "Toque para ver tradução"
        }
    
    //Horário
        let fmt = DateFormatter()
        fmt.timeStyle = .short
        timeLabel.text = fmt.string(from: message.timestamp)
        
    // cores e alinhamento
        bubbleView.backgroundColor = isUser ? . userBubble : .tutorBubble
        messageLabel.textColor = isUser ? .white : .label
        timeLabel.textAlignment = isUser ? .right : .left
        
    // alinhar bolha
        bubbleLeading.isActive = !isUser
        bubbleTrailing.isActive = isUser
        
        if isUser {
            timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        } else {
            timeLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor).isActive = true
        }
    }
}
