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
    func reloadChatMessageList()
}

public typealias ChatroomDetailsExtra = (chatroomId: String, conversationId: String?, reportedConversationId: String?)

public final class LMMessageListViewModel {
    
    weak var delegate: LMMessageListViewModelProtocol?
    var chatroomId: String
    var chatroomDetailsExtra: ChatroomDetailsExtra
    var chatMessages: [Conversation] = []
    var messagesList:[LMMessageListView.ContentModel] = []
    
    init(delegate: LMMessageListViewModelProtocol?, chatroomExtra: ChatroomDetailsExtra) {
        self.delegate = delegate
        self.chatroomId = chatroomExtra.chatroomId
        self.chatroomDetailsExtra = chatroomExtra
    }
    
    
    public static func createModule(withChatroomId chatroomId: String) throws -> LMMessageListViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewcontroller = LMCoreComponents.shared.messageListScreen.init()
        let viewmodel = Self.init(delegate: viewcontroller, chatroomExtra: (chatroomId, nil, nil))
        
        viewcontroller.viewModel = viewmodel
        viewcontroller.delegate = viewmodel
        return viewcontroller
    }
    
    func getInitialData() {
        let chatroomRequest = GetChatroomRequest.Builder().chatroomId(chatroomId).build()
        LMChatClient.shared.getChatroom(request: chatroomRequest) {[weak self] response in
            guard let chatroom = response.data?.chatroom, let self else { return }
            if chatroom.deletedBy != nil {
                return
            }
            
            var searchConversationId: String?
            if let conId = self.chatroomDetailsExtra.conversationId {
                searchConversationId = conId
            } else if let reportedConId = self.chatroomDetailsExtra.reportedConversationId {
                searchConversationId = reportedConId
            } else {
                searchConversationId = nil
            }
            
            if let searchConversationId {
                // fetch list from searched or specific conversationid
            }
            
            if chatroom.totalAllResponseCount == 0 {
                // Convert chatroom data into first conversation and display
            }
            
        }
    }
    
    func getConversations() {
        let request = GetConversationsRequest.Builder()
            .chatroomId(chatroomId)
            .limit(200)
            .observer(self)
            .type(.above)
            .build()
        LMChatClient.shared.getConversations(withRequest: request)
    }
    
    func syncConversation() {
        let chatroomRequest = GetChatroomRequest.Builder().chatroomId(chatroomId).build()
        LMChatClient.shared.getChatroom(request: chatroomRequest) {[weak self] response in
            guard let self else { return }
            if response.data?.chatroom?.isConversationStored == true{
                LMChatClient.shared.loadConversations(withChatroomId: chatroomId, loadType: .reopen)
            } else {
                LMChatClient.shared.loadConversations(withChatroomId: chatroomId, loadType: .firstTime)
            }
        }
    }
    
    func convertConversation(_ conversation: Conversation) -> LMMessageListView.ContentModel.Message {
        var replies: [LMMessageListView.ContentModel.Message] = []
        if let replyConversation = conversation.replyConversation {
            replies =
                [.init(message: conversation.replyConversation?.answer,
                      timestamp: nil,
                      reactions: nil,
                      attachments: conversation.replyConversation?.attachments?.compactMap({$0.url}), replied: nil, isDeleted: conversation.replyConversation?.deletedByMember != nil, createdBy: conversation.replyConversation?.member?.name, createdByImageUrl: conversation.replyConversation?.member?.imageUrl, isIncoming: conversation.replyConversation?.member?.sdkClientInfo?.uuid != UserPreferences.shared.getLMUUID(), messageType: conversation.replyConversation?.state.rawValue ?? 0, createdTime: timestampConverted(createdAtInEpoch: conversation.replyConversation?.createdEpoch ?? 0))]
        }
        return .init(message: conversation.answer,
                     timestamp: conversation.createdEpoch,
                     reactions: conversation.reactions?.compactMap({.init(memberUUID: $0.member?.uuid ?? "", reaction: $0.reaction)}),
                     attachments: conversation.attachments?.map({$0.url ?? ""}),
                     replied: replies,
                     isDeleted: conversation.deletedByMember != nil,
                     createdBy: conversation.member?.name,
                     createdByImageUrl: conversation.member?.imageUrl,
                     isIncoming: conversation.member?.sdkClientInfo?.uuid != UserPreferences.shared.getLMUUID(),
                     messageType: conversation.state.rawValue, createdTime: timestampConverted(createdAtInEpoch: conversation.createdEpoch ?? 0))
    }
    
    func timestampConverted(createdAtInEpoch: Int) -> String? {
        guard createdAtInEpoch > .zero else { return nil }
        var epochTime = Double(createdAtInEpoch)
        
        if epochTime > Date().timeIntervalSince1970 {
            epochTime = epochTime / 1000
        }
        
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: date)
        /*
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            return dateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter.string(from: date)
        }
         */
    }
}

extension LMMessageListViewModel: ConversationClientObserver {
    
    public func initial(_ conversations: [Conversation]) {
        print("conversations ------> \(conversations)")
        let dictionary = Dictionary(grouping: conversations, by: { $0.date })
        chatMessages = conversations
        messagesList = [.init(data: chatMessages.map({ conversation in
            convertConversation(conversation)
        }), section: "20 Apr 2024")]
        delegate?.reloadChatMessageList()
    }
    
    public func onChange(removed: [Int], inserted: [(Int, Conversation)], updated: [(Int, Conversation)]) {
        print("Inserted-- \(inserted)")
        print("updated--- \(updated)")
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

extension LMMessageListViewModel: LMMessageListControllerDelegate {
    
    func postMessage(message: String) {
        let attributedParseMessage = message
        let request = PostConversationRequest.Builder()
            .chatroomId(self.chatroomId)
            .text(attributedParseMessage)
            .temporaryId(UUID().uuidString)
            .build()
        LMChatClient.shared.postConversation(request: request) { response in
            print(response)
        }
    }
    
    func postMessageWithAttachment() {
        
    }
    
    func postMessageWithGifAttachment() {
        
    }
    
    func postMessageWithAudioAttachment() {
        
    }
}
