//
//  CustomChatroomView.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 07/03/24.
//

import Foundation
import LikeMindsChatUI

class CustomChatroomView: LMChatHomeFeedChatroomView {
    
    
    override func setupAppearance() {
        super.setupAppearance()
//        self.containerView.backgroundColor = .systemYellow
        self.chatroomCountBadgeLabel.backgroundColor = .red
//        self.chatroomCountBadgeLabel.cornerRadius(with: 2)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
    }
    
    
}
