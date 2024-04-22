//
//  LMReactionViewModel.swift
//  SampleApp
//
//  Created by Devansh Mohata on 15/04/24.
//

import Foundation
import LikeMindsChat

protocol ReactionViewModelProtocol: AnyObject {
    func showData(with collection: [LMReactionTitleCell.ContentModel], cells: [LMReactionViewCell.ContentModel])
}

final public  class LMReactionViewModel {
    var delegate: ReactionViewModelProtocol?
    var reactionsData: [Reaction] = []
    var reactionsByGroup: [String: [Reaction]] = [:]
    
    var reactions: [LMReactionTitleCell.ContentModel] = []
    
    var reactionList: [LMReactionViewCell.ContentModel] = []
    
    init(delegate: ReactionViewModelProtocol?) {
        self.delegate = delegate
    }
    
    public static func createModule(reactions: [Reaction]) throws -> LMReactionViewController? {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        let vc = LMReactionViewController()
        let viewmodel = Self.init(delegate: vc)
        viewmodel.reactionsData = reactions
        vc.viewModel = viewmodel
        return vc
    }
    
    func getData() {
        fetchReactions()
    }
    
    func fetchReactions() {
        reactionsByGroup = Dictionary(grouping: reactionsData, by: ({$0.reaction}))
        reactions.append(.init(title: "All", count: reactionsData.count, isSelected: true))
        for react in reactionsByGroup.keys {
            reactions.append(.init(title: react, count: reactionsByGroup[react]?.count ?? 0, isSelected: false))
        }
        reactionList = reactionsData.map({.init(image: $0.member?.imageUrl, username: $0.member?.name ?? "", isSelfReaction: (($0.member?.uuid ?? "") == UserPreferences.shared.getLMUUID()), reaction: $0.reaction)})
        delegate?.showData(with: reactions, cells: reactionList)
    }
    
    func fetchReactionBy(reaction: String) {
        if reaction == "All" {
            reactionList = reactionsData.map({.init(image: $0.member?.imageUrl, username: $0.member?.name ?? "", isSelfReaction: (($0.member?.uuid ?? "") == UserPreferences.shared.getLMUUID()), reaction: $0.reaction)})
            delegate?.showData(with: reactions, cells: reactionList)
            return
        }
        reactionList = (reactionsByGroup[reaction] ?? []).compactMap({
            return LMReactionViewCell.ContentModel(image: $0.member?.imageUrl, username: $0.member?.name ?? "", isSelfReaction: (($0.member?.uuid ?? "") == UserPreferences.shared.getLMUUID()), reaction: $0.reaction)
        })
        guard let selectedReactionIndex = reactions.firstIndex(where: { $0.title == reaction }) else {
            return
        }
        var selectedReaction = reactions[selectedReactionIndex]
        selectedReaction.isSelected = true
        reactions[selectedReactionIndex] = selectedReaction
        delegate?.showData(with: reactions, cells: reactionList)
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
