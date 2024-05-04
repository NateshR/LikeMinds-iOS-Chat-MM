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
    var followedChatroomData: [SearchChatroomDataModel]
    var notFollowedChatroomData: [SearchChatroomDataModel]
    var conversationData: [SearchConversationDataModel]
    
    private var searchString: String
    private var currentAPIStatus: APIStatus
    private var currentPage = 1
    private let pageSize = 10
    
    init(delegate: SearchListViewProtocol? = nil) {
        self.delegate = delegate
        
        followedChatroomData = []
        notFollowedChatroomData = []
        conversationData = []
        
        searchString = ""
        currentAPIStatus = .headerChatroomFollowTrue
    }
    
    func searchList(with searchString: String) {
        self.searchString = searchString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !self.searchString.isEmpty else {
            // Empty String, so showing emptying UI
            followedChatroomData.removeAll(keepingCapacity: true)
            notFollowedChatroomData.removeAll(keepingCapacity: true)
            conversationData.removeAll(keepingCapacity: true)
            
            return
        }
        
        currentAPIStatus = .headerChatroomFollowTrue
        currentPage = 1
    }
    
    func fetchMoreData() {
        fetchData(searchString: searchString)
    }
    
    private func setNewAPIStatus() {
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
    }
    
    private func fetchData(searchString: String) {
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
            guard let self else { return }
            
            
            
            let chatroomData: [SearchChatroomDataModel] = response.data?.conversations.compactMap { chatroom in
                self.convertToChatroomData(form: chatroom.chatroom)
            } ?? []
                        
//            if isFollowed {
//                self?.followedChatroomData.append(contentsOf: chatroomData)
//            } else {
//                self?.notFollowedChatroomData.append(contentsOf: chatroomData)
//            }
        }
    }
    
    private func convertToChatroomData(form chatroom: _Chatroom_?) -> SearchChatroomDataModel? {
        guard let chatroom,
              let id = chatroom.id else { return .none }
        
        return .init(
            id: id,
            chatroomTitle: chatroom.header ?? "",
            chatroomImage: chatroom.chatroomImageUrl,
            isFollowed: chatroom.followStatus ?? false
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
            let conversationData: [SearchConversationDataModel] = response.data?.conversations.compactMap { conversation in
                guard let chatroomData = self?.convertToChatroomData(form: conversation.chatroom) else { return .none }
                
                return .init(id: "\(conversation.id)", chatroomDetails: chatroomData, message: conversation.answer, createdAt: conversation.createdAt)
            } ?? []
            
            self?.conversationData.append(contentsOf: conversationData)
        }
    }
}


// MARK: Convert To Content Model
extension SearchListViewModel {
    func convertToContentModel() {
        var dataModel: [SearchListViewController.ContentModel] = []
        
        let followedChatroomConverted = convertChatroomCell(from: followedChatroomData)
        
        if !followedChatroomConverted.isEmpty {
            dataModel.append(.init(title: nil, data: followedChatroomConverted))
        }
        
        let notFollowedChatroomConverted = convertChatroomCell(from: notFollowedChatroomData)
        let conversationDataConverted = convertMessageCell(from: conversationData)
    
        var sectionData: [SearchCellProtocol] = []
        
        sectionData.append(contentsOf: conversationDataConverted)
        sectionData.append(contentsOf: notFollowedChatroomConverted)
        
        if !sectionData.isEmpty {
            dataModel.append(.init(title: conversationDataConverted.isEmpty ? nil : "Messages", data: sectionData))
        }
        
        if dataModel.isEmpty {
            // TODO: Show UI for no data
        } else {
            delegate?.updateSearchList(with: dataModel)
        }
    }
    
    private func convertChatroomCell(from data: [SearchChatroomDataModel]) -> [SearchGroupCell.ContentModel] {
        data.map {
            .init(chatroomID: $0.id, image: $0.chatroomImage, chatroomName: $0.chatroomTitle)
        }
    }
    
    private func convertMessageCell(from data: [SearchConversationDataModel]) -> [SearchMessageCell.ContentModel] {
        data.map {
            .init(chatroomID: $0.chatroomDetails.id, messageID: $0.id, chatroomName: $0.chatroomDetails.chatroomTitle, message: $0.message, date: Date(timeIntervalSince1970: $0.createdAt), isJoined: $0.chatroomDetails.isFollowed)
        }
    }
}
