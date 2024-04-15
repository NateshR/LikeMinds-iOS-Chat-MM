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
    let conversationFetchLimit: Int = 50
    var chatroomViewData: Chatroom?
    var chatroomWasNotLoaded: Bool = true
    
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
            //1st case -> chatroom is not present, if yes return
            guard let chatroom = response.data?.chatroom, let self else {
                self?.chatroomWasNotLoaded = true
                return
            }
            //2nd case -> chatroom is deleted, if yes return
            if chatroom.deletedBy != nil {
                // Back from this screen
                return
            }
            self.chatroomViewData = chatroom
            
            var medianConversationId: String?
            if let conId = self.chatroomDetailsExtra.conversationId {
                medianConversationId = conId
            } else if let reportedConId = self.chatroomDetailsExtra.reportedConversationId {
                medianConversationId = reportedConId
            } else {
                medianConversationId = nil
            }
            //3rd case -> open a conversation directly through search/deep links
            if let medianConversationId {
                // fetch list from searched or specific conversationid
                fetchIntermediateConversations(chatroom: chatroom, conversationId: medianConversationId)
            }
            //4th case -> chatroom is present and conversation is not present
            else  if chatroom.totalAllResponseCount == 0 {
                // Convert chatroom data into first conversation and display
                chatroomDataToHeaderConversation(chatroom)
            }
            //5th case -> chatroom is opened through deeplink/explore feed, which is open for the first time
            else if chatroomWasNotLoaded {
                fetchBottomConversations()
                chatroomWasNotLoaded = false
            }
            //6th case -> chatroom is present and conversation is present, chatroom opened for the first time from home feed
            else if chatroom.lastSeenConversation == nil {
                // showshimmer
            }
            //7th case -> chatroom is present but conversations are not stored in chatroom
            else if !chatroom.isConversationStored {
                // showshimmer
            }
            //8th case -> chatroom is present and conversation is present, chatroom has no unseen conversations
            else if chatroom.unseenCount == 0 {
                fetchBottomConversations()
            }
            //9th case -> chatroom is present and conversation is present, chatroom has unseen conversations
            else {
                fetchIntermediateConversations(chatroom: chatroom, conversationId: chatroom.lastSeenConversation?.id ?? "")
            }
            
        }
    }
    
    func convertConversationsIntoGroupedArray(conversations: [Conversation]?) -> [LMMessageListView.ContentModel] {
        guard let conversations else { return [] }
        print("conversations ------> \(conversations)")
        let dictionary = Dictionary(grouping: conversations, by: { $0.date })
        var conversationsArray: [LMMessageListView.ContentModel] = []
        for key in dictionary.keys {
            conversationsArray.append(.init(data: (dictionary[key] ?? []).compactMap({self.convertConversation($0)}), section: key ?? "", timestamp: convertDateStringToInterval(key ?? "")))
        }
        return conversationsArray
    }
    
    func fetchBottomConversations() {
        let request = GetConversationsRequest.Builder()
            .chatroomId(chatroomId)
            .limit(conversationFetchLimit)
            .type(.bottom)
            .build()
        let response = LMChatClient.shared.getConversations(withRequest: request)
        guard let conversations = response?.data?.conversations else { return }
        print("conversations ------> \(conversations)")
        chatMessages = conversations
        messagesList.append(contentsOf: convertConversationsIntoGroupedArray(conversations: conversations))
        if conversations.count <= conversationFetchLimit {
            if  let chatroom = chatroomViewData {
                let message = chatroomDataToConversation(chatroom)
                var messages = messagesList.first?.data
                messages?.insert(message, at: 0)
                messagesList[0].data = messages!
            }
        }
        delegate?.reloadChatMessageList()
    }
    
    func chatroomDataToHeaderConversation(_ chatroom: Chatroom) {
        let message = chatroomDataToConversation(chatroom)
        var messages = messagesList.first?.data
        messages?.insert(message, at: 0)
        messagesList[0].data = messages!
    }
    
    func fetchConversationsOnScroll(indexPath: IndexPath, type: GetConversationType) {
        var conversation:Conversation?
        if type == .above {
            let message = messagesList[indexPath.section].data.first
            conversation = chatMessages.first(where: {($0.id ?? "") == (message?.messageId ?? " ")})
        } else {
            let message = messagesList[indexPath.section].data.last
            conversation = chatMessages.first(where: {($0.id ?? "") == (message?.messageId ?? " ")})
        }
        let request = GetConversationsRequest.Builder()
            .chatroomId(chatroomId)
            .limit(conversationFetchLimit)
            .conversation(conversation)
            .observer(self)
            .type(type)
            .build()
        let response = LMChatClient.shared.getConversations(withRequest: request)
        guard let conversations = response?.data?.conversations, conversations.count > 0 else { return }
        print("conversations ------> \(conversations)")
        chatMessages.append(contentsOf: conversations)
        let dictionary = Dictionary(grouping: conversations, by: { $0.date })
        
        for key in dictionary.keys {
            if let index = messagesList.firstIndex(where: {$0.section == (key ?? "")}) {
                guard let messages = dictionary[key]?.sorted(by: {($0.createdEpoch ?? 0) < ($1.createdEpoch ?? 0)}).compactMap({ self.convertConversation($0)}) else { return}
                var messageSectionData = messagesList[index]
                messageSectionData.data.insert(contentsOf: messages, at: 0)
                messagesList[index] = messageSectionData
            } else {
                messagesList.insert((.init(data: (dictionary[key] ?? []).sorted(by: {($0.createdEpoch ?? 0) < ($1.createdEpoch ?? 0)}).compactMap({self.convertConversation($0)}), section: key ?? "", timestamp: convertDateStringToInterval(key ?? ""))), at: 0)
            }
        }
        delegate?.reloadChatMessageList()
    }
    
    func getMoreConversations(indexPath: IndexPath, direction: ScrollDirection) {
        let messageSectionData = messagesList[indexPath.section]
        
        switch direction {
        case .scroll_UP:
            if indexPath.section == 0 && indexPath.row < (messageSectionData.data.count - 2 ) {
                print("fetch more data above data ....")
                fetchConversationsOnScroll(indexPath: indexPath,type: .above)
            }
        case .scroll_DOWN:
            let lastSection = messagesList.count - 1
            if indexPath.section == lastSection && indexPath.row >= 5  {
                print("fetch more data below data ....")
                fetchConversationsOnScroll(indexPath: indexPath,type: .below)
            }
        default:
            break
        }
    }
    
    func fetchIntermediateConversations(chatroom: Chatroom, conversationId: String) {
     
        let getConversationRequest = GetConversationRequest.builder()
            .conversationId(conversationId)
            .build()
        guard let mediumConversation = LMChatClient.shared.getConversation(request: getConversationRequest)?.data?.conversation else { return }
        
        let getAboveConversationRequest = GetConversationsRequest.builder()
            .conversation(mediumConversation)
            .type(.above)
            .chatroomId(chatroomViewData?.id ?? "")
            .limit(conversationFetchLimit)
            .build()
        let aboveConversations = LMChatClient.shared.getConversations(withRequest: getAboveConversationRequest)?.data?.conversations ?? []
        
        let getBelowConversationRequest = GetConversationsRequest.builder()
            .conversation(mediumConversation)
            .type(.below)
            .chatroomId(chatroomViewData?.id ?? "")
            .limit(conversationFetchLimit)
            .build()
        let belowConversations = LMChatClient.shared.getConversations(withRequest: getBelowConversationRequest)?.data?.conversations ?? []
        let allConversations = aboveConversations + [mediumConversation] + belowConversations
        
        chatMessages = allConversations
        messagesList.append(contentsOf: convertConversationsIntoGroupedArray(conversations: allConversations))
        delegate?.reloadChatMessageList()
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
            [.init(messageId: replyConversation.id ?? "",
                   message: replyConversation.answer,
                   timestamp: replyConversation.createdEpoch,
                      reactions: nil,
                      attachments: replyConversation.attachments?.compactMap({$0.url}), replied: nil, isDeleted: replyConversation.deletedByMember != nil, createdBy: replyConversation.member?.name, createdByImageUrl: replyConversation.member?.imageUrl, isIncoming: replyConversation.member?.sdkClientInfo?.uuid != UserPreferences.shared.getLMUUID(), messageType: replyConversation.state.rawValue, createdTime: timestampConverted(createdAtInEpoch: replyConversation.createdEpoch ?? 0))]
        }
        return .init(messageId: conversation.id ?? "",
                     message: conversation.answer,
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
    }
    
    func insertConversationIntoList(_ conversation: Conversation) {
        let conversationDate = conversation.date ?? ""
        if let index = messagesList.firstIndex(where: {$0.section == conversationDate}) {
            var sectionData = messagesList[index]
            sectionData.data.append(convertConversation(conversation))
            sectionData.data.sort(by: {($0.timestamp ?? 0) < ($1.timestamp ?? 0)})
            messagesList[index] = sectionData
        } else {
            messagesList.append((.init(data: [convertConversation(conversation)], section: conversationDate, timestamp: convertDateStringToInterval(conversationDate))))
        }
    }
    
    func updateConversationIntoList(_ conversation: Conversation) {
        let conversationDate = conversation.date ?? ""
        if let index = messagesList.firstIndex(where: {$0.section == conversationDate}) {
            var sectionData = messagesList[index]
            if let conversationIndex = sectionData.data.firstIndex(where: {$0.messageId == conversation.id}) {
                sectionData.data[conversationIndex] = convertConversation(conversation)
            }
            sectionData.data.sort(by: {($0.timestamp ?? 0) < ($1.timestamp ?? 0)})
            messagesList[index] = sectionData
        }
    }
    
    func chatroomDataToConversation(_ chatroom: Chatroom) -> LMMessageListView.ContentModel.Message {
        return .init(messageId: chatroom.id, message: chatroom.header, timestamp: chatroom.dateEpoch, reactions: nil, attachments: nil, replied: nil, isDeleted: nil, createdBy: chatroom.member?.name, createdByImageUrl: chatroom.member?.imageUrl, isIncoming: true, messageType: ConversationState.chatRoomHeader.rawValue, createdTime: chatroom.date)
    }
}

extension LMMessageListViewModel: ConversationClientObserver {
    
    public func initial(_ conversations: [Conversation]) {
//        print("conversations ------> \(conversations)")
//        let dictionary = Dictionary(grouping: conversations, by: { $0.date })
//
//        chatMessages = conversations
//        for key in dictionary.keys {
//            messagesList.append(.init(data: (dictionary[key] ?? []).compactMap({convertConversation($0)}), section: key ?? "", timestamp: convertDateStringToInterval(key ?? "")))
//        }
//        delegate?.reloadChatMessageList()
    }
    
    public func onChange(removed: [Int], inserted: [(Int, Conversation)], updated: [(Int, Conversation)]) {
//        print("Inserted-- \(inserted)")
//        print("updated--- \(updated)")
//        for item in inserted {
//            insertConversationIntoList(item.1)
//        }
//        delegate?.reloadChatMessageList()
    }
    
    func convertDateStringToInterval(_ strDate: String) -> Int {
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        // Set Date Format
        dateFormatter.dateFormat = "d MMM y"
        
        // Convert String to Date
        return Int(dateFormatter.date(from: strDate)?.timeIntervalSince1970 ?? 0)
    }
    
}

extension LMMessageListViewModel: ConversationChangeDelegate {
    
    public func getPostedConversations(conversations: [Conversation]?) {
        guard let conversations else { return }
        for item in conversations {
            insertConversationIntoList(item)
        }
        delegate?.reloadChatMessageList()
    }
    
    public func getChangedConversations(conversations: [Conversation]?) {
        guard let conversations else { return }
        for item in conversations {
            updateConversationIntoList(item)
        }
        delegate?.reloadChatMessageList()
    }
    
    public func getNewConversations(conversations: [Conversation]?) {
        guard let conversations else { return }
        for item in conversations {
            insertConversationIntoList(item)
        }
        delegate?.reloadChatMessageList()
    }
    
}

extension LMMessageListViewModel: LMMessageListControllerDelegate {
    
    func postMessage(message: String,
                     filesUrls: [AttachmentMediaData]?,
                     shareLink: String?,
                     replyConversationId: String?,
                     replyChatRoomId: String?) {
        guard let communityId = chatroomViewData?.communityId,
              let chatroomId = chatroomViewData?.id else { return }
        let temporaryId = ValueUtils.getTemporaryId()
        var requestBuilder = PostConversationRequest.Builder()
            .chatroomId(self.chatroomId)
            .text(message)
            .temporaryId(temporaryId)
            .repliedConversationId(replyConversationId)
            .repliedChatroomId(replyChatRoomId)
            .attachmentCount(filesUrls?.count)
        
        if let shareLink, !shareLink.isEmpty {
            requestBuilder = requestBuilder.shareLink(shareLink)
                .ogTags(nil)
        }
        let postConversationRequest = requestBuilder.build()
        
        let tempConversation = saveTemporaryConversation(uuid: UserPreferences.shared.getLMUUID() ?? "", communityId: communityId, request: postConversationRequest, fileUrls: filesUrls)
        //TODO:  Send temp conversation to ui
        
        LMChatClient.shared.postConversation(request: postConversationRequest) {[weak self] response in
            guard let self, let conversation = response.data?.conversation else { return }
//            insertConversationIntoList(conversation)
//            delegate?.reloadChatMessageList()
            print(response)
        }
    }
    private func saveTemporaryConversation(uuid: String,
                                           communityId: String,
                                           request: PostConversationRequest,
                                           fileUrls: [AttachmentMediaData]?) -> Conversation {
        var conversation = DataModelConverter.shared.convertConversation(uuid: uuid, communityId: communityId, request: request, fileUrls: fileUrls)
        
        let saveConversationRequest = SaveConversationRequest.builder()
            .conversation(conversation)
            .build()
        LMChatClient.shared.saveTemporaryConversation(request: saveConversationRequest)
        if let replyId = conversation.replyConversationId {
            let replyConversationRequest = GetConversationRequest.builder().conversationId(replyId).build()
            if let replyConver = LMChatClient.shared.getConversation(request: replyConversationRequest)?.data?.conversation {
               conversation = conversation.toBuilder()
                    .replyConversation(replyConver)
                    .build()
            }
        }
        let memberRequest = GetMemberRequest.builder()
            .uuid(uuid)
            .build()
        let member = LMChatClient.shared.getMember(request: memberRequest)?.data?.member
        conversation = conversation.toBuilder()
            .member(member)
            .build()
        return conversation
    }
    
    func onConversationPosted(response: PostConversationResponse?,
                              updatedFileUrls: [AttachmentMediaData]?,
                              tempConversation: Conversation?,
                              replyConversationId: String?,
                              replyChatRoomId: String?) {
        guard let conversation = response?.conversation else {
            return
        }
        if let updatedFileUrls, !updatedFileUrls.isEmpty {
            
        }
        
    }
    
    func getUploadFileRequestList(fileUrls: [AttachmentMediaData], conversationId: String, chatroomId: String?) -> [AttachmentUploadRequest] {
        for (index, attachment) in fileUrls.enumerated() {
            let attachmentMetaDataRequest = AttachmentMetaDataRequest.builder()
                .duration(attachment.duration)
                .numberOfPage(attachment.pdfPageCount)
                .size(attachment.size)
                .build()
            let attachmentDataRequest = AttachmentUploadRequest.builder()
                .name(attachment.mediaName)
                .fileUrl(attachment.url)
                .fileType(attachment.fileType.rawValue)
                .width(attachment.width)
                .height(attachment.height)
                .meta(attachmentMetaDataRequest)
                .index(index)
        }
        
        return []
    }
    
    func postMessageWithAttachment() {
        
    }
    
    func postMessageWithGifAttachment() {
        
    }
    
    func postMessageWithAudioAttachment() {
        
    }
    
}
