//
//  CustomParticipantItemView.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 04/07/24.
//

import LikeMindsChatUI
import UIKit

final class CustomParticipantItemView: LMChatParticipantView {
    
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
        containerView.backgroundColor = Appearance.shared.colors.systemYellow
        profileImageView.cornerRadius(with: 8)
        nameLabel.textColor = .red
        customTitle.textColor = .systemGreen
    }
    
}

