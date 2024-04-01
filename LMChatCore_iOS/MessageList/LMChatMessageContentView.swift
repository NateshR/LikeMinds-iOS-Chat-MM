//
//  LMChatMessageContentView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 22/03/24.
//

import Foundation
import LMChatUI_iOS
import Kingfisher

@IBDesignable
open class LMChatMessageContentView: LMView {
    
    open private(set) lazy var bubbleView: LMChatMessageBubbleView = {
        return LMCoreComponents.shared
            .messageBubbleView
            .init()
            .translatesAutoresizingMaskIntoConstraints()
    }()

    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(bubbleView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            bubbleView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bubbleView.topAnchor.constraint(equalTo: topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}

