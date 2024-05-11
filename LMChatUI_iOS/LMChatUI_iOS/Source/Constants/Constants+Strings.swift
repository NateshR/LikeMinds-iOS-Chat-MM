//
//  Constants+Strings.swift
//  LMFramework
//
//  Created by Devansh Mohata on 07/12/23.
//

import Foundation

public extension Constants {
    struct Strings {
        private init() { }
        
        // Shared Instance
        public static var shared = Strings()
        
        public var like = "Like"
        public var likes = "Likes"
        public var reply = "Reply"
        public var replies = "Replies"
        public var comment = "Comment"
        public var comments = "Comments"
        public var allTopics = "All Topics"
        public var communityHood = "CommunityHood"
        public var dot = "•"
        public let restrictForAnnouncement = "Only community managers can respond here."
        public let restrictByManager = "Restricted to respond in this chatroom by community manager."
        public let warningMessageForDeletion = "Are you sure you want to delete this message? This action can not be reversed."
    }
}
