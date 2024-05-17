//
//  LMChatAudioContentView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import LMChatUI_iOS

@IBDesignable
open class LMChatAudioContentView: LMChatMessageContentView {
    
    open private(set) lazy var audioPreviewContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 4
        return view
    }()
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        bubbleView.addArrangeSubview(audioPreviewContainerStackView, atIndex: 2)
        audioPreviewContainerStackView.addSubview(cancelRetryContainerStackView)
        audioPreviewContainerStackView.bringSubviewToFront(cancelRetryContainerStackView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        cancelRetryContainerStackView.centerXAnchor.constraint(equalTo: audioPreviewContainerStackView.centerXAnchor).isActive = true
        cancelRetryContainerStackView.centerYAnchor.constraint(equalTo: audioPreviewContainerStackView.centerYAnchor).isActive = true
    }
    
    open override func setDataView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol?, index: IndexPath) {
        super.setDataView(data, delegate: delegate, index: index)
        loaderView.isHidden = data.message?.attachmentUploaded ?? true
        if data.message?.isDeleted == true {
            audioPreviewContainerStackView.isHidden = true
        } else {
            attachmentView(data, delegate: delegate, index: index)
        }
        
    }
    
    func attachmentView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol?, index: IndexPath) {
        guard let attachments = data.message?.attachments,
              !attachments.isEmpty,
        let type = attachments.first?.fileType else {
            audioPreviewContainerStackView.isHidden = true
            return
        }
        switch type {
        case "audio":
            audioPreview(attachments, delegate: delegate, index: index)
        case "voice_note":
            voiceNotePreview(attachments, delegate: delegate, index: index)
        default:
            break
        }
    }
    
    func audioPreview(_ attachments: [LMChatMessageListView.ContentModel.Attachment], delegate: LMChatAudioProtocol?, index: IndexPath) {
        guard !attachments.isEmpty else {
            audioPreviewContainerStackView.isHidden = true
            return
        }
        
        attachments.forEach { attachment in
            let preview = LMUIComponents.shared.audioView.init()
            preview.translatesAutoresizingMaskIntoConstraints = false
            preview.configure(with: .init(fileName: attachment.fileName, url: attachment.fileUrl, duration: attachment.duration ?? 0, thumbnail: attachment.thumbnailUrl), delegate: delegate, index: index)
            preview.setHeightConstraint(with: 72)
            audioPreviewContainerStackView.addArrangedSubview(preview)
        }
        audioPreviewContainerStackView.isHidden = false
    }
    
    func voiceNotePreview(_ attachments: [LMChatMessageListView.ContentModel.Attachment], delegate: LMChatAudioProtocol?, index: IndexPath) {
        guard !attachments.isEmpty else {
            audioPreviewContainerStackView.isHidden = true
            return
        }
        attachments.forEach { attachment in
            audioPreviewContainerStackView.addArrangedSubview(createAudioPreview(with: .init(fileName: attachment.fileName, url: attachment.fileUrl, duration: attachment.duration ?? 0, thumbnail: attachment.thumbnailUrl), delegate: delegate, index: index))
        }
        
        audioPreviewContainerStackView.isHidden = false
    }
    
    func createAudioPreview(with data: LMChatAudioContentModel, delegate: LMChatAudioProtocol?, index: IndexPath) -> LMChatVoiceNotePreview {
        let preview =  LMUIComponents.shared.voiceNoteView.init().translatesAutoresizingMaskIntoConstraints()
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        preview.backgroundColor = .clear
        preview.cornerRadius(with: 12)
        preview.configure(with: data, delegate: delegate, index: index)
        return preview
    }
    
    override func prepareToResuse() {
        super.prepareToResuse()
        audioPreviewContainerStackView.removeAllArrangedSubviews()
    }
}

extension LMChatAudioContentView {
    
    public func resetAudio() {
        audioPreviewContainerStackView.subviews.forEach { sub in
            (sub as? LMChatVoiceNotePreview)?.resetView()
            (sub as? LMChatAudioPreview)?.resetView()
        }
    }
    
    public func seekSlider(to position: Float, url: String) {
        audioPreviewContainerStackView.subviews.forEach { sub in
            (sub as? LMChatVoiceNotePreview)?.updateSeekerValue(with: position, for: url)
            (sub as? LMChatAudioPreview)?.updateSeekerValue(with: position, for: url)
        }
    }
}
