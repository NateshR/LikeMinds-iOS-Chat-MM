//
//  LMChatGalleryContentView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat
import Kingfisher

@IBDesignable
open class LMChatGalleryContentView: LMChatMessageContentView {

    open private(set) lazy var galleryView: LMChatMessageGallaryView = {
        let image = LMChatMessageGallaryView().translatesAutoresizingMaskIntoConstraints()
        //        image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        //        let aspectRatioConstraints = NSLayoutConstraint(item: image, attribute: .width, relatedBy: .lessThanOrEqual, toItem: image, attribute: .height, multiplier: 1.4, constant: 0)
        //        image.addConstraint(aspectRatioConstraints)
        //        image.heightAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width * 0.6).isActive = true
        image.backgroundColor = .clear
        image.cornerRadius(with: 12)
        return image
    }()
    
//    var clickedOnAttachment: ((String) -> Void)?
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        bubbleView.addArrangeSubview(galleryView, atIndex: 2)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: chatProfileImageContainerStackView.trailingAnchor, constant: 40)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor)
    }
    
    open override func setDataView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        super.setDataView(data, delegate: delegate, index: index)
        galleryView.loaderView.isHidden = data.message?.attachmentUploaded ?? true
        if data.message?.isDeleted == true {
            galleryView.isHidden = true
        } else {
            attachmentView(data, delegate: delegate, index: index)
        }
        
    }
    
    func attachmentView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        guard let attachments = data.message?.attachments,
              !attachments.isEmpty else {
            galleryView.isHidden = true
            return
        }
        galleryPreview(attachments)
    }
    
    func galleryPreview(_ attachments: [LMMessageListView.ContentModel.Attachment]) {
        guard !attachments.isEmpty else {
            galleryView.isHidden = true
            return
        }
        if attachments.count > 0 {
            galleryView.isHidden = false
            let data: [LMChatMessageGallaryView.ContentModel] = attachments.compactMap({ attachment in
                    .init(fileUrl: attachment.fileUrl, thumbnailUrl: attachment.thumbnailUrl, fileSize: attachment.fileSize, duration: attachment.duration, fileType: attachment.fileType, fileName: attachment.fileName)
            })
            galleryView.setData(data)
        } else {
            galleryView.isHidden = true
        }
    }
    
    override func prepareToResuse() {
        super.prepareToResuse()
    }
}
