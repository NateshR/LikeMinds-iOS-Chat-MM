//
//  LMChatMessageCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 22/03/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS
import LikeMindsChat

@IBDesignable
open class LMChatMessageCell: LMTableViewCell {
    
    public struct ContentModel {
        public let message: LMMessageListView.ContentModel.Message?
    }
    
    // MARK: UI Elements
    open private(set) lazy var chatMessageView: LMChatMessageContentView = {
        let view = LMCoreComponents.shared.messageContentView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        chatMessageView.prepareToResuse()
    }
    
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
            chatMessageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
        chatMessageView.backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.backgroundColor
    }
    
    
    // MARK: configure
    open func configure(with data: ContentModel) {
        chatMessageView.setDataView(data)
    }
}

