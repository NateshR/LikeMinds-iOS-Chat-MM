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
    func scrollToBottom()
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
    var chatroomActionData: GetChatroomActionsResponse?
    var memberState: GetMemberStateResponse?
    var contentDownloadSettings: [ContentDownloadSetting]?
    var currentDetectedOgTags: LinkOGTags?
    
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
    
    @objc func attachmentPostCompleted(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let conversationId = userInfo[LMUploadConversationsAttachmentOperation.postedId] else {
            return
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getInitialData() {
        NotificationCenter.default.addObserver(self, selector: #selector(attachmentPostCompleted), name: LMUploadConversationsAttachmentOperation.attachmentPostCompleted, object: nil)
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
//                chatroomDataToHeaderConversation(chatroom)
                fetchBottomConversations()
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
            
            fetchChatroomActions()
            markChatroomAsRead()
            fetchMemberState()
            observeConversations(chatroomId: chatroom.id)
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
                insertConversationIntoList(message)
            }
        }
        delegate?.scrollToBottom()
    }
    
    func chatroomDataToHeaderConversation(_ chatroom: Chatroom) {
        let message = chatroomDataToConversation(chatroom)
        insertConversationIntoList(message)
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
        messagesList = []
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
            [.init(messageId: replyConversation.id ?? "", memberTitle: conversation.member?.communityManager(),
                   message: replyConversation.answer,
                   timestamp: replyConversation.createdEpoch,
                      reactions: nil,
                   attachments: replyConversation.attachments?.compactMap({.init(fileUrl: $0.url, thumbnailUrl: $0.thumbnailUrl, fileSize: $0.meta?.size, numberOfPages: $0.meta?.numberOfPage, duration: $0.meta?.duration, fileType: $0.type, fileName: $0.name)}), replied: nil, isDeleted: replyConversation.deletedByMember != nil, createdBy: replyConversation.member?.name, createdByImageUrl: replyConversation.member?.imageUrl, isIncoming: replyConversation.member?.sdkClientInfo?.uuid != UserPreferences.shared.getLMUUID(), messageType: replyConversation.state.rawValue, createdTime: timestampConverted(createdAtInEpoch: replyConversation.createdEpoch ?? 0), ogTags: createOgTags(replyConversation.ogTags))]
        }
        return .init(messageId: conversation.id ?? "", memberTitle: conversation.member?.communityManager(),
                     message: conversation.answer,
                     timestamp: conversation.createdEpoch,
                     reactions: reactionGrouping(conversation.reactions ?? []),
                     attachments: conversation.attachments?.map({.init(fileUrl: $0.url, thumbnailUrl: $0.thumbnailUrl, fileSize: $0.meta?.size, numberOfPages: $0.meta?.numberOfPage, duration: $0.meta?.duration, fileType: $0.type, fileName: $0.name)}),
                     replied: replies,
                     isDeleted: conversation.deletedByMember != nil,
                     createdBy: conversation.member?.name,
                     createdByImageUrl: conversation.member?.imageUrl,
                     isIncoming: conversation.member?.sdkClientInfo?.uuid != UserPreferences.shared.getLMUUID(),
                     messageType: conversation.state.rawValue, createdTime: timestampConverted(createdAtInEpoch: conversation.createdEpoch ?? 0), ogTags: createOgTags(conversation.ogTags))
    }
    
    func createOgTags(_ ogTags: LinkOGTags?) -> LMMessageListView.ContentModel.OgTags? {
        guard let ogTags else {
            return nil
        }
        return .init(link: ogTags.url, thumbnailUrl: ogTags.image, title: ogTags.title, subtitle: ogTags.description)
    }
    
    func reactionGrouping(_ reactions: [Reaction]) -> [LMMessageListView.ContentModel.Reaction] {
        guard !reactions.isEmpty else { return []}
        let grouped = Dictionary(grouping: reactions, by: {$0.reaction})
        var reactionsArray: [LMMessageListView.ContentModel.Reaction] = []
        for item in grouped.keys {
            let membersIds = grouped[item]?.compactMap({$0.member?.uuid}) ?? []
            reactionsArray.append(.init(memberUUID: membersIds, reaction: item, count: membersIds.count))
        }
        return reactionsArray
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
    
    func chatroomDataToConversation(_ chatroom: Chatroom) -> Conversation {
        let conversation = Conversation.builder()
            .date(chatroom.date)
            .answer(chatroom.title)
            .member(chatroom.member)
            .state(ConversationState.chatRoomHeader.rawValue)
            .createdEpoch(chatroom.dateEpoch)
            .id(chatroomId)
            .build()
        return conversation
//        return .init(messageId: chatroom.id, message: chatroom.header, timestamp: chatroom.dateEpoch, reactions: nil, attachments: nil, replied: nil, isDeleted: nil, createdBy: chatroom.member?.name, createdByImageUrl: chatroom.member?.imageUrl, isIncoming: true, messageType: ConversationState.chatRoomHeader.rawValue, createdTime: chatroom.date, ogTags: nil)
    }
    
    func fetchMemberState() {
        LMChatClient.shared.getMemberState {[weak self] response in
            guard let memberState = response.data else { return }
            self?.memberState = memberState
        }
    }
    
    func markChatroomAsRead() {
        let request = MarkReadChatroomRequest.builder()
            .chatroomId(chatroomId)
            .build()
        LMChatClient.shared.markReadChatroom(request: request) { response in
            print(response)
        }
    }
    
    func fetchChatroomActions() {
        let request = GetChatroomActionsRequest.builder()
            .chatroomId(chatroomId)
            .build()
        LMChatClient.shared.getChatroomActions(request: request) {[weak self] response in
            guard let actionsData = response.data else { return }
            self?.chatroomActionData = actionsData
        }
    }
    
    func fetchContentDownloadSetting() {
        LMChatClient.shared.getContentDownloadSettings {[weak self] response in
            guard let settings = response.data?.settings else { return }
            self?.contentDownloadSettings = settings
        }
    }
    
    func muteUnmuteChatroom(value: Bool) {
        let request = MuteChatroomRequest.builder()
            .chatroomId(chatroomViewData?.id ?? "")
            .value(value)
            .build()
        LMChatClient.shared.muteChatroom(request: request) {[weak self] response in
            guard response.success else { return }
            self?.fetchChatroomActions()
        }
    }
    
    func leaveChatroom() {
        let request = LeaveSecretChatroomRequest.builder()
            .chatroomId(chatroomViewData?.id ?? "")
            .isSecret(chatroomViewData?.isSecret ?? false)
            .build()
        LMChatClient.shared.leaveSecretChatroom(request: request) { [weak self] response in
            guard response.success else { return }
            (self?.delegate as? LMViewController)?.dismissViewController()
        }
    }
    
    func performChatroomActions(action: ChatroomAction) {
        guard let fromViewController = delegate as? LMViewController else { return }
        switch action.id {
        case .viewParticipants:
            NavigationScreen.shared.perform(.participants(chatroomId: chatroomViewData?.id ?? "", isSecret: chatroomViewData?.isSecret ?? false), from: fromViewController, params: nil)
        case .invite:
            break
        case .report:
            NavigationScreen.shared.perform(.report(chatroomId: chatroomViewData?.id ?? "", conversationId: nil, memberId: nil), from: fromViewController, params: nil)
        case .leaveChatRoom:
            leaveChatroom()
        case .mute:
            muteUnmuteChatroom(value: true)
        case .unMute:
            muteUnmuteChatroom(value: false)
        default:
            break
        }
    }
    
    func postEditedConversation() {
        
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
    
    func decodeUrl(url: String) {
        let request = DecodeUrlRequest.builder()
            .url(url)
            .build()
        LMChatClient.shared.decodeUrl(request: request) {[weak self] response in
            guard let ogTags = response.data?.ogTags else { return }
            self?.currentDetectedOgTags = ogTags
        }
    }
}

extension LMMessageListViewModel: ConversationChangeDelegate {
    
    func observeConversations(chatroomId: String) {
        let request = ObserveConversationsRequest.builder()
            .chatroomId(chatroomId)
            .listener(self)
            .build()
        LMChatClient.shared.observeConversations(request: request)
    }
    
    public func getPostedConversations(conversations: [Conversation]?) {
        print("getPostedConversations -- \(conversations)")
        guard let conversations else { return }
        for item in conversations {
            insertConversationIntoList(item)
        }
        delegate?.scrollToBottom()
    }
    
    public func getChangedConversations(conversations: [Conversation]?) {
        print("getChangedConversations -- \(conversations)")
        guard let conversations else { return }
        for item in conversations {
            updateConversationIntoList(item)
        }
        delegate?.scrollToBottom()
    }
    
    public func getNewConversations(conversations: [Conversation]?) {
        print("getNewConversations -- \(conversations)")
        guard let conversations else { return }
        for item in conversations {
            insertConversationIntoList(item)
        }
        delegate?.scrollToBottom()
    }
    
}

extension LMMessageListViewModel: LMMessageListControllerDelegate {
    
    func postMessage(message: String?,
                     filesUrls: [AttachmentMediaData]?,
                     shareLink: String?,
                     replyConversationId: String?,
                     replyChatRoomId: String?) {
        guard let communityId = chatroomViewData?.communityId,
              let chatroomId = chatroomViewData?.id else { return }
        let temporaryId = ValueUtils.getTemporaryId()
        var requestBuilder = PostConversationRequest.Builder()
            .chatroomId(self.chatroomId)
            .text(message ?? "")
            .temporaryId(temporaryId)
            .repliedConversationId(replyConversationId)
            .repliedChatroomId(replyChatRoomId)
            .attachmentCount(filesUrls?.count)
        
        if let shareLink, !shareLink.isEmpty, self.currentDetectedOgTags?.url == shareLink {
            requestBuilder = requestBuilder.shareLink(shareLink)
                .ogTags(currentDetectedOgTags)
        }
        let postConversationRequest = requestBuilder.build()
        
        let tempConversation = saveTemporaryConversation(uuid: UserPreferences.shared.getLMUUID() ?? "", communityId: communityId, request: postConversationRequest, fileUrls: filesUrls)
        insertConversationIntoList(tempConversation)
        delegate?.scrollToBottom()
        
        LMChatClient.shared.postConversation(request: postConversationRequest) {[weak self] response in
            guard let self, let conversation = response.data else { return }
            onConversationPosted(response: conversation, updatedFileUrls: filesUrls, tempConversation: tempConversation, replyConversationId: replyConversationId, replyChatRoomId: replyChatRoomId)
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
        guard let conversation = response?.conversation , let conversId = conversation.id else {
            return
        }
        var requestFiles:[AttachmentUploadRequest] = []
        if let updatedFileUrls, !updatedFileUrls.isEmpty {
            requestFiles.append(contentsOf: getUploadFileRequestList(fileUrls: updatedFileUrls, conversationId: conversId, chatroomId: conversation.chatroomId ?? ""))
            LMConversationAttachmentUpload.shared.uploadConversationAttchment(withAttachments: requestFiles, conversationId: conversId)
        }
        guard let response else { return }
        savePostedConversation(requestList: requestFiles, response: response)
    }
    
    func getUploadFileRequestList(fileUrls: [AttachmentMediaData], conversationId: String, chatroomId: String) -> [AttachmentUploadRequest] {
        var fileUploadRequests: [AttachmentUploadRequest] = []
        for (index, attachment) in fileUrls.enumerated() {
            let attachmentMetaDataRequest = AttachmentMetaDataRequest.builder()
                .duration(attachment.duration)
                .numberOfPage(attachment.pdfPageCount)
                .size(attachment.size)
                .build()
            let attachmentDataRequest = AttachmentUploadRequest.builder()
                .name(attachment.mediaName)
                .fileUrl(attachment.url)
                .localFilePath(attachment.url?.absoluteString)
                .fileType(attachment.fileType.rawValue)
                .width(attachment.width)
                .height(attachment.height)
                .awsFolderPath(LMAWSManager.awsFilePathForConversation(chatroomId: chatroomId, conversationId: conversationId, attachmentType: attachment.fileType.rawValue, fileExtension: attachment.url?.pathExtension ?? ""))
                .thumbnailAWSFolderPath(LMAWSManager.awsFilePathForConversation(chatroomId: chatroomId, conversationId: conversationId, attachmentType: attachment.fileType.rawValue, fileExtension: attachment.url?.pathExtension ?? "", isThumbnail: true))
                .thumbnailLocalFilePath(attachment.thumbnailurl?.absoluteString ?? "")
                .meta(attachmentMetaDataRequest)
                .index(index + 1)
                .build()
            fileUploadRequests.append(attachmentDataRequest)
        }
        
        return fileUploadRequests
    }
    
    func savePostedConversation(requestList: [AttachmentUploadRequest],
                                response: PostConversationResponse) {
        let attachments = requestList.map { request in
            return Attachment.builder()
                .name(request.name)
                .url(request.fileUrl?.absoluteString ?? "")
                .type(request.fileType)
                .index(request.index)
                .width(request.width)
                .height(request.height)
                .awsFolderPath(request.awsFolderPath)
                .localFilePath(request.localFilePath)
                .meta(
                    AttachmentMeta.builder()
                        .duration(request.meta?.duration)
                        .numberOfPage(request.meta?.numberOfPage)
                        .size(request.meta?.size)
                        .build()
                )
                .build()
        }
        
        guard let updatedConversation = response.conversation?.toBuilder()
            .attachments(attachments)
            .build()
        else { return }
        let request = SavePostedConversationRequest.builder()
            .conversation(updatedConversation)
            .build()
        LMChatClient.shared.savePostedConversation(request: request)
    }
    
    func postEditedConversation(text: String, shareLink: String?, conversation: Conversation) {
        guard !text.isEmpty, let conversationId = conversation.id else { return }
        let request = EditConversationRequest.builder()
            .conversationId(conversationId)
            .text(text)
            .shareLink(shareLink)
            .build()
        LMChatClient.shared.editConversation(request: request) { resposne in
            guard resposne.success, let conversation = resposne.data?.conversation else { return}
            // Update
        }
    }
    
    func putConversationReaction(conversationId: String, reaction: String) {
        let request = PutReactionRequest.builder()
            .conversationId(conversationId)
            .reaction(reaction)
            .build()
        LMChatClient.shared.putReaction(request: request) { response in
            guard response.success else {
                print(response.errorMessage)
                return
            }
        }
    }
    
    func putChatroomReaction(chatroomId: String, reaction: String) {
        let request = PutReactionRequest.builder()
            .chatroomId(chatroomId)
            .reaction(reaction)
            .build()
        LMChatClient.shared.putReaction(request: request) { response in
            guard response.success else {
                print(response.errorMessage)
                return
            }
        }
    }
    
    func deleteConversations(conversationIds: [String]) {
        let request = DeleteConversationsRequest.builder()
            .conversationIds(conversationIds)
            .build()
        LMChatClient.shared.deleteConversations(request: request) { response in
            
        }
    }
    
    func fetchReplyConversationOnClick(conversation: Conversation, repliedConversationId: String) {
        
    }
    
    func postMessageWithAttachment() {
        
    }
    
    func postMessageWithGifAttachment() {
        
    }
    
    func postMessageWithAudioAttachment() {
        
    }
    
}
