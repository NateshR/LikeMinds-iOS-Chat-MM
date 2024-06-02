//
//  LMChatUploadConversationsAttachmentOperation.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 21/04/24.
//

import Foundation
import LikeMindsChat

class LMChatConversationAttachmentUpload {
    
    private let queue = OperationQueue()
    static let shared: LMChatConversationAttachmentUpload = .init()
    private init() {}
    
    func uploadConversationAttchment(withAttachments attachments: [LMChatAttachmentUploadRequest], conversationId: String, convTempId: String) {
        let uploadConversationsAttachmentOperation = LMChatUploadConversationsAttachmentOperation(attachmentRequests: attachments, conversationId: conversationId, convTempId: convTempId)
        queue.addOperation(uploadConversationsAttachmentOperation)
    }
    
    func cancelUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.cancelAllTaskFor(groupId: conversationId)
    }
    
    func resumeUploadingFor(conversationId: String) {
        LMChatAWSManager.shared.resumeAllTaskFor(groupId: conversationId)
    }
}

class LMChatUploadConversationsAttachmentOperation: Operation {
    
    private var attachmentRequests: [LMChatAttachmentUploadRequest]
    private var conversationId: String
    private var conversationTempId: String
    private var groupQueue: DispatchGroup = DispatchGroup()
    
    static let attachmentPostCompleted = Notification.Name("ConversationAttachmentUploaded")
    static let postedId = "conversation_id"
    
    init(attachmentRequests: [LMChatAttachmentUploadRequest], conversationId: String, convTempId: String) {
        self.attachmentRequests = attachmentRequests
        self.conversationId = conversationId
        self.conversationTempId = convTempId
    }
    
    func uploadConversationAttachments() {
        attachmentRequests.forEach { attachment in
            if let fileUrl = attachment.fileUrl {
                groupQueue.enter()
                let awsFolderPath = attachment.awsFolderPath
                LMChatAWSManager.shared.uploadfile(fileUrl: fileUrl,
                                               awsPath: awsFolderPath,
                                               fileName: attachment.name ?? "\(fileUrl.pathExtension)",
                                               contenType: attachment.fileType, withTaskGroupId: conversationTempId)
                { progress in
                    print("======> \(attachment.name ?? "") progress \(progress) <=======")
                } completion: {[weak self] awsFilePath, error in
                    guard let awsFilePath else {
                        print("AWS Upload Error: \(error)")
                        self?.groupQueue.leave()
                        return
                    }
                    if let thumbfileUrl = URL(string: attachment.thumbnailLocalFilePath ?? ""), let thumbnailAWSFolderPath = attachment.thumbnailAWSFolderPath {
                        LMChatAWSManager.shared.uploadfile(fileUrl: thumbfileUrl,
                                                       awsPath: thumbnailAWSFolderPath,
                                                       fileName: "\(thumbfileUrl.pathExtension)",
                                                       contenType: "image", withTaskGroupId: nil)
                        { progress in }
                        completion: { awsThumbnailFilePath, error in
                            guard let awsThumbnailFilePath else {
                                print("AWS thumbnail Upload Error: \(error)")
                                self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: nil)
                                return
                            }
                            self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: awsThumbnailFilePath)
                        }
                    } else {
                        self?.putConversationMultiMedia(attachment: attachment, awsFilePath: awsFilePath, awsThumbnailFilePath: nil)
                    }
                }
            }
        }
        groupQueue.notify(queue: .global(qos: .background)) { [weak self] in
            guard let self else { return }
            NotificationCenter.default.post(name: Self.attachmentPostCompleted, object: nil, userInfo: [Self.postedId: conversationId])
        }
        groupQueue.wait()
    }
    
    override func main() {
        uploadConversationAttachments()
    }
    
    func putConversationMultiMedia(attachment: LMChatAttachmentUploadRequest, awsFilePath: String, awsThumbnailFilePath: String?) {
        let request = PutMultimediaRequest.builder()
            .conversationId(conversationId)
            .filesCount(self.attachmentRequests.count)
            .height(attachment.height)
            .width(attachment.width)
            .index(attachment.index)
            .name(attachment.name ?? "unnamed")
            .url(awsFilePath)
            .thumbnailUrl(awsThumbnailFilePath)
            .type(attachment.fileType)
            .meta(.builder()
                .duration(attachment.meta?.duration)
                .size(attachment.meta?.size)
                .numberOfPage(attachment.meta?.numberOfPage)
                .build()
            )
            .build()
        do {
            if let localFilePath = attachment.fileUrl {
                try FileManager.default.removeItem(at: localFilePath)
            }
        } catch {
            print("Error deleting file: \(error)")
        }
        LMChatClient.shared.putMultimedia(request: request) {[weak self] resposne in
            self?.groupQueue.leave()
        }
    }
    
}
