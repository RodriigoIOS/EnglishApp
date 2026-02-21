//
//  UIView+Constraints.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 20/02/26.
//

import UIKit

extension UIView {
    // Ativa o NSLayoutConstraint sem precisar repetir translates = false
    
    func anchor(
        top: NSLayoutYAxisAnchor? = nil, topC: CGFloat = 0,
        leading: NSLayoutXAxisAnchor? = nil, leadingC: CGFloat = 0,
        bottom: NSLayoutYAxisAnchor? = nil, bottomC: CGFloat = 0,
        trailing: NSLayoutXAxisAnchor? = nil, trailingC: CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [NSLayoutConstraint]()
        
        if let top = top { constraints.append(topAnchor.constraint(equalTo: top, constant: topC)) }
        if let leading = leading { constraints.append(leadingAnchor.constraint(equalTo: leading, constant: leadingC)) }
        if let bottom = bottom {constraints.append(bottomAnchor.constraint(equalTo: bottom, constant: bottomC)) }
        if let trailing = trailing {constraints.append(trailingAnchor.constraint(equalTo: trailing, constant: trailingC)) }
        if let w = width {constraints.append(widthAnchor.constraint(equalToConstant: w)) }
        if let h = height {constraints.append(heightAnchor.constraint(equalToConstant: h)) }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func fillSuperview(insets: UIEdgeInsets = .zero) {
        guard let sv = superview else { return }
        anchor(top: sv.topAnchor, topC: insets.top,
               leading: sv.leadingAnchor, leadingC: insets.left,
               bottom: sv.bottomAnchor, bottomC: -insets.bottom,
               trailing: sv.trailingAnchor, trailingC: -insets.right)
    }
    
    func centerInSuperview() {
        guard let sv = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: sv.centerXAnchor),
            centerYAnchor.constraint(equalTo: sv.centerYAnchor)
        ])
    }
}
