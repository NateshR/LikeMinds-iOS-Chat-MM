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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = LMCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(type: LMChatMediaImagePreview.self)
        collectionView.registerCell(type: LMChatMediaVideoPreview.self)
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var viewModel: LMChatMediaPreviewViewModel!
    
    open override func setupViews() {
        super.setupViews()
        view.addSubviewWithDefaultConstraints(mediaCollectionView)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        let index = viewModel.startIndex
        if index != 0,
           viewModel.data.indices.contains(index) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.mediaCollectionView.scrollToItem(at: .init(row: index, section: 0), at: .left, animated: false)
            }
        }
    }
}

extension LMChatMediaPreviewScreen: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
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
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
    
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? LMChatMediaVideoPreview)?.stopVideo()
    }
}
