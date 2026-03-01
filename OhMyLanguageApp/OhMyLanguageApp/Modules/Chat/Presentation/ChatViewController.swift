//
//  ChatViewController.swift
//  OhMyLanguageApp
//
//  Created by Rodrigo on 22/02/26.
//

import UIKit
import Combine

final class ChatViewController: UIViewController {
    
    //MARK: - Dependencies
    
    private let viewModel: ChatViewModel
    private let goalsVM: GoalsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Root View
    private lazy var rootView = ChatView()
    override func loadView() {
        view = rootView
    }
    
    //MARK: - DataSource state
    private var showTyping = false
    
    //MARK: - Init
    init(viewModel: ChatViewModel, goalsVM: GoalsViewModel) {
        self.viewModel = viewModel
        self.goalsVM = goalsVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        setupInput()
        bindViewModel()
    }
    
    //MARK: - Navigation
    private func setupNavigation() {
        title = "Tutor de Idiomas"
        navigationController?.navigationBar.prefersLargeTitles = false
        
    // Botão de idioma (esquerda)
        let langBtn = UIBarButtonItem(title: viewModel.selectedLanguage.flag + " ▾",
                                      style: .plain,
                                      target: self,
                                      action: #selector(showLanguagePicker))
        navigationItem.leftBarButtonItem = langBtn
        
    // Botão de painel (direita)
        let panelBtn = UIBarButtonItem(image: UIImage(systemName: "chart.bar.fill"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(showPanel))
    // Botão de modo lição
        let modeBtn = UIBarButtonItem(title: "Chat",
                                      style: .plain,
                                      target: self,
                                      action: #selector(toggleLessonMode))
        navigationItem.rightBarButtonItems = [panelBtn, modeBtn]
    }
    
    @objc private func showLanguagePicker() {
        let ac = UIAlertController(title: "Escolha o idioma", message: nil, preferredStyle: .actionSheet)
        Language.all.forEach { lang in
            ac.addAction(UIAlertAction(title:"\(lang.flag) \(lang.name)", style: .default) { [weak self] _ in
                guard let self else { return }
                self.viewModel.changeLanguage(lang)
                self.goalsVM.loadGoals(for: lang)
                self.rootView.chatInputView.placeholder = "Digite em \(lang.name)..."
            })
        }
        ac.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true)
    }
    
    @objc private func showPanel() {
        let vc = PanelViewController(goalsVM: goalsVM)
        let nav = UINavigationController(rootViewController: vc)
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        present(nav, animated: true)
    }
    
    @objc private func toggleLessonMode() {
        viewModel.isLessonMode.toggle()
        let title = viewModel.isLessonMode ? "Lição" : "Chat"
        navigationItem.rightBarButtonItems?[1].title = title
    }
    
    // MARK: - CollectionView Setup
    private func setupCollectionView() {
        let cv = rootView.collectionView
        cv.delegate = self
        cv.dataSource = self
        cv.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseID)
        cv.register(TypingIndicatorCell.self, forCellWithReuseIdentifier: TypingIndicatorCell.reuseID)
        
    }
    
    // MARK: - Input Setup
    private func setupInput() {
        rootView.chatInputView.placeholder = "Digite em \(viewModel.selectedLanguage.name)..."
        rootView.chatInputView.onSend = { [weak self] in
            guard let self else { return }
            let text = self.rootView.chatInputView.textView.text ?? ""
            self.viewModel.sendMessage(text, goals: self.goalsVM.goals)
            self.rootView.chatInputView.clearText()
        }
    }
    
    // MARK: - Bindings (combine)
    private func bindViewModel() {
        viewModel.$messages
                .receive(on: DispatchQueue.main)
                .sink { [weak self] msgs in
                    guard let self else { return }
                    self.rootView.collectionView.reloadData()
                    guard !msgs.isEmpty else { return }
                    let lastIdx = IndexPath(item: msgs.count - 1, section: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.rootView.collectionView.scrollToItem(at: lastIdx, at: .bottom, animated: true)
                    }
                }
                .store(in: &cancellables)

            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { [weak self] loading in
                    guard let self else { return }
                    self.showTyping = loading
                    self.rootView.collectionView.reloadData()
                    self.rootView.chatInputView.sendButton.isEnabled = !loading
                }
                .store(in: &cancellables)

            viewModel.$errorMsg
                .receive(on: DispatchQueue.main)
                .compactMap { $0 }
                .sink { [weak self] msg in
                    let ac = UIAlertController(title: "Erro", message: msg, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                }
                .store(in: &cancellables)
    }
    
    private func reloadAndScroll(msgs: [Message]) {
        rootView.collectionView.reloadData()
        guard !msgs.isEmpty else { return }
        let lastIdx = IndexPath(item: msgs.count - 1, section: 0)
        rootView.collectionView.scrollToItem(at: lastIdx, at: .bottom, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.messages.count + (showTyping ? 1 : 0)
        print("🔢 numberOfItems: \(count)")
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Typing indicator (Ultima celula durante loading)
        print("🟡 Renderizando célula \(indexPath.item) — total: \(viewModel.messages.count)")
        if showTyping && indexPath.item == viewModel.messages.count {
            return collectionView.dequeueReusableCell(withReuseIdentifier: TypingIndicatorCell.reuseID, for: indexPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseID, for: indexPath) as! MessageCell
        let msg = viewModel.messages[indexPath.item]
        cell.configure(with: msg, isTranslated: viewModel.translatedIDs.contains(msg.id))
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension ChatViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < viewModel.messages.count else { return }
        let msg = viewModel.messages[indexPath.item]
        guard msg.sender == .tutor else { return }
        _ = viewModel.toggletranslation(for: msg.id)
        collectionView.reloadItems(at: [indexPath])
    }
}
