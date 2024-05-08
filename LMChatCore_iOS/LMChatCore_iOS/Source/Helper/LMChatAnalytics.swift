//
//  LMChatAnalytics.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 08/05/24.
//

import Foundation

// MARK: LMFeedAnalyticsProtocol
public protocol LMChatAnalyticsProtocol {
    func trackEvent(for eventName: LMChatAnalyticsEventName, eventProperties: [String: AnyHashable])
}

final class LMChatAnalyticsTracker: LMChatAnalyticsProtocol {
    public func trackEvent(for eventName: LMChatAnalyticsEventName, eventProperties: [String : AnyHashable]) {
        let track = """
            ========Event Tracker========
        Event Name: \(eventName)
        Event Properties: \(eventProperties)
            =============================
        """
        print(track)
    }
}

public enum LMChatAnalyticsEventName: String {
    // Chatroom Events
    case chatroomLinkClicked = "Chatroom link clicked"
    case userTagsSomeone = "User tags someone"
    case chatroomMuted = "Chatroom muted"
    case chatroomUnmuted = "Chatroom unmuted"
    case chatroomResponded = "Chatroom responded"
    case chatRoomDeleted = "Chatroom deleted"
    case chatRoomFollowed = "Chatroom followed"
    case chatRoomLeft = "Chatroom left"
    case chatRoomOpened = "Chatroom opened"
    case chatRoomShared = "Chatroom shared"
    case chatRoomUnfollowed = "Chatroom unfollowed"
    case chatroomAutoFollow = "Auto follow enabled"
    case setChatroomTopic = "Current topic updated"

    // Member Profile Events
    case memberProfileView = "Member profile view"
    case memberProfileReport = "Member profile report"
    case memberProfileReportConfirmed = "Member profile report confirmed"
    
    // Notification Events
    case notificationReceived = "Notification Received"
    case notificationClicked = "Notification Clicked"

    // Reaction Events
    case reactionsClicked = "Reactions Click"
    case reactionAdded = "Reaction Added"
    case reactionListOpened = "Reaction List Opened" // Done
    case reactionRemoved = "Reaction Removed" // Done

    // Search Events
    case searchIconClicked = "Clicked search icon" // Done
    case searchCrossIconClicked = "Clicked cross search icon" // Done
    case chatroomSearched = "Chatroom searched"
    case chatroomSearchClosed = "Chatroom search closed"
    case messageSearched = "Message searched"
    case messageSearchClosed = "Message search closed"

    // Voice Note Events
    case voiceNoteRecorded = "Voice message recorded" // Done
    case voiceNotePreviewed = "Voice message previewed" // Done
    case voiceNoteCanceled = "Voice message canceled" // Done
    case voiceNoteSent = "Voice message sent" // Done
    case voiceNotePlayed = "Voice message played" // Done

    // Onboarding Flow
    case communityTabClicked = "Community tab clicked"
    case communityFeedClicked = "Community feed clicked"

    // Attachment Events
    case imageViewed = "Image viewed" // Done
    case videoPlayed = "Video played" // Done
    case audioPlayed = "Audio played" // Done
    case chatLinkClicked = "Chat link clicked" // Done

    // Message Action Events
    case messageEdited = "Message Edited"
    case messageDeleted = "Message Deleted"
    case messageCopied = "Message Copied"
    case messageReply = "Message Reply"

    // Reporting Events
    case messageReported = "Message reported"

    // Sync Related Events
    case syncComplete = "Sync Complete"

    // Third Party Share Events
    case thirdPartySharing = "Third party sharing"
    case thirdPartyAbandoned = "Third party abandoned"

    // Home and UI Events
    case homeFeedPageOpened = "Home feed page opened"
    case emoticonTrayOpened = "Emoticon Tray Opened"
}


public enum LMChatAnalyticsKeys: String {
    case chatroomId = "chatroom_id"
    case chatroomName = "chatroom_name"
    case chatroomType = "chatroom_type"
    case communityName = "community_name"
    case messageId = "message_id"
    case communityId = "community_id"
    case uuid = "uuid"
    case source = "source"
}


public enum LMChatAnalyticsSource: String {
    case messageReactionsFromLongPress = "long press"
    case messageReactionsFromReactionButton = "reaction button"
    case communityTab = "community_tab"
    case communityFeed = "home_feed"
    case homeFeed = "explore_feed"
    case notification = "notification"
    case deepLink = "deep_link"
    case pollResult = "poll_result"
    case messageReactions = "message_reactions"
    case directMessagesScreen = "direct_messages_screen"
}
