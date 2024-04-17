//
//  ReactionViewController.swift
//  SampleApp
//
//  Created by Devansh Mohata on 14/04/24.
//

import UIKit

open class ReactionViewController: UIViewController {
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    lazy var defaultHeight: CGFloat = {
        view.frame.height * 0.3
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.register(ReactionViewCell.self, forCellReuseIdentifier: "reactionView")
        return table
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(ReactionTitleCell.self, forCellWithReuseIdentifier: "reactionTitle")
        return collection
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reactions"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    var viewModel: ReactionViewModel?
    var titleData: [ReactionTitleCell.ContentModel] = []
    var emojiData: [ReactionViewCell.ContentModel] = []
    
    open override func loadView() {
        super.loadView()
        setupViews()
        setupLayouts()
    }
    
    func setupViews() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(collectionView)
        containerView.addSubview(bottomLine)
        containerView.addSubview(tableView)
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.heightAnchor.constraint(equalToConstant: 50),
            
            bottomLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomLine.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tableView.heightAnchor.constraint(equalTo: tableView.widthAnchor),
            tableView.topAnchor.constraint(equalTo: bottomLine.bottomAnchor, constant: 8)
        ])
        
        bottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomConstraint?.isActive = true
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        bottomConstraint?.constant = containerView.frame.height
        
        dimmedView.isUserInteractionEnabled = true
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimmedView)))
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
        
        viewModel?.getData()
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
        dismiss(animated: false)
    }
}


extension ReactionViewController: ReactionViewModelProtocol {
    func showData(with collection: [ReactionTitleCell.ContentModel], cells: [ReactionViewCell.ContentModel]) {
        self.titleData = collection
        self.emojiData = cells
        
        collectionView.reloadData()
        tableView.reloadData()
    }
}


extension ReactionViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emojiData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reactionView") as! ReactionViewCell
        cell.configure(with: emojiData[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        64
    }
}

extension ReactionViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        titleData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reactionTitle", for: indexPath) as! ReactionTitleCell
        cell.configure(data: titleData[indexPath.row])
        return cell
    }
}
