//
//  LMChatPollDataModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 24/07/24.
//

import Foundation
import LikeMindsChat

public struct LMChatPollDataModel {
    public struct Option {
        public let id: String
        public let option: String
        public var isSelected: Bool
        public let voteCount: Int
        public let percentage: Double
        public let addedBy: LMChatUserDataModel
        
        public init(id: String, option: String, isSelected: Bool, voteCount: Int, percentage: Double, addedBy: LMChatUserDataModel) {
            self.id = id
            self.option = option
            self.isSelected = isSelected
            self.voteCount = voteCount
            self.percentage = percentage
            self.addedBy = addedBy
        }
    }
    
    public let id: String
    public let postID: String
    public let question: String
    public var options: [Option]
    public let pollDisplayText: String
    public let pollSelectType: LMChatPollSelectState
    public let pollSelectCount: Int
    public let expiryTime: Int
    public let isAnonymous: Bool
    public let allowAddOptions: Bool
    public let showResults: Bool
    public let isInstantPoll: Bool
    public let voteCount: Int
    public var userSelectedOptions: [String]
    
    public init(
        id: String,
        postID: String,
        question: String,
        options: [Option],
        pollDisplayText: String,
        pollSelectType: LMChatPollSelectState,
        pollSelectCount: Int,
        expiryTime: Int,
        isAnonymous: Bool,
        allowAddOptions: Bool,
        showResults: Bool,
        isInstantPoll: Bool,
        voteCount: Int
    ) {
        self.id = id
        self.postID = postID
        self.question = question
        self.options = options
        self.pollDisplayText = pollDisplayText
        self.pollSelectType = pollSelectType
        self.pollSelectCount = pollSelectCount
        self.expiryTime = expiryTime
        self.isAnonymous = isAnonymous
        self.allowAddOptions = allowAddOptions
        self.showResults = showResults
        self.isInstantPoll = isInstantPoll
        self.voteCount = voteCount
        self.userSelectedOptions = []
    }
}

public extension LMChatPollDataModel.Option {
    init?(users: [String: User], option: PollOption) {
        guard let uuid = option.uuid,
              let user = users[uuid],
              let id = option.id,
              let text = option.text else { return nil }
        
        self.id = id
        self.option = text
        self.isSelected = option.isSelected
        self.voteCount = option.voteCount
        self.percentage = option.percentage
        self.addedBy = .init(
            userName: user.name ?? "User",
            userUUID: uuid,
            userProfileImage: user.imageUrl,
            customTitle: user.customTitle
        )
    }
}

public struct LMChatUserDataModel {
    public let userName: String
    public let userUUID: String
    public let userProfileImage: String?
    public let customTitle: String?
    
    public init(userName: String, userUUID: String, userProfileImage: String? = nil, customTitle: String? = nil) {
        self.userName = userName
        self.userUUID = userUUID
        self.userProfileImage = userProfileImage
        self.customTitle = customTitle
    }
}
