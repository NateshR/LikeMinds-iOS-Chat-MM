//
//  LMChatMediaPreviewViewModel.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 20/04/24.
//


public final class LMChatMediaPreviewViewModel {
    public struct DataModel {
        public enum MediaType {
            case image,
                 video
        }
        
        var type: MediaType
        var url: String
    }
    
    let data: [DataModel]
    
    init(data: [DataModel]) {
        self.data = data
    }
    
    public static func createModule(with data: [DataModel]) -> LMChatMediaPreviewScreen {
        let viewController = LMChatMediaPreviewScreen()
        let viewModel = Self.init(data: data)
        
        viewController.viewModel = viewModel
        return viewController
    }
}
