//
//  LMExploreChatroomViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LikeMindsChatUI
import LikeMindsChat


public class LMExploreChatroomViewModel {
    public static func createModule() throws -> LMExploreChatroomViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewController = LMCoreComponents.shared.exploreChatroomScreen.init()
        viewController.viewModel = LMExploreChatroomViewModel()
        return viewController
    }
}
