//
//  CustomHomeFeedExploreTabView.swift
//  LikemindsChatSample
//
//  Created by Devansh Mohata on 01/06/24.
//

import LikeMindsChatUI
import UIKit

final class CustomHomeFeedExploreTabView: LMChatHomeFeedExploreTabView {
    override func setData(_ data: LMChatHomeFeedExploreTabView.ContentModel) {
        exploreTitleLabel.text = data.tilesName
        if data.unreadCount <= 0 {
            chatroomCountBadgeLabel.text = data.totalCount > 8 ? "9+ Chatrooms" : "\(data.totalCount) Chatrooms"
        } else {
            chatroomCountBadgeLabel.text = data.unreadCount > 8 ? "9+ NEW" : "\(data.unreadCount) NEW"
        }
    }
    
    override func setupAppearance() {
        super.setupAppearance()
        containerView.backgroundColor = .systemFill
        exploreTitleLabel.textColor = .systemGreen
        chatroomCountBadgeLabel.textColor = .systemRed
        chatroomCountBadgeLabel.backgroundColor = .systemGray
    }
}
