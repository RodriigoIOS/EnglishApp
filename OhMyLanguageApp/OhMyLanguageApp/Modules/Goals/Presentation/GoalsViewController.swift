//
//  GoalsViewController.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 22/02/26.
//

import Foundation
import UIKit
import Combine

final class GoalsViewController: UIViewController {
    
    private let viewModel: GoalsViewModel
    private var cancellables = Set<AnyCancellable>()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    init(viewModel: GoalsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder ) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Objetivos"
        setupTable()
        setupBarButtons()
        bindViewModel()
    }
    
    private func setupTable() {
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GoalCell.self, forCellReuseIdentifier: GoalCell.reuseID)
    }
    
    private func setupBarButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(addGoal))
    }
    
    @objc private func addGoal() {
        let ac = UIAlertController(title: "Novo Objetivo", message: nil, preferredStyle: .alert)
        ac.addTextField { $0.placeholder = "Digite seu objetivo..." }
        ac.addAction(UIAlertAction(title: "Adicionar", style: .default) { [weak self, weak ac] _ in
            self?.viewModel.addGoal(text: ac?.textFields?.first?.text ?? "")
        })
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(ac, animated: true)
        
    }
    
    private func bindViewModel() {
        viewModel.$goals
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in self?.tableView.reloadData() }
            .store(in: &cancellables)
    }
}

extension GoalsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.goals.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GoalCell.reuseID, for: indexPath) as! GoalCell
        cell.configure(with: viewModel.goals[indexPath.row])
        return cell
    }
}

extension GoalsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.toggleGoal(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let del = UIContextualAction(style: .destructive, title: "Remover") { [ weak self ] _, _, done in
            self?.viewModel.removeGoal(at: indexPath.row)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [del])
    }
}
