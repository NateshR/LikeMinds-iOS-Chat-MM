//
//  LMChatMediaPreviewViewModel.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 20/04/24.
//


public final class LMChatMediaPreviewViewModel {
    public struct DataModel {
        var type: MediaType
        var url: String
        
        public init(type: MediaType, url: String) {
            self.type = type
            self.url = url
        }
    }
    
    let data: [DataModel]
    let startIndex: Int
    
    init(data: [DataModel], startIndex: Int) {
        self.data = data
        self.startIndex = startIndex
    }
    
    public static func createModule(with data: [DataModel], startIndex: Int = 0) -> LMChatMediaPreviewScreen {
        let viewController = LMChatMediaPreviewScreen()
        let viewModel = Self.init(data: data, startIndex: startIndex)
        
        viewController.viewModel = viewModel
        return viewController
    }
}
