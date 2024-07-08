//
//  CustomMemberListViewController.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 04/07/24.
//

import Foundation
import LikeMindsChatUI
import LikeMindsChatCore

open class CustomMemberListViewController: LMChatMemberListViewController {
    
    
    open override func setupAppearance() {
        super.setupAppearance()
        memberCountsLabel.textColor = .systemRed
//        searchController.searchBar.backgroundColor = .systemGreen
    }
    
    open override func didTapOnCell(indexPath: IndexPath) {
        super.didTapOnCell(indexPath: indexPath)
    }
    
}

open class CustomDMFeedViewController: LMChatDMFeedViewController {
    
    
    open override func setupAppearance() {
        super.setupAppearance()
        newDMFabButton.backgroundColor = .systemRed
        newDMFabButton.setTitleColor(.systemYellow, for: .normal)
    }
    
}
