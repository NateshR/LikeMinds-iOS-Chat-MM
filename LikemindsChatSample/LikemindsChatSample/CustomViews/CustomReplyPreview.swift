//
//  CustomReplyPreview.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 01/06/24.
//

import LikeMindsChatUI
import UIKit

final class CustomReplyPreview: LMChatMessageReplyPreview {
    
    override func setupViews() {
        super.setupViews()
    }
    
    override func setupLayouts() {
        super.setupLayouts()
    }
    
    override func setupActions() {
        super.setupActions()
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        containerView.backgroundColor = .systemYellow
        sidePannelColorView.backgroundColor = .green
        userNameLabel.textColor = .cyan
    }
    
}
