//
//  TypingIndicatorCell.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 22/02/26.
//

import UIKit

final class TypingIndicatorCell: UICollectionViewCell {
    static let reuseID = "TypingIndicatorCell"
    
    private let bubbleView: UIView = {
        let v = UIView()
        v.backgroundColor =  .tutorBubble
        v.layer.cornerRadius = 18
        return v
    }()
    
    private let dot1 = TypingIndicatorCell.makeDot()
    private let dot2 = TypingIndicatorCell.makeDot()
    private let dot3 = TypingIndicatorCell.makeDot()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stack = UIStackView(arrangedSubviews: [dot1, dot2, dot3])
        stack.spacing = 4
        stack.alignment = .center
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(stack)
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            stack.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -12)
        ])
        animate()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private static func makeDot() -> UIView {
        let v  = UIView()
        v.backgroundColor = .secondaryLabel
        v.layer.cornerRadius = 4
        v.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([v.widthAnchor.constraint(equalToConstant: 8),
                                     v.heightAnchor.constraint(equalToConstant: 8)])
        return v
    }
    
    private func animate() {
        [dot1, dot2, dot3].enumerated().forEach { i, dot in
            UIView.animate(withDuration: 0.4, delay: Double(i) * 0.15, options: [.repeat, .autoreverse]) {
                dot.alpha = 0.2
            }
        }
    }
}
