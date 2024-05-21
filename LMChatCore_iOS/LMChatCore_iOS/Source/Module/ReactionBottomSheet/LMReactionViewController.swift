//
//  LMReactionViewController.swift
//  SampleApp
//
//  Created by Devansh Mohata on 14/04/24.
//

import UIKit
import LMChatUI_iOS

public protocol LMReactionViewControllerDelegate: AnyObject {
    func reactionDeleted(chatroomId: String?, conversationId: String?)
}

open class LMReactionViewController: LMViewController {
    
    lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    weak var delegate: LMReactionViewControllerDelegate?
    
    lazy var dimmedView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .clear
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    lazy var defaultHeight: CGFloat = {
        view.frame.height * 0.3
    }()
    
    lazy var tableView: LMTableView = {
        let table = LMTableView().translatesAutoresizingMaskIntoConstraints()
        table.dataSource = self
        table.delegate = self
        table.register(LMChatReactionViewCell.self)
        table.separatorStyle = .none
        table.backgroundColor = Appearance.shared.colors.white
        return table
    }()
    
    lazy var collectionView: LMCollectionView = {
        let collection = LMCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.registerCell(type: LMChatReactionTitleCell.self)
        collection.backgroundColor = Appearance.shared.colors.white
        return collection
    }()
    
    lazy var titleLabel: LMLabel = {
        let label = LMLabel()
        label.text = "Reactions"
        label.font = Appearance.shared.fonts.textFont1
        label.textColor = Appearance.shared.colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomLine: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.previewBackgroundColor
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    var viewModel: LMReactionViewModel?
    var titleData: [LMChatReactionTitleCell.ContentModel] = []
    var emojiData: [LMChatReactionViewCell.ContentModel] = []
    
    open override func loadView() {
        super.loadView()
        setupViews()
        setupLayouts()
    }
    
    open override func setupViews() {
        super.setupViews()
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
        containerView.addSubview(bottomLine)
        containerView.addSubview(tableView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            bottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomLine.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.heightAnchor.constraint(equalTo: tableView.widthAnchor),
            tableView.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 8)
        ])
        
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        bottomConstraint?.constant = containerView.frame.height
        
        dimmedView.isUserInteractionEnabled = true
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimmedView)))
        viewModel?.getData()

    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
        
    }
    
    func animatePresentContainer() {
        // Update bottom constraint in animation block
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = 0
            // Call this to trigger refresh constraint
            self.view.layoutIfNeeded()
        }
    }
    
    func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    @objc
    func didTapDimmedView() {
        dismiss(animated: true)
    }
}


extension LMReactionViewController: ReactionViewModelProtocol {
    
    func reactionDeleted() {
        delegate?.reactionDeleted(chatroomId: viewModel?.chatroomId, conversationId: viewModel?.conversationId)
    }
    
    func showData(with collection: [LMChatReactionTitleCell.ContentModel], cells: [LMChatReactionViewCell.ContentModel]) {
        self.titleData = collection
        self.emojiData = cells
        
        collectionView.reloadData()
        tableView.reloadData()
    }
}


extension LMReactionViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emojiData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(LMChatReactionViewCell.self) {
            cell.configure(with: emojiData[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = emojiData[indexPath.row]
        if item.isSelfReaction {
            viewModel?.deleteConversationReaction()
        }
    }
}

extension LMReactionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titleData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(with: LMChatReactionTitleCell.self, for: indexPath) {
            cell.configure(data: titleData[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.fetchReactionBy(reaction: titleData[indexPath.row].title)
    }
}
