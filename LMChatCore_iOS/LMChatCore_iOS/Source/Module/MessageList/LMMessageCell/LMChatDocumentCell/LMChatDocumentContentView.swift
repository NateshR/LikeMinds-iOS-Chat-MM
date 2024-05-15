//
//  LMChatDocumentContentView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat
import Kingfisher

@IBDesignable
open class LMChatDocumentContentView: LMChatMessageContentView {
    
    open private(set) lazy var docPreviewContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 4
        return view
    }()
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        bubbleView.addArrangeSubview(docPreviewContainerStackView, atIndex: 2)
        docPreviewContainerStackView.addSubview(cancelRetryContainerStackView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        cancelRetryContainerStackView.centerXAnchor.constraint(equalTo: docPreviewContainerStackView.centerXAnchor).isActive = true
        cancelRetryContainerStackView.centerYAnchor.constraint(equalTo: docPreviewContainerStackView.centerYAnchor).isActive = true
    }
    
    open override func setDataView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        super.setDataView(data, delegate: delegate, index: index)
        loaderView.isHidden = data.message?.attachmentUploaded ?? true
        if data.message?.isDeleted == true {
            docPreviewContainerStackView.isHidden = true
        } else {
            attachmentView(data, delegate: delegate, index: index)
        }
        
    }
    
    func attachmentView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        guard let attachments = data.message?.attachments,
              !attachments.isEmpty else {
            docPreviewContainerStackView.isHidden = true
            return
        }
        docPreview(attachments)
    }
    
    func docPreview(_ attachments: [LMMessageListView.ContentModel.Attachment]) {
        guard !attachments.isEmpty else {
            docPreviewContainerStackView.isHidden = true
            return
        }
        
        attachments.forEach { attachment in
            docPreviewContainerStackView.addArrangedSubview(createDocPreview(.init(fileUrl: attachment.fileUrl, thumbnailUrl: attachment.thumbnailUrl, fileSize: attachment.fileSize, numberOfPages: attachment.numberOfPages, fileType: attachment.fileType, fileName: attachment.fileName)))
        }
        docPreviewContainerStackView.isHidden = false
        docPreviewContainerStackView.bringSubviewToFront(cancelRetryContainerStackView)
    }
    
    func createDocPreview(_ data: LMChatMessageDocumentPreview.ContentModel) -> LMChatMessageDocumentPreview {
        let preview = LMChatMessageDocumentPreview().translatesAutoresizingMaskIntoConstraints()
        preview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        preview.backgroundColor = .clear
        preview.setHeightConstraint(with: 60)
        preview.cornerRadius(with: 12)
        preview.setData(data)
        preview.onClickAttachment = {[weak self] url in
            self?.clickedOnAttachment?(url)
        }
        return preview
    }
    
    override func prepareToResuse() {
        super.prepareToResuse()
        docPreviewContainerStackView.removeAllArrangedSubviews()
    }
}
