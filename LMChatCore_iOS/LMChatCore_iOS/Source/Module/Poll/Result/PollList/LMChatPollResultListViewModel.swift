//
//  LMChatPollResultListViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 30/07/24.
//

import LikeMindsChat
import LikeMindsChatUI

public protocol LMChatPollResultListViewModelProtocol: LMBaseViewControllerProtocol {
    func reloadResults(with userList: [LMChatParticipantCell.ContentModel])
    func showLoader()
    func showHideTableFooter(isShow: Bool)
}

public final class LMChatPollResultListViewModel {
    let pollID: String
    let optionID: String
    var pageNo: Int
    let pageSize: Int
    var isFetching: Bool
    var shouldCallAPI: Bool
    var userList: [LMChatUserDataModel]
    weak var delegate: LMChatPollResultListViewModelProtocol?
    
    init(pollID: String, optionID: String, delegate: LMChatPollResultListViewModelProtocol?) {
        self.pollID = pollID
        self.optionID = optionID
        self.pageNo = 1
        self.pageSize = 10
        self.isFetching = false
        self.shouldCallAPI = true
        self.userList = []
        self.delegate = delegate
    }
    
    public static func createModule(for pollID: String, optionID: String) -> LMChatPollResultListScreen {
        let viewcontroller = LMCoreComponents.shared.pollResultList.init()
        
        let viewmodel = Self.init(pollID: pollID, optionID: optionID, delegate: viewcontroller)
        viewcontroller.viewmodel = viewmodel
        
        return viewcontroller
    }
    
    public func fetchUserList() {
        guard shouldCallAPI,
              !isFetching else { return }
   /*
        let request = GetPollVotesRequest
            .builder()
            .pollID(pollID)
            .options([optionID])
            .page(pageNo)
            .pageSize(pageSize)
            .build()
        
        LMChatClient.shared.getPollVotes(request) { [weak self] response in
            defer {
                self?.isFetching = false
                self?.reloadResults(with: self?.userList ?? [])
            }
            
            if let users = response.data?.users,
               let voterList = response.data?.votes?.first(where: { $0.id == self?.optionID })?.users {
                var transformedUsers: [LMChatUserDataModel] = []
                
                voterList.forEach { id in
                    if let user = users[id],
                       let uuid = user.sdkClientInfo?.uuid {
                        transformedUsers.append(.init(userName: user.name ?? "User", userUUID: uuid, userProfileImage: user.imageUrl, customTitle: user.customTitle))
                    }
                }
                
                self?.userList.append(contentsOf: transformedUsers)
                self?.shouldCallAPI = !transformedUsers.isEmpty
                self?.pageNo += 1
            } else {
                self?.shouldCallAPI = false
            }
        }
        */
    }
    
    func reloadResults(with transformedUsers: [LMChatUserDataModel]) {
        userList = transformedUsers
        
        let memberItems: [LMChatParticipantCell.ContentModel] = transformedUsers.map {
            return .init(id: $0.userUUID, name: $0.userName, designationDetail: nil, profileImageUrl: $0.userProfileImage , customTitle: $0.customTitle)
        }
        
        delegate?.reloadResults(with: memberItems)
    }
}
