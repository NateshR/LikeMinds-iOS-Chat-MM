//
//  LMChatMediaImagePreview.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 19/04/24.
//

import Kingfisher
import LMChatUI_iOS
import UIKit


open class LMChatMediaImagePreview: LMCollectionViewCell {
    open private(set) lazy var previewImageView: ZoomImageViewContainer = {
        let image = ZoomImageViewContainer()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    open override func setupViews() {
        super.setupViews()
        contentView.addSubviewWithDefaultConstraints(previewImageView)
    }
    
    open func configure(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        previewImageView.configure(with: url)
    }
}
