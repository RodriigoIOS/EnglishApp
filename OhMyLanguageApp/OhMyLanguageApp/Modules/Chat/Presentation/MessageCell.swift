// MARK: - Modules/Chat/View/MessageCell.swift

import UIKit

final class MessageCell: UICollectionViewCell {
    static let reuseID = "MessageCell"

    // MARK: - Subviews
    private let bubbleView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 18
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 15)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11)
        l.textColor = .tertiaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let translationHintLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 11)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    // MARK: - Constraints dinâmicas (posição da bolha)
    private var bubbleLeading:  NSLayoutConstraint!
    private var bubbleTrailing: NSLayoutConstraint!
    private var timeLabelLeading:  NSLayoutConstraint!
    private var timeLabelTrailing: NSLayoutConstraint!

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup (constraints fixas — internas à bolha)
    private func setupCell() {
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        bubbleView.addSubview(translationHintLabel)
        contentView.addSubview(timeLabel)

        // Constraints dinâmicas (começa inativas)
        bubbleLeading  = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        bubbleTrailing = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        timeLabelLeading  = timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14)
        timeLabelTrailing = timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)

        bubbleLeading.isActive  = false
        bubbleTrailing.isActive = false
        timeLabelLeading.isActive  = false
        timeLabelTrailing.isActive = false

        NSLayoutConstraint.activate([
            // Bolha — topo e largura máxima (fixas)
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),

            // Conteúdo interno da bolha (fixas)
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),

            translationHintLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            translationHintLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            translationHintLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            translationHintLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),

            // Time label abaixo da bolha (fixas)
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: 2),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }

    // MARK: - Configure
    func configure(with message: Message, isTranslated: Bool) {
        let isUser = message.sender == .user

        // Texto
        messageLabel.text = isTranslated ? (message.translatedText ?? message.text) : message.text

        // Translation hint
        translationHintLabel.isHidden = isUser || message.translatedText == nil
        translationHintLabel.text = isTranslated ? "Ver original" : "Toque para traduzir"

        // Horário
        let fmt = DateFormatter()
        fmt.timeStyle = .short
        timeLabel.text = fmt.string(from: message.timestamp)

        // Cores
        bubbleView.backgroundColor = isUser ? .systemBlue : UIColor.secondarySystemBackground
        messageLabel.textColor = isUser ? .white : .label
        timeLabel.textAlignment = isUser ? .right : .left

        // Alinha bolha — só troca as constraints dinâmicas
        bubbleLeading.isActive  = !isUser
        bubbleTrailing.isActive = isUser
        timeLabelLeading.isActive  = !isUser
        timeLabelTrailing.isActive = isUser
    }

    // MARK: - AutoLayout size
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let attrs = super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetWidth = UIScreen.main.bounds.width
        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: targetWidth, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        attrs.frame.size = size
        return attrs
    }
}
