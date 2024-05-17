//
//  LMChatroomHeaderMessageCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 25/04/24.
//

import Foundation
import LMChatUI_iOS

@IBDesignable
open class LMChatroomHeaderMessageCell: LMTableViewCell {
    
    public struct ContentModel {
        public let message: LMChatMessageListView.ContentModel.Message?
    }
    
    // MARK: UI Elements
    open private(set) lazy var chatMessageView: LMChatroomHeaderMessageView = {
        let view = LMUIComponents.shared.chatroomHeaderMessageView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        view.cornerRadius(with: 12)
        view.backgroundColor = Appearance.shared.colors.white
        return view
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    var currentIndexPath: IndexPath?
    var originalCenter = CGPoint()
    var replyActionHandler: (() -> Void)?
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        contentView.addSubview(containerView)
        containerView.addSubview(chatMessageView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            chatMessageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            chatMessageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            chatMessageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chatMessageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.backgroundColor
    }
    
    
    // MARK: configure
    open func setData(with data: ContentModel, index: IndexPath) {
        chatMessageView.setData(.init(title: data.message?.message, createdBy: data.message?.createdBy, chatroomImageUrl: data.message?.createdByImageUrl, messageId: data.message?.messageId, customTitle: data.message?.memberTitle, createdTime: data.message?.createdTime))
    }
}
