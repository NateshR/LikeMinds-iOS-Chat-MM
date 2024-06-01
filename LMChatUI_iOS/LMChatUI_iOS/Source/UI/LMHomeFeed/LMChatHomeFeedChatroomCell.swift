//
//  LMChatHomeFeedChatroomCell.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 09/02/24.
//

import Foundation
import Kingfisher

@IBDesignable
open class LMChatHomeFeedChatroomCell: LMTableViewCell {
    
    public struct ContentModel {
        public let contentView: LMChatHomeFeedChatroomView.ContentModel?
        public init(contentView: LMChatHomeFeedChatroomView.ContentModel?) {
            self.contentView = contentView
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var chatroomView: LMChatHomeFeedChatroomView = {
        let view = LMUIComponents.shared.homeFeedChatroomView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(containerView)
        containerView.addSubview(chatroomView)
        containerView.addSubview(sepratorView)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            chatroomView.topAnchor.constraint(equalTo: containerView.topAnchor),
            chatroomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            chatroomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            chatroomView.bottomAnchor.constraint(equalTo: sepratorView.topAnchor),

            sepratorView.leadingAnchor.constraint(equalTo: chatroomView.chatroomImageView.leadingAnchor, constant: 5),
            sepratorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sepratorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sepratorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        
        sepratorView.backgroundColor = Appearance.shared.colors.gray4
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
    }
    
    
    // MARK: configure
    open func configure(with data: ContentModel) {
        guard let dataView = data.contentView else { return }
        chatroomView.setData(dataView)
    }

}

