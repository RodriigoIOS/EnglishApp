//
//  GoalCell.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 22/02/26.
//

import UIKit

final class GoalCell: UITableViewCell, ViewCodeProtocol {

    static let reuseID = "GoalCell"
    
    private let checkIcon = UIImageView()
    private let titleLabel = UILabel()
    private let progressBar = UIProgressView(progressViewStyle: .default)
    private let pctLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func setupHierarchy() {
        [checkIcon, titleLabel, progressBar, pctLabel].forEach { contentView.addSubview($0) }
    }
    
    func setupConstraints() {
        checkIcon.anchor(leading: contentView.leadingAnchor, leadingC: 16, width: 22, height: 22)
        checkIcon.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 26).isActive = true
        
        titleLabel.anchor(top: contentView.topAnchor, topC: 12,
                          leading: checkIcon.trailingAnchor, leadingC: 10,
                          trailing: contentView.trailingAnchor, trailingC: -16)
        
        progressBar.anchor(top: titleLabel.bottomAnchor, topC: 6,
                           leading: titleLabel.leadingAnchor,
                           trailing: pctLabel.leadingAnchor, trailingC: -8)
        
        progressBar.centerYAnchor.constraint(equalTo: pctLabel.centerYAnchor).isActive = true
        
        pctLabel.anchor(top: progressBar.topAnchor,
                        bottom: contentView.bottomAnchor,
                        bottomC: -12,
                        trailing: contentView.trailingAnchor,
                        trailingC: -16,
                        width: 40)
    }
    
    func setupStyle() {
        titleLabel.font = .appSub()
        titleLabel.numberOfLines = 0
        pctLabel.font = .appCaption2()
        pctLabel.textColor = .secondaryLabel
        pctLabel.textAlignment = .right
        progressBar.tintColor = .accent
        selectionStyle = .none
    }
    
    func configure(with goal: LearningGoal) {
        titleLabel.text = goal.text
        titleLabel.textColor = goal.isCompleted ? .secondaryLabel : .label
        let attr: [NSAttributedString.Key: Any] = goal.isCompleted
            ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue, .foregroundColor: UIColor.secondaryLabel]
            : [:]
        titleLabel.attributedText = NSAttributedString(string: goal.text, attributes: attr)
        progressBar.progress = Float(goal.progress)
        pctLabel.text = "\(Int(goal.progress * 100))%"
        let img = UIImage(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
        checkIcon.image = img
        checkIcon.tintColor = goal.isCompleted ? .systemGreen : .secondaryLabel
    }
}
