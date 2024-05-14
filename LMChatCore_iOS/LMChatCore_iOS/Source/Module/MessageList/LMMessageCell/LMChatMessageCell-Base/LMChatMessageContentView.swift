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

    open private(set) lazy var replyMessageView: LMMessageReplyPreview = {
        let view = LMMessageReplyPreview().translatesAutoresizingMaskIntoConstraints()
        return view
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
    
    open private(set) lazy var loaderView: LMLoaderView = {
        let view = LMLoaderView().translatesAutoresizingMaskIntoConstraints()
        return view
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
        bubble.addArrangeSubview(textLabel)
        bubble.addSubview(timestampLabel)
        backgroundColor = .clear
        reactionsView.isHidden = true
        replyMessageView.isHidden = true
        reactionsView.clickedOnReaction = {[weak self] reactionString in
            self?.clickedOnReaction?(reactionString)
        }
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            reactionContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            reactionContainerStackView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            reactionContainerStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            chatProfileImageContainerStackView.topAnchor.constraint(equalTo: topAnchor),
            chatProfileImageContainerStackView.bottomAnchor.constraint(equalTo: reactionContainerStackView.topAnchor, constant: 2),
            chatProfileImageContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            bubbleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48),
            bubbleView.bottomAnchor.constraint(equalTo: chatProfileImageContainerStackView.bottomAnchor, constant: -2),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -6),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -18),
            timestampLabel.leadingAnchor.constraint(greaterThanOrEqualTo: bubbleView.leadingAnchor, constant: 10),
        ])
        
         bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: chatProfileImageContainerStackView.trailingAnchor, constant: 40)
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
    
    open func setDataView(_ data: LMChatMessageCell.ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        self.textLabel.isUserInteractionEnabled = true
        self.textLabel.attributedText = GetAttributedTextWithRoutes.getAttributedText(from: (data.message?.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.Fonts.shared.textFont2, withTextColor: Appearance.Colors.shared.black)
        let edited = data.message?.isEdited == true ? "Edited \(Constants.shared.strings.dot) " : ""
        self.timestampLabel.text = edited + (data.message?.createdTime ?? "")
        let isIncoming = data.message?.isIncoming ?? true
        bubbleView.bubbleFor(isIncoming)
        bubbleLeadingConstraint?.isActive = false
        bubbleTrailingConstraint?.isActive = false
        if !isIncoming {
            chatProfileImageView.isHidden = true
            bubbleLeadingConstraint?.constant = 40
            bubbleTrailingConstraint?.constant = 0
            usernameLabel.isHidden = true
        } else {
            chatProfileImageView.imageView.kf.setImage(with: URL(string: data.message?.createdByImageUrl ?? ""), placeholder: UIImage.generateLetterImage(name: data.message?.createdBy ?? ""))
            chatProfileImageView.isHidden = false
            bubbleLeadingConstraint?.constant = 0
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
            reactionsView(data)
        }
        bubbleView.layoutIfNeeded()
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

    func replyView(_ data: LMChatMessageCell.ContentModel) {
        if let repliedMessage = data.message?.replied?.first {
            replyMessageView.isHidden = false
            replyMessageView.closeReplyButton.isHidden = true
            let message = repliedMessage.isDeleted == true ? "This message was deleted!" : repliedMessage.message
            replyMessageView.setData(.init(username: repliedMessage.createdBy, replyMessage: message, attachmentsUrls: repliedMessage.attachments?.compactMap({($0.thumbnailUrl, $0.fileUrl, $0.fileType)})))
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
    }
    
    var originalCenter = CGPoint()
    var replyActionHandler: (() -> Void)?
}
