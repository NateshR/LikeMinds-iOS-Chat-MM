//
//  LMChatLinkPreviewContentView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat
import Kingfisher

@IBDesignable
open class LMChatLinkPreviewContentView: LMChatMessageContentView {
    
    open private(set) lazy var linkPreview: LMChatMessageLinkPreview = {
        let preview = LMChatMessageLinkPreview().translatesAutoresizingMaskIntoConstraints()
        preview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        preview.backgroundColor = .clear
        preview.cornerRadius(with: 12)
        return preview
    }()
    
    //    var clickedOnAttachment: ((String) -> Void)?
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        bubbleView.addArrangeSubview(linkPreview, atIndex: 2)
        
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
    }
    
    open override func setDataView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        super.setDataView(data, delegate: delegate, index: index)
        if data.message?.isDeleted == true {
            linkPreview.isHidden = true
        } else {
            linkPreview(data)
        }
        
    }
    
    func linkPreview(_ data: LMChatMessageCell.ContentModel) {
        guard let ogTags = data.message?.ogTags else {
            linkPreview.isHidden = true
            return
        }
        
        linkPreview.setData(.init(linkUrl: ogTags.link, thumbnailUrl: ogTags.thumbnailUrl, title: ogTags.title, subtitle: ogTags.subtitle))
        linkPreview.isHidden = false
    }
    
    override func prepareToResuse() {
        super.prepareToResuse()
    }
}
