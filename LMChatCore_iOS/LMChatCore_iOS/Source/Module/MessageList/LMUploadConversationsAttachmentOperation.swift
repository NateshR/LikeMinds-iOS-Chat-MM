//
//  LMUploadConversationsAttachmentOperation.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 21/04/24.
//

import Foundation
import LikeMindsChat

class LMConversationAttachmentUpload {
    
    private let queue = OperationQueue()
    static let shared: LMConversationAttachmentUpload = .init()
    private init() {}
    
    func uploadConversationAttchment(withAttachments attachments: [AttachmentUploadRequest], conversationId: String) {
        let uploadConversationsAttachmentOperation = LMUploadConversationsAttachmentOperation(attachmentRequests: attachments, conversationId: conversationId)
        queue.addOperation(uploadConversationsAttachmentOperation)
    }
}

class LMUploadConversationsAttachmentOperation: Operation {
    
    private var attachmentRequests: [AttachmentUploadRequest]
    private var conversationId: String
    private var groupQueue: DispatchGroup = DispatchGroup()
    
    static let attachmentPostCompleted = Notification.Name("ConversationAttachmentUploaded")
    static let postedId = "conversation_id"
    
    init(attachmentRequests: [AttachmentUploadRequest], conversationId: String) {
        self.attachmentRequests = attachmentRequests
        self.conversationId = conversationId
    }
    
    func uploadConversationAttachments() {
        attachmentRequests.forEach { attachment in
            if let fileUrl = attachment.fileUrl {
                groupQueue.enter()
                let awsFolderPath = attachment.awsFolderPath
                LMAWSManager.shared.uploadfile(fileUrl: fileUrl,
                                               awsPath: awsFolderPath,
                                               fileName: attachment.name ?? "\(fileUrl.pathExtension)",
                                               contenType: attachment.fileType)
                { progress in
                    print("======> \(attachment.name ?? "") progress \(progress) <=======")
                } completion: {[weak self] awsFilePath, error in
                    guard let awsFilePath else {
                        print("AWS Upload Error: \(error)")
                        self?.groupQueue.leave()
                        return
                    }
                    if let thumbfileUrl = URL(string: attachment.thumbnailLocalFilePath ?? ""), let thumbnailAWSFolderPath = attachment.thumbnailAWSFolderPath {
                        LMAWSManager.shared.uploadfile(fileUrl: thumbfileUrl,
                                                       awsPath: thumbnailAWSFolderPath,
                                                       fileName: "\(thumbfileUrl.pathExtension)",
                                                       contenType: "image")
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
    
    func putConversationMultiMedia(attachment: AttachmentUploadRequest, awsFilePath: String, awsThumbnailFilePath: String?) {
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
