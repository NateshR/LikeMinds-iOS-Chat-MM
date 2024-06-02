//
//  CustomExploreChatroomView.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 01/06/24.
//

import LikeMindsChatUI
import UIKit

final class CustomExploreChatroomView: LMChatExploreChatroomView {
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
        chatroomImageView.cornerRadius(with: 8)
        containerView.backgroundColor = .systemTeal
        chatroomNameLabel.textColor = .systemGreen
    }
    
    override func joinButtonTitle(_ isFollowed: Bool) {
        if isFollowed {
            joinButton.setTitle("Joined", for: .normal)
            joinButton.tintColor = Appearance.shared.colors.red
            joinButton.setTitleColor(Appearance.shared.colors.black, for: .normal)
            joinButton.backgroundColor = Appearance.shared.colors.blueGray
        } else {
            joinButton.setTitle("Join", for: .normal)
            joinButton.tintColor = Appearance.shared.colors.blueGray
            joinButton.setTitleColor(Appearance.shared.colors.white, for: .normal)
            joinButton.backgroundColor = Appearance.shared.colors.red
        }
    }
}
