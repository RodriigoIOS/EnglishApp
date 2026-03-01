//
//  ViewCodeProtocol.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 20/02/26.
//

import UIKit

protocol ViewCodeProtocol: AnyObject {
    
    func setupHierarchy()
    func setupConstraints()
    func setupStyle()
    func setupBindings()
    func setup()
    
}

extension ViewCodeProtocol {
    func setup() {
        setupHierarchy()
        setupConstraints()
        setupStyle()
        setupBindings()
    }
    
// default vazio para nao obrigar implementacao quando não necessario
    
    func setupBindings() {}
    func setupStyle() {}
}
