//
//  CustomDMApproveRejectView.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 04/07/24.
//

import LikeMindsChatUI
import UIKit

final class CustomDMApproveRejectView: LMChatApproveRejectView {
    
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
        backgroundColor = Appearance.shared.colors.systemYellow
        approveButton.backgroundColor = .systemGreen
        rejectButton.backgroundColor = .systemGreen
        approveButton.setFont(Appearance.shared.fonts.headingFont2)
        approveButton.setTitleColor(Appearance.shared.colors.red, for: .normal)
        rejectButton.setFont(Appearance.shared.fonts.headingFont2)
        rejectButton.setTitleColor(Appearance.shared.colors.red, for: .normal)
    }
    
    override func approveButtonClicked(_ sender: UIButton) {
        super.approveButtonClicked(sender)
    }
    
    override func rejectButtonClicked(_ sender: UIButton) {
        super.rejectButtonClicked(sender)
    }
    
}
