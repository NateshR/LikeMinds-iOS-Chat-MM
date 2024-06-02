//
//  LMChatExploreChatroomViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LikeMindsChatUI
import LikeMindsChat

public class LMChatExploreChatroomViewModel {
    public static func createModule() throws -> LMChatExploreChatroomViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewController = LMCoreComponents.shared.exploreChatroomScreen.init()
        viewController.viewModel = LMChatExploreChatroomViewModel()
        return viewController
    }
}
