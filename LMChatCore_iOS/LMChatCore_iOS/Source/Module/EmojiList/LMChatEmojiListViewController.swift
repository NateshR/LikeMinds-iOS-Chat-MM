//
//  LMChatEmojiListViewController.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 08/05/24.
//

import Foundation
import LikeMindsChatUI

protocol LMChatEmojiListViewDelegate: AnyObject {
    func emojiSelected(emoji: String, conversationId: String?, chatroomId: String?)
}

open class LMChatEmojiListViewController: LMViewController {
    
    lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    weak var delegate: LMChatEmojiListViewDelegate?
    
    let maxDimmedAlpha: CGFloat = 0.6
    var conversationId: String?
    var chatroomId: String?
    
    lazy var dimmedView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .clear
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    lazy var defaultHeight: CGFloat = {
        view.frame.height * 0.3
    }()

    lazy var collectionView: LMCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collection = LMCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.registerCell(type: LMUIComponents.shared.emojiCollectionCell)
        collection.backgroundColor = .white
        return collection
    }()
    
    lazy var titleLabel: LMLabel = {
        let label = LMLabel()
        label.text = "Reactions"
        label.font = Appearance.shared.fonts.textFont1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var topBarLine: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.previewBackgroundColor
        view.setHeightConstraint(with: 4)
        view.setWidthConstraint(with: 60)
        view.cornerRadius(with: 2)
        return view
    }()
    
    var emojiList: [[String]] = []
    
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
        containerView.addSubview(topBarLine)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: dimmedView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 400),
            
            topBarLine.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            topBarLine.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            
            collectionView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
        ])
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        dimmedView.isUserInteractionEnabled = true
        dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDimmedView)))
        fetchEmojis()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
        
    }
    
    func animatePresentContainer() {
        
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
    
    
    func fetchEmojis(){
        
        let emojiRanges = [
            0x1F601...0x1F64F,
            0x1F300...0x1F5FF,
            0x2702...0x27B0,
            0x1F680...0x1F6C0,
            0x1F900...0x1F9FF
        ]
        
        //        0x1F170...0x1F251
        
        for range in emojiRanges {
            var array: [String] = []
            for i in range {
                if let unicodeScalar = UnicodeScalar(i){
                    array.append(String(unicodeScalar))
                }
            }
            
            emojiList.append(array)
        }
        
        collectionView.reloadData()
    }
}

extension LMChatEmojiListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(with: LMUIComponents.shared.emojiCollectionCell, for: indexPath) else { return UICollectionViewCell() }
        cell.configure(data: .init(emojiIcon: emojiList[indexPath.section][indexPath.item]))
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiList[section].count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 44, height: 44)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true) {[weak self] in
            guard let self else { return }
            self.delegate?.emojiSelected(emoji: self.emojiList[indexPath.section][indexPath.item], conversationId: conversationId, chatroomId: chatroomId)
        }
    }
}
