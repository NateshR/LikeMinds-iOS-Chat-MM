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
        public static let shared = Strings()
        
        public let edit = "Edit"
        public let copy = "Copy"
        public let select = "Select"
        public let setTopic = "Set as current topic"
        public let reportMessage = "Report message"
        public let delete = "Delete"
        public let reply = "Reply"
        public let dot = "•"
        public let messageDeleteText = "This message was deleted!"
        public let restrictForAnnouncement = "Only community managers can respond here."
        public let restrictByManager = "Restricted to respond in this chatroom by community manager."
        public let warningMessageForDeletion = "Are you sure you want to delete this message? This action can not be reversed."
        public let followedMessage = "Added to your joined chatrooms"
        public let unfollowedMessage = "Removed from your joined chatrooms"
        public let secretChatroomRestrictionMessage = "Join this chatroom to participate in this chatroom."
        public let muteUnmuteMessage = "Notification %@ for this chatroom!"
        public let voiceRecordMessage = "Tap and hold to record a voice message!"
        public let sendDMToTitle = "Send DM to"
        public let memberAndCommunityManagerMessage = "Direct message is a feature to connect with your community members and community managers."
        public let memberMessage = "Direct message is a feature to connect with your community managers directly to give feedbacks, provide solution to queries and personal consultations."
        public let managerMessage = "Direct message is a feature to connect with your community members directly to give feedbacks, provide solution to queries and personal consultations."
        public let bottomMessage = "Send a DM request to %@ by sending your 1st message."
        public let pendingChatRequest = "DM Request pending. Messaging would be enabled once your request is approved."
        public let approveChatRequest = "DM Request pending. Messaging would be enabled once you approve the request."
        public let rejectedChatRequest = "You can not send message to rejected connection. Approve to send a message."
        public let m2mDirectMessageDisable = "Direct messaging among members has been disabled by the community manager."
        public let approveRejectViewTitle = "The sender has sent you a direct messaging request. Approve or respond with a message to get connected. Rejecting this request will not notify the sender."
    }
}
