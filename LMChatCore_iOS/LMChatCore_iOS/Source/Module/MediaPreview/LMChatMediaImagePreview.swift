//
//  LMChatMediaImagePreview.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 19/04/24.
//

import Kingfisher
import LikeMindsChatUI
import UIKit

open class LMChatMediaImagePreview: LMCollectionViewCell {
    open private(set) lazy var previewImageView: LMChatZoomImageViewContainer = {
        let image = LMChatZoomImageViewContainer()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .black
        return image
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        resetZoomScale()
    }
    
    open override func setupViews() {
        super.setupViews()
        contentView.addSubviewWithDefaultConstraints(previewImageView)
    }
    
    open func configure(with data: LMChatMediaPreviewContentModel) {
        guard let url = URL(string: data.mediaURL) else { return }
        previewImageView.configure(with: url)
    }
    
    open func resetZoomScale() {
        previewImageView.zoomScale = 1
    }
}
