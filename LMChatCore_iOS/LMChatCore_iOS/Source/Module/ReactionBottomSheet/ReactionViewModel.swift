//
//  ReactionViewModel.swift
//  SampleApp
//
//  Created by Devansh Mohata on 15/04/24.
//

import Foundation
import LikeMindsChat

protocol ReactionViewModelProtocol: AnyObject {
    func showData(with collection: [ReactionTitleCell.ContentModel], cells: [ReactionViewCell.ContentModel])
}

final public  class ReactionViewModel {
    var delegate: ReactionViewModelProtocol?
    
    var reactions: [ReactionTitleCell.ContentModel] = [ .init(title: "All", count: 5, isSelected: true),
                                                        .init(title: "👍", count: 3, isSelected: false),
                                                        .init(title: "😂", count: 2, isSelected: false)]
    
    var table: [ReactionViewCell.ContentModel] = [.init(image: nil, username: "Devansh", isSelfReaction: true, reaction: "👍"),
                                                  .init(image: nil, username: "Pushpendra", isSelfReaction: false, reaction: "👍"),
                                                  .init(image: nil, username: "Siddharth", isSelfReaction: false, reaction: "👍"),
                                                  .init(image: nil, username: "Anurag", isSelfReaction: false, reaction: "😂"),
                                                  .init(image: nil, username: "Anuj", isSelfReaction: false, reaction: "😂")]
    
    init(delegate: ReactionViewModelProtocol?) {
        self.delegate = delegate
    }
    
    public static func createModule() throws -> ReactionViewController? {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        let vc = ReactionViewController()
        let viewmodel = Self.init(delegate: vc)
        vc.viewModel = viewmodel
        return vc
    }
    
    func getData() {
        delegate?.showData(with: reactions, cells: table)
    }
    
    func deleteConversationReaction(conversationId: String) {
        let request = DeleteReactionRequest.builder()
            .conversationId(conversationId)
            .build()
        LMChatClient.shared.deleteReaction(request: request) { response in
            guard response.success else {
                print(response.errorMessage)
                return
            }
        }
    }
    
    func deleteChatroomReaction(chatroomId: String) {
        let request = DeleteReactionRequest.builder()
            .chatroomId(chatroomId)
            .build()
        LMChatClient.shared.deleteReaction(request: request) { response in
            guard response.success else {
                print(response.errorMessage)
                return
            }
        }
    }
}
