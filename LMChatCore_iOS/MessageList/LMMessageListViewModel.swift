//
//  LMMessageListViewModel.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 18/03/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat

public protocol LMMessageListViewModelProtocol: LMBaseViewControllerProtocol {
}

//public typealias ReportContentID = (chatroomId: String?, messageId: String?, memberId: String?)

public final class LMMessageListViewModel {
    
    weak var delegate: LMMessageListViewModelProtocol?
    var chatroomId: String
    
    init(delegate: LMMessageListViewModelProtocol?, chatroomId: String) {
        self.delegate = delegate
        self.chatroomId = chatroomId
    }
    
    
    public static func createModule(withChatroomId chatroomId: String) throws -> LMMessageListViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewcontroller = LMCoreComponents.shared.messageListScreen.init()
        let viewmodel = Self.init(delegate: viewcontroller, chatroomId: chatroomId)
        
        viewcontroller.viewModel = viewmodel
        return viewcontroller
    }
    
    
    func getChatroom() {
        
    }
    
    func syncConversation() {
        LMChatClient.shared.loadConversations(withChatroomId: chatroomId)
    }
}

extension LMMessageListViewModel: ConversationClientObserver {
    
    public func initial(_ conversations: [Conversation]) {
        
    }
    
    public func onChange(removed: [Int], inserted: [(Int, Conversation)], updated: [(Int, Conversation)]) {
    }
    
}

extension LMMessageListViewModel: ConversationChangeDelegate {
    
    public func getPostedConversations(conversations: [Conversation]?) {
        
    }
    
    public func getChangedConversations(conversations: [Conversation]?) {
        
    }
    
    public func getNewConversations(conversations: [Conversation]?) {
        
    }
    
}
