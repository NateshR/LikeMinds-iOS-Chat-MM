//
//  LMChatFeedViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 14/06/24.
//

import Foundation
import LikeMindsChat
import LikeMindsChatUI
import LikeMindsChatCore

public protocol ChatFeedViewModelProtocol: AnyObject {
    func showDMTab()
}

public class ChatFeedViewModel {
    
    weak var delegate: ChatFeedViewModelProtocol?
    var dmTab: CheckDMTabResponse?
    
    init(_ viewController: ChatFeedViewModelProtocol) {
        self.delegate = viewController
    }
    
    public static func createModule() -> ChatFeedViewController {
        let viewController = ChatFeedViewController()
        viewController.viewModel = ChatFeedViewModel(viewController)
        return viewController
    }
    
    func checkDMTab() {
        LMChatClient.shared.checkDMTab {[weak self] response in
            guard let data = response.data else { return }
            self?.dmTab = data
            self?.delegate?.showDMTab()
        }
    }
    
}
