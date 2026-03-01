//
//  PanelViewController.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 23/02/26.
//

import Foundation
import UIKit
import Combine

final class PanelViewController: UIViewController {
    private let goalsVM: GoalsViewModel
    private lazy var goalsVC = GoalsViewController(viewModel: goalsVM)
    
    init(goalsVM: GoalsViewModel) {
        self.goalsVM = goalsVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Painel"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close, target: self, action: #selector(dismiss(_ :)))
        add(child: goalsVC)
        goalsVC.view.fillSuperview()
    }
    
    @objc private func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
}
