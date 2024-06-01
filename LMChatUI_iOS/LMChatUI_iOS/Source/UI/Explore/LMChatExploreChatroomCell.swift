//
//  LMExploreChatroomCell.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 19/04/24.
//

import UIKit
import Kingfisher

@IBDesignable
open class LMChatExploreChatroomCell: LMTableViewCell {
    // MARK: UI Elements
    open private(set) lazy var chatroomView: LMChatExploreChatroomView = {
        let view = LMUIComponents.shared.exploreChatroomView.init().translatesAutoresizingMaskIntoConstraints()
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
        
        contentView.pinSubView(subView: containerView)
        containerView.pinSubView(subView: chatroomView)
        
        NSLayoutConstraint.activate([
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
    open func configure(with data: LMChatExploreChatroomView.ContentModel, delegate: LMChatExploreChatroomProtocol) {
        chatroomView.setData(data, delegate: delegate)
    }
}
