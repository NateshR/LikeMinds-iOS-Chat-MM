//
//  LMChatMessageContentView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 22/03/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat
import Kingfisher

@IBDesignable
open class LMChatMessageContentView: LMView {
    
//    public struct ContentModel {
//        public let message: Conversation?
//        public let isIncommingMessage: Bool
//        
//        init(message: Conversation?, isIncommingMessage: Bool) {
//            self.message = message
//            self.isIncommingMessage = isIncommingMessage
//        }
//    }
        
    open private(set) lazy var bubbleView: LMChatMessageBubbleView = {
        return LMCoreComponents.shared
            .messageBubbleView
            .init()
            .translatesAutoresizingMaskIntoConstraints()
    }()
    
    open private(set) lazy var chatProfileImageContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .bottom
        //        view.distribution = .fillProportionally
        view.spacing = 10
        view.addArrangedSubview(chatProfileImageView)
        return view
    }()
    
    open private(set) lazy var chatProfileImageView: LMChatProfileView = {
        let image = LMChatProfileView().translatesAutoresizingMaskIntoConstraints()
        return image
    }()
    
    open private(set) lazy var reactionsView: LMChatMessageReactionsView = {
        let view = LMChatMessageReactionsView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var reactionContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 0
        view.addArrangedSubview(reactionsView)
        return view
    }()
    
    open private(set) lazy var docPreviewContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 4
        return view
    }()
    
    open private(set) lazy var audioPreviewContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 2
        return view
    }()
    
    open private(set) lazy var galleryContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 2
        return view
    }()
    
    open private(set) lazy var replyMessageView: LMMessageReplyPreview = {
        let view = LMMessageReplyPreview().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var galleryView: LMChatMessageGallaryView = {
        let image = LMChatMessageGallaryView().translatesAutoresizingMaskIntoConstraints()
        image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        let aspectRatioConstraints = NSLayoutConstraint(item: image, attribute: .width, relatedBy: .lessThanOrEqual, toItem: image, attribute: .height, multiplier: 1.4, constant: 0)
        image.addConstraint(aspectRatioConstraints)
        image.heightAnchor.constraint(equalToConstant:  UIScreen.main.bounds.width * 0.6).isActive = true
        image.backgroundColor = .clear
        image.cornerRadius(with: 12)
        return image
    }()
    
    open private(set) lazy var linkPreview: LMChatMessageLinkPreview = {
        let preview = LMChatMessageLinkPreview().translatesAutoresizingMaskIntoConstraints()
        preview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        preview.backgroundColor = .clear
        preview.cornerRadius(with: 12)
        return preview
    }()
    
    var textLabel: LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
        label.isScrollEnabled = false
        label.font = Appearance.shared.fonts.textFont1
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.isEditable = false
        label.textContainerInset = UIEdgeInsets(top: 4, left: 5, bottom: 0, right: 0)
        label.text = ""
        return label
    }()
    
    open private(set) lazy var timestampLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 0
        label.font = Appearance.shared.fonts.normalFontSize11
        label.textColor = Appearance.shared.colors.textColor
        label.text = ""
        return label
    }()
    
    open private(set) lazy var usernameLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 1
        label.font = Appearance.shared.fonts.headingLabel
        label.textColor = Appearance.shared.colors.red
        label.paddingLeft = 2
        label.paddingTop = 2
        label.paddingBottom = 2
        label.text = ""
        return label
    }()
    
    var bubbleLeadingConstraint: NSLayoutConstraint?
    var bubbleTrailingConstraint: NSLayoutConstraint?
    var clickedOnReaction: ((String) -> Void)?
    var clickedOnAttachment: ((String) -> Void)?
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        let bubble = createBubbleView()
        bubbleView = bubble
        addSubview(bubble)
        addSubview(chatProfileImageContainerStackView)
        addSubview(reactionContainerStackView)
        bubble.addArrangeSubview(usernameLabel)
        bubble.addArrangeSubview(replyMessageView)
        bubble.addArrangeSubview(galleryView)
        bubble.addArrangeSubview(linkPreview)
        bubble.addArrangeSubview(audioPreviewContainerStackView)
        bubble.addArrangeSubview(docPreviewContainerStackView)
        bubble.addArrangeSubview(textLabel)
        bubble.addSubview(timestampLabel)
//        let interaction = UIContextMenuInteraction(delegate: self)
//        bubble.addInteraction(interaction)
        backgroundColor = .clear
        
        reactionsView.isHidden = true
        replyMessageView.isHidden = true
        linkPreview.isHidden = true
        galleryView.isHidden = true
        audioPreviewContainerStackView.removeAllArrangedSubviews()
        audioPreviewContainerStackView.isHidden = true
        docPreviewContainerStackView.removeAllArrangedSubviews()
        docPreviewContainerStackView.isHidden = true
        
        reactionsView.clickedOnReaction = {[weak self] reactionString in
            self?.clickedOnReaction?(reactionString)
        }
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            reactionContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            reactionContainerStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            reactionContainerStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            chatProfileImageContainerStackView.topAnchor.constraint(equalTo: topAnchor),
            chatProfileImageContainerStackView.bottomAnchor.constraint(equalTo: reactionContainerStackView.topAnchor, constant: 4),
            chatProfileImageContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleView.topAnchor.constraint(equalTo: topAnchor),
            bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            bubbleView.bottomAnchor.constraint(equalTo: chatProfileImageContainerStackView.bottomAnchor, constant: -4),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -6),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -18),
            timestampLabel.leadingAnchor.constraint(greaterThanOrEqualTo: bubbleView.leadingAnchor, constant: 10),
        ])
        
         bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: chatProfileImageContainerStackView.trailingAnchor, constant: 40)
         bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor)
        
    }
    
    open func createBubbleView() -> LMChatMessageBubbleView {
        let bubble = LMCoreComponents.shared
            .messageBubbleView
            .init()
            .translatesAutoresizingMaskIntoConstraints()
        bubble.backgroundColor = Appearance.shared.colors.clear
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        
//        bubble.addGestureRecognizer(panGesture)
        return bubble
    }
    
    func createDocPreview(_ data: LMChatMessageDocumentPreview.ContentModel) -> LMChatMessageDocumentPreview {
        let preview = LMChatMessageDocumentPreview().translatesAutoresizingMaskIntoConstraints()
//        preview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        preview.backgroundColor = .clear
        preview.setHeightConstraint(with: 80)
        preview.cornerRadius(with: 12)
        preview.setData(data)
        preview.onClickAttachment = {[weak self] url in
            self?.clickedOnAttachment?(url)
        }
        return preview
    }

    func createAudioPreview(with data: LMChatAudioContentModel, delegate: LMChatAudioProtocol, index: IndexPath) -> LMChatVoiceNotePreview {
        let preview = LMChatVoiceNotePreview().translatesAutoresizingMaskIntoConstraints()
        preview.translatesAutoresizingMaskIntoConstraints = false
        preview.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        preview.backgroundColor = .clear
        preview.cornerRadius(with: 12)
        preview.configure(with: data, delegate: delegate, index: index)
        return preview
    }
    
    open func setDataView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        self.textLabel.isUserInteractionEnabled = true
        self.textLabel.attributedText = GetAttributedTextWithRoutes.getAttributedText(from: (data.message?.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.Fonts.shared.textFont2, withTextColor: Appearance.Colors.shared.black)
        let edited = data.message?.isEdited == true ? "Edited \(Constants.shared.strings.dot) " : ""
        self.timestampLabel.text = edited + (data.message?.createdTime ?? "")
        let isIncoming = data.message?.isIncoming ?? true
        bubbleView.bubbleFor(isIncoming)
        if !isIncoming {
            chatProfileImageView.isHidden = true
            bubbleLeadingConstraint?.constant = 40
            bubbleTrailingConstraint?.constant = 0
            usernameLabel.isHidden = true
        } else {
            chatProfileImageView.imageView.kf.setImage(with: URL(string: data.message?.createdByImageUrl ?? ""))
            chatProfileImageView.isHidden = false
            bubbleLeadingConstraint?.constant = 00
            bubbleTrailingConstraint?.constant = -40
            messageByName(data)
            usernameLabel.isHidden = false
        }
        bubbleLeadingConstraint?.isActive = true
        bubbleTrailingConstraint?.isActive = true
        
        if data.message?.isDeleted == true {
            deletedConversationView(data)
        } else {
            replyView(data)
            linkPreview(data)
            attachmentView(data, delegate: delegate, index: index)
            reactionsView(data)
        }
    }
    
    func messageByName(_ data: LMChatMessageCell.ContentModel) {
        
        let myAttribute = [ NSAttributedString.Key.font: Appearance.shared.fonts.headingLabel, .foregroundColor: Appearance.shared.colors.red]
        let myString = NSMutableAttributedString(string: "\(data.message?.createdBy ?? "")", attributes: myAttribute )
        if let memberTitle = data.message?.memberTitle {
            let myAttribute2 = [ NSAttributedString.Key.font: Appearance.shared.fonts.buttonFont1, .foregroundColor: Appearance.shared.colors.textColor]
            myString.append(NSAttributedString(string: " \(Constants.shared.strings.dot) \(memberTitle)", attributes: myAttribute2))
        }
        usernameLabel.attributedText = myString
    }
    
    func deletedConversationView(_ data: LMChatMessageCell.ContentModel) {
        self.textLabel.font = UIFont.italicSystemFont(ofSize: 16)
        self.textLabel.textColor = Appearance.Colors.shared.textColor
        self.textLabel.text = "This message was deleted!"
        self.textLabel.isUserInteractionEnabled = false
    }
    
    func linkPreview(_ data: LMChatMessageCell.ContentModel) {
        guard let ogTags = data.message?.ogTags else {
            linkPreview.isHidden = true
            return
        }
        
        linkPreview.setData(.init(linkUrl: ogTags.link, thumbnailUrl: ogTags.thumbnailUrl, title: ogTags.title, subtitle: ogTags.subtitle))
        linkPreview.isHidden = false
    }
    
    func attachmentView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        guard let attachments = data.message?.attachments,
                !attachments.isEmpty,
              let type = attachments.first?.fileType else {
            galleryView.isHidden = true
            docPreviewContainerStackView.isHidden = true
            audioPreviewContainerStackView.isHidden = true
            return
        }
        switch type {
        case "image", "video", "gif":
            galleryPreview(attachments)
        case "pdf", "document", "doc":
            docPreview(attachments)
        case "audio":
            audioPreview(attachments, delegate: delegate, index: index)
        case "voice_note":
            voiceNotePreview(attachments, delegate: delegate, index: index)
        default:
            break
        }
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
    
    func docPreview(_ attachments: [LMMessageListView.ContentModel.Attachment]) {
        guard !attachments.isEmpty else {
            docPreviewContainerStackView.isHidden = true
            return
        }
        
        attachments.forEach { attachment in
            docPreviewContainerStackView.addArrangedSubview(createDocPreview(.init(fileUrl: attachment.fileUrl, thumbnailUrl: attachment.thumbnailUrl, fileSize: attachment.fileSize, numberOfPages: attachment.numberOfPages, fileType: attachment.fileType, fileName: attachment.fileName)))
        }
        docPreviewContainerStackView.isHidden = false
    }
    
    func voiceNotePreview(_ attachments: [LMMessageListView.ContentModel.Attachment], delegate: LMChatAudioProtocol, index: IndexPath) {
        guard !attachments.isEmpty else {
            audioPreviewContainerStackView.isHidden = true
            return
        }
        
        attachments.forEach { attachment in
            audioPreviewContainerStackView.addArrangedSubview(createAudioPreview(with: .init(fileName: attachment.fileName, url: attachment.fileUrl, duration: attachment.duration ?? 0, thumbnail: attachment.thumbnailUrl), delegate: delegate, index: index))
        }
        
        audioPreviewContainerStackView.isHidden = false
    }
    
    func audioPreview(_ attachments: [LMMessageListView.ContentModel.Attachment], delegate: LMChatAudioProtocol, index: IndexPath) {
        guard !attachments.isEmpty else {
            audioPreviewContainerStackView.isHidden = true
            return
        }
        
        attachments.forEach { attachment in
            let preview = LMChatAudioPreview()
            preview.translatesAutoresizingMaskIntoConstraints = false
            preview.configure(with: .init(fileName: attachment.fileName, url: attachment.fileUrl, duration: attachment.duration ?? 0, thumbnail: attachment.thumbnailUrl), delegate: delegate, index: index)
            preview.setHeightConstraint(with: 72)
            audioPreviewContainerStackView.addArrangedSubview(preview)
        }
        
        audioPreviewContainerStackView.isHidden = false
    }
    
    func replyView(_ data: LMChatMessageCell.ContentModel) {
        if let repliedMessage = data.message?.replied?.first {
            replyMessageView.isHidden = false
            replyMessageView.closeReplyButton.isHidden = true
            replyMessageView.setData(.init(username: repliedMessage.createdBy, replyMessage: repliedMessage.message, attachmentsUrls: repliedMessage.attachments?.compactMap({($0.thumbnailUrl, $0.fileUrl, $0.fileType)})))
        } else {
            replyMessageView.isHidden = true
        }
    }
    
    func reactionsView(_ data: LMChatMessageCell.ContentModel) {
        if let reactions = data.message?.reactions, reactions.count > 0 {
            reactionsView.isHidden = false
            reactionsView.setData(reactions)
        } else {
            reactionsView.isHidden = true
        }
    }
    
    func prepareToResuse() {
        reactionsView.isHidden = true
        replyMessageView.isHidden = true
        linkPreview.isHidden = true
        galleryView.isHidden = true
        galleryContainerStackView.removeAllArrangedSubviews()
        galleryContainerStackView.isHidden = true
        docPreviewContainerStackView.removeAllArrangedSubviews()
        docPreviewContainerStackView.isHidden = true
        audioPreviewContainerStackView.removeAllArrangedSubviews()
        audioPreviewContainerStackView.isHidden = true
    }
    
    var originalCenter = CGPoint()
    var replyActionHandler: (() -> Void)?
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            // Save original center position
            originalCenter = center
        case .changed:
            // Calculate translation
            let translation = gestureRecognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            print("x: \(translation.x)")
        case .ended:
            // Check if the swipe distance meets the threshold for reply
            if frame.origin.x > -frame.size.width / 3 {
                // Perform reply action when swipe distance exceeds threshold
                replyActionHandler?()
                print("perform reply action...")
                UIView.animate(withDuration: 0.2) {
                    self.center = self.originalCenter
                }
            } else {
                // Return the message view to its original position if swipe distance is not enough
                UIView.animate(withDuration: 0.2) {
                    self.center = self.originalCenter
                }
            }
        default:
            break
        }
    }
}

extension LMChatMessageContentView: UIContextMenuInteractionDelegate {
    
    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: { suggestedActions in
            let replyAction = UIAction(title: NSLocalizedString("Reply", comment: ""),
                                       image: UIImage(systemName: "arrow.down.square")) { action in
            }
            
            let editAction = UIAction(title: NSLocalizedString("Edit", comment: ""),
                                      image: UIImage(systemName: "pencil")) { action in
            }
            
            let copyAction = UIAction(title: NSLocalizedString("Copy", comment: ""),
                                      image: UIImage(systemName: "doc.on.doc")) { action in
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""),
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { action in
            }
            
            return UIMenu(title: "", children: [replyAction, editAction, copyAction, deleteAction])
        })
    }
    
    
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

