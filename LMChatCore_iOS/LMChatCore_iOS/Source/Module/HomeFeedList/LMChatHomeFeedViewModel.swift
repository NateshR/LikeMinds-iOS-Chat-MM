//
//  LMChatHomeFeedViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 12/02/24.
//

import Foundation
import LikeMindsChat
import LikeMindsChatUI

public protocol LMHomeFeedViewModelProtocol: AnyObject {
    func reloadData()
    func updateHomeFeedChatroomsData()
    func updateHomeFeedExploreCountData()
}

public class LMChatHomeFeedViewModel {
    
    weak var delegate: LMHomeFeedViewModelProtocol?
    var chatrooms: [Chatroom] = []
    var exploreTabCountData: GetExploreTabCountResponse?
    var memberProfile: User?
    
    init(_ viewController: LMHomeFeedViewModelProtocol) {
        self.delegate = viewController
    }
    
    public static func createModule() throws -> LMChatHomeFeedViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewController = LMCoreComponents.shared.homeFeedScreen.init()
        viewController.viewModel = LMChatHomeFeedViewModel(viewController)
        return viewController
    }
    
    func fetchUserProfile() {
        memberProfile = LMChatClient.shared.getLoggedInUser()
    }
    
    func getChatrooms() {
        fetchUserProfile()
        LMChatClient.shared.getChatrooms(withObserver: self)
        LMChatClient.shared.observeLiveHomeFeed(withCommunityId: SDKPreferences.shared.getCommunityId() ?? "")
    }
    
    func syncChatroom() {
        LMChatClient.shared.syncChatrooms()
    }
    
    func getExploreTabCount() {
        LMChatClient.shared.getExploreTabCount {[weak self] response in
            guard let exploreTabCountData = response.data else { return }
            self?.exploreTabCountData = exploreTabCountData
            self?.delegate?.updateHomeFeedExploreCountData()
        }
    }
    
    func reloadChatroomsData(data: [Chatroom]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            self?.chatrooms = data
            self?.chatrooms.sort(by: {($0.lastConversation?.createdEpoch ?? 0) > ($1.lastConversation?.createdEpoch ?? 0)})
            self?.delegate?.updateHomeFeedChatroomsData()
        }
    }
    
    func updateChatroomsData(data: [Chatroom]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            for item in data {
                if let firstIndex = self?.chatrooms.firstIndex(where: {$0.id == item.id}) {
                    if item.followStatus == false {
                        self?.chatrooms.remove(at: firstIndex)
                        continue
                    }
                    self?.chatrooms[firstIndex] = item
                } else {
                    self?.chatrooms.append(item)
                }
            }
            self?.chatrooms.sort(by: {($0.lastConversation?.createdEpoch ?? 0) > ($1.lastConversation?.createdEpoch ?? 0)})
            self?.delegate?.updateHomeFeedChatroomsData()
        }
    }
    
    func chatroomContentView(chatroom: Chatroom?) -> LMChatHomeFeedChatroomView.ContentModel {
        let lastConversation = chatroom?.lastConversation
        let isLoggedInUser = lastConversation?.member?.sdkClientInfo?.uuid == UserPreferences.shared.getClientUUID()
        let creatorName = isLoggedInUser ? "You" : (lastConversation?.member?.name ?? "").components(separatedBy: " ").first ?? ""
        var lastMessage = chatroom?.lastConversation?.answer ?? ""
        lastMessage = GetAttributedTextWithRoutes.getAttributedText(from: lastMessage).string
        let fileType = lastConversation?.attachments?.first?.type
        
       return  LMChatHomeFeedChatroomView.ContentModel(userName: creatorName,
                                                                     lastMessage: lastMessage,
                                                                     chatroomName: chatroom?.header ?? "",
                                                                     chatroomImageUrl: chatroom?.chatroomImageUrl,
                                                                     isMuted: chatroom?.muteStatus ?? false,
                                                                     isSecret: chatroom?.isSecret ?? false,
                                                                     isAnnouncementRoom: chatroom?.type == ChatroomType.purpose.rawValue,
                                                                     unreadCount: chatroom?.unseenCount ?? 0,
                                                                     timestamp: timestampConverted(createdAtInEpoch: lastConversation?.createdEpoch ?? 0) ?? "",
                                                                     fileTypeWithCount: getAttachmentType(chatroom: chatroom),
                                                                     messageType: chatroom?.lastConversation?.state.rawValue ?? 0,
                                                                     isContainOgTags: lastConversation?.ogTags != nil)
    }
    
    func getAttachmentType(chatroom: Chatroom?) -> [(String, Int)] {
        guard let attachments = chatroom?.lastConversation?.attachments else { return [] }
        let attachmentTypes = attachments.compactMap({$0.type}).unique()
        let groupedBy = Dictionary(grouping: attachments, by: { $0.type })
        var typeArray: [(String, Int)] = []
        for atType in attachmentTypes {
            typeArray.append((atType, groupedBy[atType]?.count ?? 0))
        }
        typeArray = ((typeArray.count) > 0) ? typeArray : ((chatroom?.lastConversation?.ogTags != nil) ? [("link", 0)] : [] )
        return typeArray
    }
    
    func timestampConverted(createdAtInEpoch: Int) -> String? {
        guard createdAtInEpoch > .zero else { return nil }
        var epochTime = Double(createdAtInEpoch)
        
        if epochTime > Date().timeIntervalSince1970 {
            epochTime = epochTime / 1000
        }
        
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
            //            dateFormatter.dateFormat = "hh:mm a"
            //            dateFormatter.amSymbol = "AM"
            //            dateFormatter.pmSymbol = "PM"
            return dateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter.string(from: date)
        }
    }
}

extension LMChatHomeFeedViewModel: HomeFeedClientObserver {
    
    public func initial(_ chatrooms: [Chatroom]) {
        reloadChatroomsData(data: chatrooms)
    }
    
    public func onChange(removed: [Chatroom], inserted: [(Int, Chatroom)], updated: [(Int, Chatroom)]) {
        if !updated.isEmpty {
            updateChatroomsData(data: updated.compactMap({$0.1}))
        } else if !inserted.isEmpty {
            updateChatroomsData(data: inserted.compactMap({$0.1}))
        } else if !removed.isEmpty {
            reloadChatroomsData(data: removed)
        }
    }
}
