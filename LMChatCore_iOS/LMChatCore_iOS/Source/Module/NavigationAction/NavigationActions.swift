//
//  NavigationActions.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 17/04/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat

enum NavigationActions {
    case homeFeed
    case chatroom(chatroomId: String)
    case messageAttachment(delegat: LMChatAttachmentViewDelegate?)
    case participants(chatroomId: String)
    case report(chatroomId: String?, conversationId: String?, memberId: String?)
    case reactionSheet(reactions: [Reaction])
    case exploreFeed
    
}

protocol NavigationScreenProtocol: AnyObject {
    func perform(_ action: NavigationActions, from source: LMViewController, params: Any?)
}


class NavigationScreen: NavigationScreenProtocol {
    static let shared = NavigationScreen()
    
    private init() {}
    
    func perform(_ action: NavigationActions, from source: LMViewController, params: Any?) {
        switch action {
        case .homeFeed:
            guard let homefeedvc = try? LMHomeFeedViewModel.createModule() else { return }
            source.navigationController?.pushViewController(homefeedvc, animated: true)
        case .chatroom(let chatroomId):
            guard let chatroom = try? LMMessageListViewModel.createModule(withChatroomId: chatroomId) else { return }
            source.navigationController?.pushViewController(chatroom, animated: true)
        case .messageAttachment(let delegate):
            guard let attachment = try? LMChatAttachmentViewModel.createModule(delegate: delegate) else { return }
            source.navigationController?.pushViewController(attachment, animated: true)
        case .participants(let chatroomId):
            guard let participants = try? LMParticipantListViewModel.createModule(withChatroomId: chatroomId) else { return }
            source.navigationController?.pushViewController(participants, animated: true)
        case .report(let chatroomId, let conversationId, let memberId):
            guard let report = try? LMChatReportViewModel.createModule(reportContentId: (chatroomId, conversationId, memberId)) else { return }
            source.navigationController?.pushViewController(report, animated: true)
        case .reactionSheet(let reactions):
            guard let reactions = try? LMReactionViewModel.createModule(reactions: reactions) else { return }
            source.present(reactions, animated: true)
        case .exploreFeed:
            guard let exploreFeed = try? LMExploreChatroomViewModel.createModule() else { return }
            source.navigationController?.pushViewController(exploreFeed, animated: true)
        }
    }
}

