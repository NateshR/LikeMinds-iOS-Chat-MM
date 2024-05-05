//
//  LMBottomMessageReplyPreview.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 31/01/24.
//

import Foundation
import LMChatUI_iOS

public protocol LMBottomMessageReplyPreviewDelegate: AnyObject {
    func clearReplyPreview()
}

@IBDesignable
open class LMMessageReplyPreview: LMView {
    
    public struct ContentModel {
        public let username: String?
        public let replyMessage: String?
        public let attachmentsUrls: [(thumbnailUrl: String?, fileUrl: String?, fileType: String?)]?
        
        public init(username: String?, replyMessage: String?, attachmentsUrls: [(thumbnailUrl: String?, fileUrl: String?, fileType: String?)]?) {
            self.username = username
            self.replyMessage = replyMessage
            self.attachmentsUrls = attachmentsUrls
        }
    }
    
    public weak var delegate: LMBottomMessageReplyPreviewDelegate?
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.previewBackgroundColor
        view.cornerRadius(with: 8)
        return view
    }()
    
    open private(set) lazy var subviewContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 8)
        view.backgroundColor = Appearance.shared.colors.previewBackgroundColor
        return view
    }()
    
    open private(set) lazy var sidePannelColorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.red
        return view
    }()
    
    open private(set) lazy var userNameLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Username"
        label.font = Appearance.shared.fonts.headingFont3
        label.textColor = Appearance.shared.colors.red
        label.numberOfLines = 1
        label.paddingTop = 2
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    
    open private(set) lazy var messageLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Message Message "
        label.font = Appearance.shared.fonts.subHeadingFont1
        label.numberOfLines = 2
        label.textColor = Appearance.shared.colors.textColor
        return label
    }()
    
    open private(set) lazy var messageAttachmentImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.backgroundColor = .clear
//        image.cornerRadius(with: 8)
        return image
    }()
    
    open private(set) lazy var closeReplyButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.xmarkIcon, for: .normal)
        button.addTarget(self, action: #selector(cancelReply), for: .touchUpInside)
        button.setWidthConstraint(with: 40)
        return button
    }()
    
    open private(set) lazy var horizontalReplyStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 8
        return view
    }()
    
    open private(set) lazy var verticleUsernameAndMessageContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .top
        view.spacing = 0
        view.directionalLayoutMargins = .init(top: 6, leading: 0, bottom: 6, trailing:10)
        return view
    }()
    
    var viewData: ContentModel?
    var onClickReplyPreview: (() -> Void)?
    
    var onClickCancelReplyPreview: (() -> Void)?
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(sidePannelColorView)
        containerView.addSubview(horizontalReplyStackView)
        horizontalReplyStackView.addArrangedSubview(verticleUsernameAndMessageContainerStackView)
        horizontalReplyStackView.addArrangedSubview(messageAttachmentImageView)
        horizontalReplyStackView.addArrangedSubview(closeReplyButton)
        verticleUsernameAndMessageContainerStackView.addArrangedSubview(userNameLabel)
        verticleUsernameAndMessageContainerStackView.addArrangedSubview(messageLabel)
        isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onReplyPreviewClicked))
        tapGuesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGuesture)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            sidePannelColorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sidePannelColorView.topAnchor.constraint(equalTo: containerView.topAnchor),
            sidePannelColorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sidePannelColorView.widthAnchor.constraint(equalToConstant: 4),
            
            horizontalReplyStackView.leadingAnchor.constraint(equalTo: sidePannelColorView.leadingAnchor, constant: 10),
            horizontalReplyStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            horizontalReplyStackView.topAnchor.constraint(equalTo: sidePannelColorView.topAnchor),
            horizontalReplyStackView.bottomAnchor.constraint(equalTo: sidePannelColorView.bottomAnchor),
            
            messageAttachmentImageView.widthAnchor.constraint(equalToConstant: 50),
            messageAttachmentImageView.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    
    public func setData(_ data: ContentModel) {
        viewData = data
        self.userNameLabel.text = data.username
        let attributedText = GetAttributedTextWithRoutes.getAttributedText(from: data.replyMessage ?? "")
        self.messageLabel.attributedText = createAttributedString(for: data.attachmentsUrls?.first?.fileType, with: attributedText.string)
        if let attachmentsUrls = data.attachmentsUrls,
           let firstUrl = (attachmentsUrls.first?.thumbnailUrl ?? attachmentsUrls.first?.fileUrl),
           let url = URL(string: firstUrl) {
           messageAttachmentImageView.kf.setImage(with: url)
            messageAttachmentImageView.isHidden = false
        } else {
            messageAttachmentImageView.isHidden = true
        }
    }
    
    func createAttributedString(for fileType: String?, with message: String?) -> NSAttributedString {
        guard let fileType else {
            return NSAttributedString(string: message ?? "")
        }
        var image: UIImage = UIImage()
        var initalType = ""
        switch fileType.lowercased() {
        case "image":
            image = Constants.shared.images.galleryIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Photo"
        case "video":
            image = Constants.shared.images.videoSystemIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Video"
        case "audio":
            image = Constants.shared.images.audioIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Audio"
        case "voice_note":
            image = Constants.shared.images.audioIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Voice note"
        case "pdf", "doc":
            image = Constants.shared.images.documentsIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Document"
        case "link":
            image = Constants.shared.images.linkIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
        default:
            break
        }
        // Create Attachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        // Set bound to reposition
//        let imageOffsetY: CGFloat = -5.0
//        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: initalType + " " + (message ?? ""))
        completeText.append(textAfterIcon)
        return completeText
    }
    
    @objc func cancelReply(_ sender:UIButton) {
        onClickCancelReplyPreview?()
    }
    
    @objc func onReplyPreviewClicked(_ gesture: UITapGestureRecognizer) {
        onClickReplyPreview?()
    }
}
