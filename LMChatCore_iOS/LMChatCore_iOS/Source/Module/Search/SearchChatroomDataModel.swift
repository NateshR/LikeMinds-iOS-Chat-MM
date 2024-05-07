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
    
    public init(id: String, chatroomTitle: String, chatroomImage: String?, isFollowed: Bool) {
        self.id = id
        self.chatroomTitle = chatroomTitle
        self.chatroomImage = chatroomImage
        self.isFollowed = isFollowed
    }
}


public struct SearchConversationDataModel {
    let id: String
    let chatroomDetails: SearchChatroomDataModel
    let userDetails: SearchConversationUserDataModel
    let message: String
    let createdAt: Double
    
    public init(id: String, chatroomDetails: SearchChatroomDataModel, userDetails: SearchConversationUserDataModel, message: String, createdAt: Double) {
        self.id = id
        self.chatroomDetails = chatroomDetails
        self.userDetails = userDetails
        self.message = message
        self.createdAt = createdAt
    }
}

public struct SearchConversationUserDataModel {
    let uuid: String
    let username: String
    let imageURL: String?
    let isGuest: Bool
    
    public init(uuid: String, username: String, imageURL: String?, isGuest: Bool) {
        self.uuid = uuid
        self.username = username
        self.imageURL = imageURL
        self.isGuest = isGuest
    }
}

