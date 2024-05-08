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
    
    enum Filter: Int {
        case newest = 0
        case recentlyActive = 1
        case mostParticipants = 3
        case mostMessages = 2
        
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
    
    weak var delegate: LMExploreChatroomViewModelDelegate?
    var chatrooms: [Chatroom] = []
    var currentPage: Int = 1
    var orderType: Filter = .newest
    var isLoading = false
    
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
        if isLoading { return }
        isLoading = true
        let request = GetExploreFeedRequest.builder()
            .orderType(orderType.rawValue)
            .page(currentPage)
            .build()
        LMChatClient.shared.getExploreFeed(request: request) {[weak self] response in
            guard let self, 
                    let chatroomsRes = response.data?.exploreChatrooms,
                  !chatroomsRes.isEmpty else {
                self?.isLoading = false
                return
            }
            if chatrooms.isEmpty || currentPage == 1 {
                chatrooms = chatroomsRes
            } else {
                chatrooms.append(contentsOf: chatroomsRes)
            }
            currentPage += 1
            delegate?.updateExploreChatroomsData()
            isLoading = false
        }
    }
    
    func applyFilter(filter: Filter) {
        orderType = filter
        currentPage = 1
        getExploreChatrooms()
    }
    
    func followUnfollow(chatroomId: String, status: Bool) {
        // TODO: Analytics Community ID
        LMChatMain.analytics?.trackEvent(for: status ? .chatRoomFollowed : .chatRoomUnfollowed, eventProperties: [LMChatAnalyticsKeys.chatroomId.rawValue: chatroomId,
                                                                                                                 LMChatAnalyticsKeys.communityId.rawValue: "",
                                                                                                                 LMChatAnalyticsKeys.source.rawValue: LMChatAnalyticsSource.communityFeed])
        
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
    }
}
