//
//  LMChatMediaPreviewScreen.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 19/04/24.
//

import LMChatUI_iOS
import UIKit

open class LMChatMediaPreviewScreen: LMViewController {
    open private(set) lazy var mediaCollectionView: LMCollectionView = {
        let collectionView = LMCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(type: LMChatMediaImagePreview.self)
        collectionView.registerCell(type: LMChatMediaVideoPreview.self)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    var viewModel: LMChatMediaPreviewViewModel!
    
    open override func setupViews() {
        super.setupViews()
        view.addSubview(mediaCollectionView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        mediaCollectionView.addConstraint(top: (view.safeAreaLayoutGuide.topAnchor, 0),
                                          bottom: (view.safeAreaLayoutGuide.bottomAnchor, 0),
                                          leading: (view.safeAreaLayoutGuide.leadingAnchor, 0),
                                          trailing: (view.safeAreaLayoutGuide.trailingAnchor, 0))
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        mediaCollectionView.reloadData()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let index = viewModel.startIndex
        if viewModel.data.indices.contains(index) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.mediaCollectionView.isPagingEnabled = false
                self?.mediaCollectionView.scrollToItem(at: .init(row: index, section: 0), at: .centeredHorizontally, animated: false)
                self?.mediaCollectionView.isPagingEnabled = true
            }
        }
    }
}

extension LMChatMediaPreviewScreen: UICollectionViewDataSource, UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.data[indexPath.row].type {
        case .image:
            if let cell = collectionView.dequeueReusableCell(with: LMChatMediaImagePreview.self, for: indexPath) {
                cell.configure(with: viewModel.data[indexPath.row].url)
                return cell
            }
        case .video:
            if let cell = collectionView.dequeueReusableCell(with: LMChatMediaVideoPreview.self, for: indexPath) {
                cell.configure(with: viewModel.data[indexPath.row].url)
                return cell
            }
        }
        return UICollectionViewCell()
    }
        
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? LMChatMediaVideoPreview)?.stopVideo()
        (cell as? LMChatMediaImagePreview)?.resetZoomScale()
    }
}
