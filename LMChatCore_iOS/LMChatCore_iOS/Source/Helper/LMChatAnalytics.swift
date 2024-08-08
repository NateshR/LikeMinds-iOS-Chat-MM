//
//  LMChatAnalytics.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 08/05/24.
//

import Foundation

// MARK: LMChatAnalyticsProtocol
public protocol LMChatAnalyticsProtocol {
    func trackEvent(for eventName: LMChatAnalyticsEventName, eventProperties: [String: AnyHashable])
}

final class LMChatAnalyticsTracker: LMChatAnalyticsProtocol {
    public func trackEvent(for eventName: LMChatAnalyticsEventName, eventProperties: [String : AnyHashable]) {
        let track = """
            ========Event Tracker========
        Event Name: \(eventName.rawValue)
        Event Properties: \(eventProperties)
            =============================
        """
        print(track)
    }
}

public enum LMChatAnalyticsEventName: String {
    // Chatroom Events
    case chatroomLinkClicked = "Chatroom link clicked"
    case userTagsSomeone = "User tags someone" // Done
    case chatroomMuted = "Chatroom muted" // Done
    case chatroomUnmuted = "Chatroom unmuted" // Done
    case chatroomResponded = "Chatroom responded"
    case chatRoomDeleted = "Chatroom deleted" 
    case chatRoomFollowed = "Chatroom followed" // Done
    case chatRoomLeft = "Chatroom left"
    case chatRoomOpened = "Chatroom opened" // Done
    case chatRoomShared = "Chatroom shared"
    case chatRoomUnfollowed = "Chatroom unfollowed" // Done
    case chatroomAutoFollow = "Auto follow enabled"
    case setChatroomTopic = "Current topic updated" // Done
    
    // DM Events
    case dmScreenOpened = "Direct messages screen opened" // Done
    case dmRequestSent = "DM request sent"
    case dmRequestResponded = "DM request responded"
    case dmSent = "DM sent"
    case dmBlock = "DM blocked"
    case dmUnblock = "DM unblocked"
    
    // Notification Events
    case notificationReceived = "Notification Received"
    case notificationClicked = "Notification Clicked"

    // Reaction Events
    case reactionsClicked = "Reactions Click"
    case reactionAdded = "Reaction Added" // Done
    case reactionListOpened = "Reaction List Opened" // Done
    case reactionRemoved = "Reaction Removed" // Done

    // Search Events
    case searchIconClicked = "Clicked search icon" // Done
    case searchCrossIconClicked = "Clicked cross search icon" // Done
    case chatroomSearched = "Chatroom searched" // Done
    case chatroomSearchClosed = "Chatroom search closed"
    case messageSearched = "Message searched" // Done
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
    case messageEdited = "Message Edited" // Done
    case messageDeleted = "Message Deleted" // Done
    case messageCopied = "Message Copied" // Done
    case messageReply = "Message Reply" // Done

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
    
    // Poll events
    case pollVoted = "Poll voted"
    case pollVotingSkiped = "Poll voting skipped"
    case pollVotingEdited = "Poll voting edited"
    case pollCreationCompleted = "Poll creation completed"
    case pollOptionCreated = "Poll option created"
    case pollAnswersViewed = "Poll answers viewed"
    case pollResultsToggled = "Poll results toggled"
    
}


public enum LMChatAnalyticsKeys: String {
    case chatroomId = "chatroom_id"
    case chatroomName = "chatroom_name"
    case chatroomTitle = "chatroom_title"
    case chatroomType = "chatroom_type"
    case communityName = "community_name"
    case conversationId = "conversation_id"
    case pollOptionId = "poll_option_id"
    case messageId = "message_id"
    case communityId = "community_id"
    case uuid = "uuid"
    case source = "source"
    case receiver
    case status
    case senderId = "sender_user_id"
    case reported
    case reportedReason = "reported reason"
    case blockedUser = "blocked user"
}


public enum LMChatAnalyticsSource: String {
    case messageReactionsFromLongPress = "long press"
    case messageReactionsFromReactionButton = "reaction button"
    case communityTab = "community_tab"
    case homeFeed = "home_feed"
    case exploreFeed = "explore_feed"
    case notification = "notification"
    case deepLink = "deep_link"
    case pollResult = "poll_result"
    case messageReactions = "message_reactions"
    case directMessagesScreen = "direct_messages_screen"
}
