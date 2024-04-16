//
//  SearchListViewModel.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 16/04/24.
//

import LikeMindsChat
import Foundation

protocol SearchListViewProtocol: AnyObject {
    
}

final public class SearchListViewModel {
    public static func createModule() throws -> SearchListViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewcontroller = SearchListViewController()
        let viewmodel = SearchListViewModel(delegate: viewcontroller)
        viewcontroller.viewmodel = viewmodel
        
        return viewcontroller
    }
    
    var delegate: SearchListViewProtocol?
    var dataa: [SearchCellProtocol] = []
    
    init(delegate: SearchListViewProtocol? = nil) {
        self.delegate = delegate
    }
    
    func searchList() {
        let request = SearchChatroomRequest.builder()
            .setFollowStatus(false)
            .setPage(1)
            .setPageSize(100)
            .setSearch("hi")
            .setSearchType("title")
            .build()
        
        LMChatClient.shared.searchChatroom(request: request) { response in
            dump(response)
        }
    }
}
