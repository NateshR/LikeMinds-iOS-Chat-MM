//
//  DataModelConverter.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/04/24.
//

import Foundation
import LikeMindsChat

class DataModelConverter {
    
    static let shared = DataModelConverter()
    
    func convertConversation(uuid: String, communityId: String, request: PostConversationRequest, fileUrls: [AttachmentMediaData]?) -> Conversation {
        let miliseconds = Int(Date().millisecondsSince1970)
        return Conversation.Builder()
            .id(request.temporaryId)
            .chatroomId(request.chatroomId)
            .communityId(communityId)
            .answer(request.text)
            .state(ConversationState.normal.rawValue)
            .createdEpoch(miliseconds)
            .memberId(uuid)
            .createdAt(TimeUtils.generateCreateAtDate(miliseconds: Double(miliseconds), format: "HH:mm"))
            .attachments(convertAttachments(fileUrls))
            .lastSeen(true)
            .ogTags(request.ogTags)
            .date(TimeUtils.generateCreateAtDate(miliseconds: Double(miliseconds)))
            .replyConversationId(request.repliedConversationId)
            .attachmentCount(request.attachmentCount)
            .localCreatedEpoch(miliseconds)
            .temporaryId(request.temporaryId)
            .isEdited(false)
            .replyChatroomId(request.repliedChatroomId)
            .attachmentUploaded(false)
            .build()
    }
    
    func convertAttachments(_ fileUrls: [AttachmentMediaData]?) -> [Attachment]? {
        var i = 0
        return fileUrls?.map({ media in
            i += 1
            return convertAttachment(mediaData: media, index: i)
        })
    }
    
    func convertAttachment(mediaData: AttachmentMediaData, index: Int) -> Attachment {
        
        return Attachment.builder()
            .name(mediaData.mediaName)
            .url(mediaData.url.absoluteString)
            .type(mediaData.fileType.rawValue)
            .index(index)
            .width(mediaData.width)
            .height(mediaData.height)
            .localFilePath(mediaData.url.absoluteString)
            .thumbnailUrl(mediaData.thumbnailurl?.absoluteString)
            .thumbnailLocalFilePath(mediaData.thumbnailurl?.absoluteString)
            .meta(
                AttachmentMeta.builder()
                    .numberOfPage(mediaData.pdfPageCount)
                    .duration(mediaData.duration)
                    .size(mediaData.size)
                    .build()
            )
            .build()
    }
    
}