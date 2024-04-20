//
//  LMExploreChatroomViewModel.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LikeMindsChat

public protocol LMExploreChatroomViewModelDelegate: AnyObject {
    func reloadData()
    func updateExploreChatroomsData()
}

public class LMExploreChatroomViewModel {
    
    weak var delegate: LMExploreChatroomViewModelDelegate?
    var chatrooms: [Chatroom] = []
    var currentPage: Int = 1
    var orderType: Int = 0
    
    init(_ viewController: LMExploreChatroomViewModelDelegate) {
        self.delegate = viewController
    }
    
    public static func createModule() throws -> LMExploreChatroomViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewController = LMCoreComponents.shared.exploreChatroomScreen.init()
        viewController.viewModel = LMExploreChatroomViewModel(viewController)
        return viewController
    }
    
    func getExploreChatrooms() {
        let request = GetExploreFeedRequest.builder()
            .orderType(orderType)
            .page(currentPage)
            .build()
        LMChatClient.shared.getExploreFeed(request: request) {[weak self] response in
            guard let chatrooms = response.data?.exploreChatrooms else { return }
            self?.chatrooms = chatrooms
            self?.delegate?.updateExploreChatroomsData()
        }
    }
}
