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
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    var viewModel: LMChatMediaPreviewViewModel!
    
    open override func setupViews() {
        super.setupViews()
        view.addSubviewWithDefaultConstraints(mediaCollectionView)
    }
}

extension LMChatMediaPreviewScreen: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            <#code#>
        }
        return UICollectionViewCell()
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}
