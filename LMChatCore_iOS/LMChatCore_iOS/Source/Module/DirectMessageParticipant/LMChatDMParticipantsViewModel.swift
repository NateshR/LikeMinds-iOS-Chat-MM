//
//  LMChatDMParticipantsViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 20/06/24.
//

import Foundation
import LikeMindsChatUI
import LikeMindsChat

public protocol LMChatDMParticipantsViewModelProtocol: AnyObject {
    func reloadData(with data: [LMChatParticipantCell.ContentModel])
}

public class LMChatDMParticipantsViewModel {
    weak var delegate: LMChatDMParticipantsViewModelProtocol?
    var participants: [Member] = []
    
    private var pageNo: Int
    private let pageSize: Int
    private var totalParticipantCount: Int
    private var isParticipantLoading: Bool
    private var isAllParticipantLoaded: Bool
    private var searchTime: Timer?

    var participantsContentModels: [LMChatParticipantCell.ContentModel] = []
    
    var searchedText: String?
    var chatroomActionData: GetChatroomActionsResponse?
    
    init(_ viewController: LMChatDMParticipantsViewModelProtocol) {
        self.delegate = viewController
        
        self.pageNo = 1
        self.pageSize = 20
        self.totalParticipantCount = .zero
        self.isParticipantLoading = false
        self.isAllParticipantLoaded = false
    }
    
    public static func createModule() throws -> LMChatDMParticipantsViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        let viewController = LMCoreComponents.shared.dmParticipantsScreen.init()
        viewController.viewModel = LMChatDMParticipantsViewModel(viewController)
        return viewController
    }
    
    func getParticipants() {
        guard !isParticipantLoading else { return }
        
        if let searchedText {
            searchMembers(searchedText)
            return
        }
        
//        guard let showList = dataProvider.dmShowList else { return }
//        if self.searchParticipantName.isEmpty {
//            interactor.fetchAllMembers(page: memberDirectoryPageIndex, memberState: showList == 2 ? 1 : nil, memberTypes: [.admin, .member])
//        } else {
//            fetchSearchedMembers(self.searchParticipantName, memberState: [1, 4])
//        }
        
        isParticipantLoading = true
        
        let request = GetAllMembersRequest.builder()
            .memberState(nil)
            .page(pageNo)
            .pageSize(pageSize)
            .filterMemberRoles([.admin, .member])
            .build()
        
        LMChatClient.shared.getAllMembers(request: request) {[weak self] response in
            guard let self,
                  let participantsData = response.data?.members,
                  !participantsData.isEmpty else {
                self?.isParticipantLoading = false
                return
            }
            
            totalParticipantCount = response.data?.totalMembers ?? 0
            pageNo += 1
            participants.append(contentsOf: participantsData)
            participantsContentModels.append(contentsOf: participantsData.compactMap({
                .init(name: $0.name ?? "", designationDetail: nil, profileImageUrl: $0.imageUrl, customTitle: $0.customTitle)
            }))
            delegate?.reloadData(with: participantsContentModels)
            isAllParticipantLoaded = (totalParticipantCount == participants.count)
            isParticipantLoading = false
        }
    }
    
    func fetchChatroomData() {
        let request = GetChatroomActionsRequest.builder()
            .build()
        LMChatClient.shared.getChatroomActions(request: request) { [weak self] response in
            guard let self,
                  let actionsData = response.data else { return }
            self.chatroomActionData = actionsData
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.delegate?.reloadData(with: self.participantsContentModels)
            }
        }
    }
    
    func searchParticipants(_ searchText: String?) {
        guard !isParticipantLoading, let searchText else { return }
        searchTime?.invalidate()
        searchTime = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] (timer) in
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let self else {return}
                isParticipantLoading = true
                searchedText = searchText
                pageNo = 1
                participants.removeAll(keepingCapacity: true)
                participantsContentModels.removeAll(keepingCapacity: true)
                searchMembers(searchText)
            }
        })
    }
    
    func searchMembers(_ searchText: String) {
        
        let request = SearchMembersRequest.builder()
            .searchType("name")
            .page(pageNo)
            .memberState([1, 4])
            .search(searchText)
            .pageSize(pageSize)
            .build()
        
        LMChatClient.shared.searchMembers(request: request) { [weak self] response in
            self?.isParticipantLoading = false
            
            guard let self else { return }
            
            let participantsData = response.data?.members ?? []
            
            totalParticipantCount = response.data?.totalMembers ?? 0
            pageNo += participantsData.isEmpty ? 0 : 1
            
            participants.append(contentsOf: participantsData)
            participantsContentModels.append(contentsOf: participantsData.compactMap({
                .init(name: $0.name ?? "", designationDetail: nil, profileImageUrl: $0.imageUrl, customTitle: $0.customTitle)
            }))
            
            delegate?.reloadData(with: participantsContentModels)
            
            isAllParticipantLoaded = (totalParticipantCount == participants.count)
            isParticipantLoading = false
        }
    }
}
