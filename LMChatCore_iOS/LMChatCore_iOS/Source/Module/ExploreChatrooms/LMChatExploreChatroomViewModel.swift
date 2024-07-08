//
//  LMChatExploreChatroomViewModel.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 16/05/24.
//

import LikeMindsChatUI
import LikeMindsChat

public protocol LMChatExploreChatroomViewModelProtocol: AnyObject {
    func updateExploreChatroomsData(with data: [LMChatExploreChatroomView.ContentModel])
}

public final class LMChatExploreChatroomViewModel {
    public enum Filter: Int, CaseIterable {
        case newest
        case recentlyActive
        case mostMessages
        case mostParticipants
        
        var stringName: String {
            switch self {
            case .newest:
                return "Newest"
            case .recentlyActive:
                return "Recently Active"
            case .mostParticipants:
                return "Most Participants"
            case .mostMessages:
                return "Most Messages"
            }
        }
    }
    
    private var chatrooms: [Chatroom]
    private var currentPage: Int
    private var filterType: Filter
    private var isLoading: Bool
    private var isPinnedSelected: Bool
    private weak var delegate: LMChatExploreChatroomViewModelProtocol?
    
    init(delegate: LMChatExploreChatroomViewModelProtocol?) {
        self.delegate = delegate
        
        self.chatrooms = []
        self.currentPage = 1
        self.filterType = .newest
        self.isLoading = false
        self.isPinnedSelected = false
    }
    
    public static func createModule() throws -> LMExploreChatroomListView {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewController = LMCoreComponents.shared.exploreChatroomListScreen.init()
        let viewmodel = LMChatExploreChatroomViewModel(delegate: viewController)
        
        viewController.viewModel = viewmodel
        
        return viewController
    }
    
    public func getExploreChatrooms() {
        guard !isLoading else { return }
        
        isLoading = true
        
        let request = GetExploreFeedRequest.builder()
            .orderType(filterType.rawValue)
            .page(currentPage)
            .isPinned(isPinnedSelected)
            .build()
        
        LMChatClient.shared.getExploreFeed(request: request) {[weak self] response in
            guard let self,
                  let chatroomsRes = response.data?.exploreChatrooms,
            !chatroomsRes.isEmpty else {
                self?.isLoading = false
                return
            }
            
            chatrooms.append(contentsOf: chatroomsRes)
            currentPage += 1
            updateChatroomData()
            isLoading = false
        }
    }
    
    public func applyFilter(filter: Filter) {
        filterType = filter
        currentPage = 1
        chatrooms.removeAll()
        getExploreChatrooms()
    }
    
    public func applyFilter() {
        isPinnedSelected.toggle()
        currentPage = 1
        chatrooms.removeAll()
        getExploreChatrooms()
    }
    
    public func followUnfollow(chatroomId: String, status: Bool) {
        let request = FollowChatroomRequest.builder()
            .chatroomId(chatroomId)
            .uuid(UserPreferences.shared.getClientUUID() ?? "")
            .value(status)
            .build()
        
        LMChatClient.shared.followChatroom(request: request) { response in
            guard response.success else {
                return
            }
        }
        LMChatMain.analytics?.trackEvent(for: status ? .chatRoomFollowed : .chatRoomUnfollowed, eventProperties: [
            LMChatAnalyticsKeys.chatroomId.rawValue: chatroomId,
            LMChatAnalyticsKeys.communityId.rawValue: SDKPreferences.shared.getCommunityId(),
            LMChatAnalyticsKeys.source.rawValue: LMChatAnalyticsSource.exploreFeed])
    }
    
    func updateChatroomData() {
        let transformed: [LMChatExploreChatroomView.ContentModel] = chatrooms.compactMap({
            chatroom in
                .init(
                    userName: chatroom.member?.name,
                    title: chatroom.title,
                    chatroomName: chatroom.header,
                    chatroomImageUrl: chatroom.chatroomImageUrl,
                    isSecret: chatroom.isSecret ?? false,
                    isAnnouncementRoom: chatroom.type == ChatroomType.purpose,
                    participantsCount: chatroom.participantsCount ?? 0,
                    messageCount: chatroom.totalResponseCount,
                    isFollowed: chatroom.followStatus ?? false,
                    chatroomId: chatroom.id,
                    externalSeen: chatroom.externalSeen ?? false,
                    isPinned: chatroom.isPinned ?? false
                )
        })
        
        delegate?.updateExploreChatroomsData(with: transformed)
    }
}
