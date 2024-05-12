//
//  LMChatLinkPreviewCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS
import LikeMindsChat

@IBDesignable
open class LMChatLinkPreviewCell: LMChatMessageCell {
    
    open private(set) lazy var linkPreview: LMChatLinkPreviewContentView = {
        let view = LMChatLinkPreviewContentView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: setupViews
    open override func setupViews() {
        chatMessageView = linkPreview
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
        
        linkPreview.linkPreview.onClickLinkPriview = {[weak self] url in
            self?.delegate?.onClickAttachmentOfMessage(url: url, indexPath: self?.currentIndexPath)
        }
    }
    
}

