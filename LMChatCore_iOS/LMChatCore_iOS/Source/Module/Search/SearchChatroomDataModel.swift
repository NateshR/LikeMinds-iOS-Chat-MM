//
//  SearchChatroomDataModel.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 02/05/24.
//

public struct SearchChatroomDataModel {
    let id: String
    let chatroomTitle: String
    let chatroomImage: String?
    let isFollowed: Bool
}


public struct SearchConversationDataModel {
    let id: String
    let chatroomDetails: SearchChatroomDataModel
    let message: String
    let createdAt: Double
}
