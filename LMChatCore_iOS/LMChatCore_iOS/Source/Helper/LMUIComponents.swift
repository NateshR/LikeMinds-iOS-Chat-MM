//
//  LMUIComponents.swift
//  LMFramework
//
//  Created by Devansh Mohata on 28/11/23.
//

import UIKit
import LMChatUI_iOS

public struct LMUIComponents {
    public static var shared = Self()
    
    private init() { }
 /*
    // MARK: Common Components
    public var documentPreview: LMFeedDocumentPreview.Type = LMFeedDocumentPreview.self
    public var imagePreviewCell: LMFeedImageCollectionCell.Type = LMFeedImageCollectionCell.self
    public var linkPreview: LMFeedLinkPreview.Type = LMFeedLinkPreview.self
    public var videoPreviewCell: LMFeedVideoCollectionCell.Type = LMFeedVideoCollectionCell.self
    
    // MARK: Universal Feed Components
    public var documentCell: LMFeedPostDocumentCell.Type = LMFeedPostDocumentCell.self
    public var footerCell: LMFeedPostFooterView.Type = LMFeedPostFooterView.self
    public var headerCell: LMFeedPostHeaderView.Type = LMFeedPostHeaderView.self
    public var linkCell: LMFeedPostLinkCell.Type = LMFeedPostLinkCell.self
    public var postCell: LMFeedPostMediaCell.Type = LMFeedPostMediaCell.self
    
    // MARK: Post Detail Components
    public var commentCell: LMFeedPostDetailCommentCell.Type = LMFeedPostDetailCommentCell.self
    public var commentHeaderView: LMFeedPostDetailCommentHeaderView.Type = LMFeedPostDetailCommentHeaderView.self
    public var loadMoreReplies: LMFeedPostMoreRepliesCell.Type = LMFeedPostMoreRepliesCell.self
    public var totalCommentCell: LMFeedPostDetailTotalCommentCell.Type = LMFeedPostDetailTotalCommentCell.self
    
    // MARK: Topic Feed Components
    public var topicFeed: LMFeedTopicView.Type = LMFeedTopicView.self
    public var topicFeedCollectionCell: LMFeedTopicViewCell.Type = LMFeedTopicViewCell.self
    public var topicFeedEditCollectionCell: LMFeedTopicEditViewCell.Type = LMFeedTopicEditViewCell.self
    public var topicFeedEditIconCollectionCell: LMFeedTopicEditIconViewCell.Type = LMFeedTopicEditIconViewCell.self
    
    // MARK: Create Post Components
    public var createPostAddMediaView: LMFeedCreatePostAddMediaView.Type = LMFeedCreatePostAddMediaView.self
    public var createPostHeaderView: LMFeedCreatePostHeaderView.Type = LMFeedCreatePostHeaderView.self
    
    // MARK: Like Count Screen Components
    public var likedUserTableCell: LMFeedLikeUserTableCell.Type = LMFeedLikeUserTableCell.self
    
    // MARK: Notification Screen Components
    public var notificationTableCell: LMFeedNotificationView.Type = LMFeedNotificationView.self
*/
    
    // MARK: Tagging View
    public var taggingTableViewCell: LMChatTaggingUserTableCell.Type = LMChatTaggingUserTableCell.self
    
    //MARK: LMHomeFeed
    public var homeFeedChatroomCell: LMHomeFeedChatroomCell.Type = LMHomeFeedChatroomCell.self
    public var homeFeedExploreTabCell: LMHomeFeedExploreTabCell.Type = LMHomeFeedExploreTabCell.self
    public var homeFeedShimmerCell: LMHomeFeedLoading.Type = LMHomeFeedLoading.self
    
    public var exploreChatroomCell: LMExploreChatroomCell.Type = LMExploreChatroomCell.self 
    
    // MARK: Participant List View
    public var participantListCell: LMParticipantCell.Type = LMParticipantCell.self
    
    // MARK: Report Screen Components
    public var reportCollectionCell: LMChatReportViewCell.Type = LMChatReportViewCell.self
    
    public var chatMessageCell: LMChatMessageCell.Type = LMChatMessageCell.self
    public var chatNotificationCell: LMChatNotificationCell.Type = LMChatNotificationCell.self
    public var chatroomHeaderMessageCell: LMChatroomHeaderMessageCell.Type = LMChatroomHeaderMessageCell.self
    public var messageLoadingCell: LMMessageLoading.Type = LMMessageLoading.self
}
