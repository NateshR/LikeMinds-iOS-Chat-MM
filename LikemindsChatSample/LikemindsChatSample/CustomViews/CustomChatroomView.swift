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
        chatroomImageView.cornerRadius(with: 8)
        self.backgroundColor = .giphyYellow
        self.chatroomCountBadgeLabel.backgroundColor = .red
    }
    
    override func setupLayouts() {
        super.setupLayouts()
    }
}
