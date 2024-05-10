//
//  SearchListViewModel.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 16/04/24.
//

import LikeMindsChat
import Foundation

public protocol SearchListViewProtocol: AnyObject {
    func updateSearchList(with data: [SearchListViewController.ContentModel])
    func showHideFooterLoader(isShow: Bool)
}

final public class SearchListViewModel {
    public enum APIStatus {
        case headerChatroomFollowTrue
        case headerChatroomFollowFalse
        case titleChatroomFollowTrue
        case conversationFollowTrue
        case titleChatroomFollowFalse
        case conversationFollowFalse
        
        var followStatus: Bool {
            switch self {
            case .headerChatroomFollowTrue,
                    .titleChatroomFollowTrue,
                    .conversationFollowTrue:
                return true
            case .headerChatroomFollowFalse,
                    .titleChatroomFollowFalse,
                    .conversationFollowFalse:
                return false
            }
        }
        
        var searchType: String {
            switch self {
            case .headerChatroomFollowTrue,
                    .headerChatroomFollowFalse:
                return "header"
            case .titleChatroomFollowTrue,
                    .titleChatroomFollowFalse:
                return "title"
            case .conversationFollowTrue,
                    .conversationFollowFalse:
                return ""
            }
        }
    }
    
    public static func createModule() throws -> SearchListViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewcontroller = SearchListViewController()
        let viewmodel = SearchListViewModel(delegate: viewcontroller)
        viewcontroller.viewmodel = viewmodel
        
        return viewcontroller
    }
    
    var delegate: SearchListViewProtocol?
    
    var headerChatroomData: [SearchChatroomDataModel]
    var titleFollowedChatroomData: [SearchChatroomDataModel]
    var titleNotFollowedChatroomData: [SearchChatroomDataModel]
    var followedConversationData: [SearchConversationDataModel]
    var notFollowedConversationData: [SearchConversationDataModel]
    
    private var searchString: String
    private var currentAPIStatus: APIStatus
    private var currentPage: Int
    private let pageSize: Int
    private var isAPICallInProgress: Bool
    private var shouldAllowAPICall: Bool
    
    init(delegate: SearchListViewProtocol? = nil) {
        self.delegate = delegate
        
        headerChatroomData = []
        titleFollowedChatroomData = []
        titleNotFollowedChatroomData = []
        followedConversationData = []
        notFollowedConversationData = []
        
        searchString = ""
        currentAPIStatus = .headerChatroomFollowTrue
        currentPage = 1
        pageSize = 10
        
        isAPICallInProgress = false
        shouldAllowAPICall = true
    }
    
    func searchList(with searchString: String) {
        self.searchString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !self.searchString.isEmpty else {
            // Empty String, so showing emptying UI
            headerChatroomData.removeAll(keepingCapacity: true)
            titleFollowedChatroomData.removeAll(keepingCapacity: true)
            titleNotFollowedChatroomData.removeAll(keepingCapacity: true)
            followedConversationData.removeAll(keepingCapacity: true)
            notFollowedConversationData.removeAll(keepingCapacity: true)
            
            delegate?.showHideFooterLoader(isShow: false)
            
            return
        }
        
        shouldAllowAPICall = true
        isAPICallInProgress = false
        currentAPIStatus = .headerChatroomFollowTrue
        currentPage = 1
        fetchData(searchString: searchString)
    }
    
    func fetchMoreData() {
        fetchData(searchString: searchString)
    }
    
    private func setNewAPIStatus() {
        // This means we have fetched all available data, no need to progress further
        if currentAPIStatus == .conversationFollowFalse {
            shouldAllowAPICall = false
            convertToContentModel()
            return
        }
        
        currentPage = 1
        
        if currentAPIStatus == .headerChatroomFollowTrue {
            currentAPIStatus = .headerChatroomFollowFalse
        } else if currentAPIStatus == .headerChatroomFollowFalse {
            currentAPIStatus = .titleChatroomFollowTrue
        } else if currentAPIStatus == .titleChatroomFollowTrue {
            currentAPIStatus = .conversationFollowTrue
        } else if currentAPIStatus == .conversationFollowTrue {
            currentAPIStatus = .titleChatroomFollowFalse
        } else if currentAPIStatus == .titleChatroomFollowFalse {
            currentAPIStatus = .conversationFollowFalse
        }
        
        fetchMoreData()
    }
    
    private func fetchData(searchString: String) {
        guard !isAPICallInProgress,
              shouldAllowAPICall else {
            delegate?.showHideFooterLoader(isShow: false)
            return
    }
        
        isAPICallInProgress = true
        
        switch currentAPIStatus {
        case .headerChatroomFollowTrue,
                .headerChatroomFollowFalse,
                .titleChatroomFollowTrue,
                .titleChatroomFollowFalse:
            searchChatroomList(searchString: searchString, isFollowed: currentAPIStatus.followStatus, searchType: currentAPIStatus.searchType)
        case .conversationFollowTrue,
                .conversationFollowFalse:
            searchConversationList(searchString: searchString, followStatus: currentAPIStatus.followStatus)
        }
    }
    
    
    // MARK: API CALL
    private func searchChatroomList(searchString: String, isFollowed: Bool, searchType: String) {
        let request = SearchChatroomRequest.builder()
            .setFollowStatus(isFollowed)
            .setPage(currentPage)
            .setPageSize(pageSize)
            .setSearch(searchString)
            .setSearchType(searchType)
            .build()
        
        LMChatClient.shared.searchChatroom(request: request) { [weak self] response in
            self?.isAPICallInProgress = false
            self?.delegate?.showHideFooterLoader(isShow: false)
            
            guard let self,
                  let chatrooms = response.data?.conversations else {
                self?.convertToContentModel()
                return
            }
            
            currentPage += 1
            
            let chatroomData: [SearchChatroomDataModel] = chatrooms.compactMap { chatroom in
                self.convertToChatroomData(form: chatroom.chatroom)
            }
            
            switch currentAPIStatus {
            case .headerChatroomFollowTrue,
                    .headerChatroomFollowFalse:
                headerChatroomData.append(contentsOf: chatroomData)
            case .titleChatroomFollowTrue:
                titleFollowedChatroomData.append(contentsOf: chatroomData)
            case .titleChatroomFollowFalse:
                titleNotFollowedChatroomData.append(contentsOf: chatroomData)
            default:
                break
            }
            
            if chatrooms.isEmpty || chatrooms.count < pageSize {
                setNewAPIStatus()
            } else {
                convertToContentModel()
            }
        }
    }
    
    private func convertToChatroomData(form chatroom: _Chatroom_?) -> SearchChatroomDataModel? {
        guard let chatroom,
              let id = chatroom.id,
              let user = generateUserDetails(from: chatroom.member) else { return .none }
        
        return .init(
            id: id,
            chatroomTitle: chatroom.header ?? "",
            chatroomImage: chatroom.chatroomImageUrl,
            isFollowed: chatroom.followStatus ?? false, 
            title: chatroom.title, 
            createdAt: Double(chatroom.createdAt ?? "") ?? 0, 
            user: user
        )
    }
    
    private func searchConversationList(searchString: String, followStatus: Bool) {
        let request = SearchConversationRequest.builder()
            .search(searchString)
            .page(currentPage)
            .pageSize(pageSize)
            .followStatus(followStatus)
            .build()
        
        LMChatClient.shared.searchConversation(request: request) { [weak self] response in
            self?.isAPICallInProgress = false
            self?.delegate?.showHideFooterLoader(isShow: false)
            
            guard let self,
                  let conversations = response.data?.conversations else {
                self?.convertToContentModel()
                return
            }
            
            currentPage += 1
            
            let conversationData: [SearchConversationDataModel] = conversations.compactMap { conversation in
                guard let chatroomData = self.convertToChatroomData(form: conversation.chatroom) else { return .none }

                return .init(id: "\(conversation.id)", chatroomDetails: chatroomData, message: conversation.answer, createdAt: conversation.createdAt)
            }
                        
            switch currentAPIStatus {
            case .conversationFollowTrue:
                followedConversationData.append(contentsOf: conversationData)
            case .conversationFollowFalse:
                notFollowedConversationData.append(contentsOf: conversationData)
            default:
                break
            }
            
            if conversations.isEmpty || conversations.count < pageSize {
                setNewAPIStatus()
            } else {
                convertToContentModel()
            }
        }
    }
    
    private func generateUserDetails(from data: Member?) -> SearchListUserDataModel? {
        guard let data,
              let uuid = data.sdkClientInfo?.uuid else { return .none }
        
        return .init(uuid: uuid, username: data.name ?? "User", imageURL: data.imageUrl, isGuest: data.isGuest)
    }
}


// MARK: Convert To Content Model
extension SearchListViewModel {
    func convertToContentModel() {
        var dataModel: [SearchListViewController.ContentModel] = []
        
        if !headerChatroomData.isEmpty {
            let followedChatroomConverted = convertChatroomCell(from: headerChatroomData)
            dataModel.append(.init(title: nil, data: followedChatroomConverted))
        }
        
        if !titleFollowedChatroomData.isEmpty || !titleNotFollowedChatroomData.isEmpty || !followedConversationData.isEmpty || !notFollowedConversationData.isEmpty {
            
            let titleFollowedData = convertTitleMessageCell(from: titleFollowedChatroomData)
            let followedConversationData = convertMessageCell(from: followedConversationData)
            let titleNotFollowedData = convertTitleMessageCell(from: titleNotFollowedChatroomData)
            let notFollowedConversationData = convertMessageCell(from: notFollowedConversationData)
            
            var sectionData: [SearchCellProtocol] = []
            
            sectionData.append(contentsOf: titleFollowedData)
            sectionData.append(contentsOf: followedConversationData)
            sectionData.append(contentsOf: titleNotFollowedData)
            sectionData.append(contentsOf: notFollowedConversationData)
            
            dataModel.append(.init(title: "Messages", data: sectionData))
        }
        
        delegate?.updateSearchList(with: dataModel)
    }
    
    private func convertChatroomCell(from data: [SearchChatroomDataModel]) -> [SearchGroupCell.ContentModel] {
        data.map {
            .init(chatroomID: $0.id, image: $0.chatroomImage, chatroomName: $0.chatroomTitle)
        }
    }
    
    private func convertTitleMessageCell(from data: [SearchChatroomDataModel]) -> [SearchMessageCell.ContentModel] {
        data.map {
            .init(
                chatroomID: $0.id,
                messageID: nil,
                chatroomName: $0.chatroomTitle,
                message: $0.title ?? "",
                senderName: $0.user.firstName,
                date: Date(timeIntervalSince1970: $0.createdAt),
                isJoined: $0.isFollowed
            )
        }
    }
    
    private func convertMessageCell(from data: [SearchConversationDataModel]) -> [SearchMessageCell.ContentModel] {
        data.map {
            .init(
                chatroomID: $0.chatroomDetails.id,
                messageID: $0.id,
                chatroomName: $0.chatroomDetails.chatroomTitle,
                message: $0.message,
                senderName: $0.chatroomDetails.user.firstName,
                date: Date(timeIntervalSince1970: $0.createdAt),
                isJoined: $0.chatroomDetails.isFollowed
            )
        }
    }
}
