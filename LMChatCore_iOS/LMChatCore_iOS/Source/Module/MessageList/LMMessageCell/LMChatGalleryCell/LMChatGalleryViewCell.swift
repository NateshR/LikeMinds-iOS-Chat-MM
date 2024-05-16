//
//  LMChatGalleryViewCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS
import LikeMindsChat

@IBDesignable
open class LMChatGalleryViewCell: LMChatMessageCell {
    
    open private(set) lazy var galleryMessageView: LMChatGalleryContentView = {
        let view = LMChatGalleryContentView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()

    // MARK: setupViews
    open override func setupViews() {
        chatMessageView = galleryMessageView
        super.setupViews()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    
    // MARK: configure
    open override func setData(with data: ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        super.setData(with: data, delegate: delegate, index: index)
        galleryMessageView.galleryView.onClickAttachment = {[weak self] index in
            self?.delegate?.onClickGalleryOfMessage(attachmentIndex: index, indexPath: self?.currentIndexPath)
        }
        galleryMessageView.layoutIfNeeded()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
    }
}

