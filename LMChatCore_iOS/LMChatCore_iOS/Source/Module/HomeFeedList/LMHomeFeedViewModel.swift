//
//  LMHomeFeedViewModel.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/02/24.
//

import Foundation
import LikeMindsChat

public protocol LMHomeFeedViewModelProtocol: AnyObject {
    func reloadData()
    func updateHomeFeedChatroomsData()
    func updateHomeFeedExploreCountData()
}

public class LMHomeFeedViewModel {
    
    weak var delegate: LMHomeFeedViewModelProtocol?
    var chatrooms: [Chatroom] = []
    var exploreTabCountData: GetExploreTabCountResponse?
    var memberProfile: User?
    
    init(_ viewController: LMHomeFeedViewModelProtocol) {
        self.delegate = viewController
    }
    
    public static func createModule() throws -> LMHomeFeedViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewController = LMCoreComponents.shared.homeFeedScreen.init()
        viewController.viewModel = LMHomeFeedViewModel(viewController)
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
                    self?.chatrooms[firstIndex] = item
                } else {
                    self?.chatrooms.append(item)
                }
            }
            self?.chatrooms.sort(by: {($0.lastConversation?.createdEpoch ?? 0) > ($1.lastConversation?.createdEpoch ?? 0)})
            self?.delegate?.updateHomeFeedChatroomsData()
        }
    }
}

extension LMHomeFeedViewModel: HomeFeedClientObserver {
    
    public func initial(_ chatrooms: [Chatroom]) {
        print("Chatrooms data Intial")
        reloadChatroomsData(data: chatrooms)
    }
    
    public func onChange(removed: [Int], inserted: [(Int, Chatroom)], updated: [(Int, Chatroom)]) {
        print("Chatrooms data changed inserted: \(inserted.count) updated: \(updated.count) deleted: \(removed.count)")
        removed.forEach { index in
            chatrooms.remove(at: index)
        }
        if updated.count > 0 {
            updateChatroomsData(data: updated.compactMap({$0.1}))
        }
        if inserted.count > 0 {
            updateChatroomsData(data: inserted.compactMap({$0.1}))
        }
    }
}
