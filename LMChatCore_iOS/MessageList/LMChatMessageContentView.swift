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
    
    open private(set) lazy var replyMessageView: LMBottomMessageReplyPreview = {
        let view = LMBottomMessageReplyPreview().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var galleryView: LMChatMessageGallaryView = {
        let image = LMChatMessageGallaryView().translatesAutoresizingMaskIntoConstraints()
        image.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.7).isActive = true
        let aspectRatioConstraints = NSLayoutConstraint(item: image, attribute: .width, relatedBy: .lessThanOrEqual, toItem: image, attribute: .height, multiplier: 1.4, constant: 0)
        image.addConstraint(aspectRatioConstraints)
//        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.backgroundColor = .clear
        image.cornerRadius(with: 12)
        return image
    }()
    
    var textLabel: LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
//        label.numberOfLines = 0
        label.isScrollEnabled = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .left
        label.isEditable = false
        label.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        label.text = ""
        return label
    }()
    
    open private(set) lazy var timestampLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .black
        label.text = ""
        return label
    }()
    
    var bubbleLeadingConstraint: NSLayoutConstraint?
    var bubbleTrailingConstraint: NSLayoutConstraint?

    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        let bubble = createBubbleView()
        bubbleView = bubble
        addSubview(bubble)
        addSubview(chatProfileImageContainerStackView)
        addSubview(reactionContainerStackView)
        bubble.addArrangeSubview(replyMessageView)
        bubble.addArrangeSubview(galleryView)
        bubble.addArrangeSubview(textLabel)
        bubble.addSubview(timestampLabel)
//        let interaction = UIContextMenuInteraction(delegate: self)
//        bubble.addInteraction(interaction)
        backgroundColor = .clear
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            reactionContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2),
            reactionContainerStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            reactionContainerStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            chatProfileImageContainerStackView.topAnchor.constraint(equalTo: topAnchor),
            chatProfileImageContainerStackView.bottomAnchor.constraint(equalTo: reactionContainerStackView.topAnchor),
            chatProfileImageContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleView.topAnchor.constraint(equalTo: topAnchor),
            bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            bubbleView.bottomAnchor.constraint(equalTo: chatProfileImageContainerStackView.bottomAnchor, constant: -5),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -15),
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
        return bubble
    }
    
    open func setDataView(_ data: LMChatMessageCell.ContentModel) {
        self.textLabel.attributedText = GetAttributedTextWithRoutes.getAttributedText(from: (data.message?.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines))
        self.timestampLabel.text = data.message?.createdTime
        let isIncoming = data.message?.isIncoming ?? true
        bubbleView.bubbleFor(isIncoming)
        if !isIncoming {
            chatProfileImageView.isHidden = true
            bubbleLeadingConstraint?.constant = 40
            bubbleTrailingConstraint?.constant = 0
        } else {
            chatProfileImageView.imageView.kf.setImage(with: URL(string: data.message?.createdByImageUrl ?? ""))
            chatProfileImageView.isHidden = false
            bubbleLeadingConstraint?.constant = 00
            bubbleTrailingConstraint?.constant = -40
        }
        bubbleLeadingConstraint?.isActive = true
        bubbleTrailingConstraint?.isActive = true
        
        print("Image attachment: \(data.message?.attachments?.count ?? 0)")
        replyView(data)
        attachmentView(data)
        reactionsView(data)
    }
    
    
    func attachmentView(_ data: LMChatMessageCell.ContentModel) {
        if let attachments = data.message?.attachments, attachments.count > 0 {
            galleryView.isHidden = false
            galleryView.setData(attachments)
        } else {
            galleryView.isHidden = true
        }
    }
    
    func replyView(_ data: LMChatMessageCell.ContentModel) {
        if let repliedMessage = data.message?.replied?.first {
            replyMessageView.isHidden = false
            replyMessageView.setData(.init(username: repliedMessage.createdBy, replyMessage: repliedMessage.message, attachmentsUrls: repliedMessage.attachments))
        } else {
            replyMessageView.isHidden = true
        }
    }
    
    func reactionsView(_ data: LMChatMessageCell.ContentModel) {
        if let reactions = data.message?.reactions, reactions.count > 0 {
            reactionsView.isHidden = false
        } else {
            reactionsView.isHidden = true
        }
    }
    
    func prepareToResuse() {
        reactionsView.isHidden = true
        galleryView.isHidden = true
        replyMessageView.isHidden = true
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
}

