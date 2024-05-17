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
    
    public var emojiCollectionCell: LMChatEmojiCollectionCell.Type = LMChatEmojiCollectionCell.self
    
    // Shimmer view
    
    public var shimmerView: LMChatShimmerView.Type = LMChatShimmerView.self
    
    // Chat message list
    public var messageContentView: LMChatMessageContentView.Type = LMChatMessageContentView.self
    public var messageBubbleView: LMChatMessageBubbleView.Type = LMChatMessageBubbleView.self
    public var chatroomHeaderMessageView: LMChatroomHeaderMessageView.Type = LMChatroomHeaderMessageView.self
    public var chatMessageCell: LMChatMessageCell.Type = LMChatMessageCell.self
    public var chatNotificationCell: LMChatNotificationCell.Type = LMChatNotificationCell.self
    public var chatroomHeaderMessageCell: LMChatroomHeaderMessageCell.Type = LMChatroomHeaderMessageCell.self
    public var chatMessageGalleryCell: LMChatGalleryViewCell.Type = LMChatGalleryViewCell.self
    public var chatMessageDocumentCell: LMChatDocumentViewCell.Type = LMChatDocumentViewCell.self
    public var chatMessageAudioCell: LMChatAudioViewCell.Type = LMChatAudioViewCell.self
    public var chatMessageLinkPreviewCell: LMChatLinkPreviewCell.Type = LMChatLinkPreviewCell.self
    public var messageLoadingCell: LMChatMessageLoading.Type = LMChatMessageLoading.self
    public var attachmentLoaderView: LMAttachmentLoaderView.Type = LMAttachmentLoaderView.self
    public var attachmentRetryView: LMChatAttachmentUploadRetryView.Type = LMChatAttachmentUploadRetryView.self
    public var messageReactionView: LMChatMessageReactionsView.Type = LMChatMessageReactionsView.self
    public var messageReplyView: LMChatMessageReplyPreview.Type = LMChatMessageReplyPreview.self
    public var senderProfileView: LMChatProfileView.Type = LMChatProfileView.self
    public var galleryContentView: LMChatGalleryContentView.Type = LMChatGalleryContentView.self
    public var galleryView: LMChatMessageGallaryView.Type = LMChatMessageGallaryView.self
    
    public var documentsContentView: LMChatDocumentContentView.Type = LMChatDocumentContentView.self
    public var documentView: LMChatMessageDocumentPreview.Type = LMChatMessageDocumentPreview.self
    
    public var audioContentView: LMChatAudioContentView.Type = LMChatAudioContentView.self
    public var audioView: LMChatAudioPreview.Type = LMChatAudioPreview.self
    public var voiceNoteView: LMChatVoiceNotePreview.Type = LMChatVoiceNotePreview.self
    public var linkContentView: LMChatLinkPreviewContentView.Type = LMChatLinkPreviewContentView.self
    public var linkView: LMChatMessageLinkPreview.Type = LMChatMessageLinkPreview.self
    
    
}
