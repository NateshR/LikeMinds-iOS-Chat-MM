//
//  LMBottomMessageReplyPreview.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 31/01/24.
//

import Foundation
import Kingfisher

public protocol LMBottomMessageReplyPreviewDelegate: AnyObject {
    func clearReplyPreview()
}

@IBDesignable
open class LMChatMessageReplyPreview: LMView {
    
    public struct ContentModel {
        public let username: String?
        public let replyMessage: String?
        public let attachmentsUrls: [(thumbnailUrl: String?, fileUrl: String?, fileType: String?)]?
        public let messageType: Int?
        
        public init(username: String?, replyMessage: String?, attachmentsUrls: [(thumbnailUrl: String?, fileUrl: String?, fileType: String?)]?, messageType: Int?) {
            self.username = username
            self.replyMessage = replyMessage
            self.attachmentsUrls = attachmentsUrls
            self.messageType = messageType
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
        button.tintColor = Appearance.shared.colors.textColor
        button.addTarget(self, action: #selector(cancelReply), for: .touchUpInside)
        button.backgroundColor = Appearance.shared.colors.white.withAlphaComponent(0.6)
        button.setWidthConstraint(with: 25)
        button.setHeightConstraint(with: 25)
        button.cornerRadius(with: 12.5)
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
        containerView.addSubview(closeReplyButton)
        horizontalReplyStackView.addArrangedSubview(verticleUsernameAndMessageContainerStackView)
        horizontalReplyStackView.addArrangedSubview(messageAttachmentImageView)
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
            
            closeReplyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -2),
            closeReplyButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            
            sidePannelColorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sidePannelColorView.topAnchor.constraint(equalTo: containerView.topAnchor),
            sidePannelColorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            sidePannelColorView.widthAnchor.constraint(equalToConstant: 4),
            
            horizontalReplyStackView.leadingAnchor.constraint(equalTo: sidePannelColorView.leadingAnchor, constant: 10),
            horizontalReplyStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            horizontalReplyStackView.topAnchor.constraint(equalTo: sidePannelColorView.topAnchor),
            horizontalReplyStackView.bottomAnchor.constraint(equalTo: sidePannelColorView.bottomAnchor),
            
            messageAttachmentImageView.widthAnchor.constraint(equalToConstant: 60),
            messageAttachmentImageView.heightAnchor.constraint(equalToConstant: 60)
            
            ])
    }
    
    public func setData(_ data: ContentModel) {
        viewData = data
        self.userNameLabel.text = data.username
        let attributedText = GetAttributedTextWithRoutes.getAttributedText(from: data.replyMessage ?? "")
        self.messageLabel.attributedText = createAttributedString(data)
        if let attachmentsUrls = data.attachmentsUrls,
           let firstUrl = (attachmentsUrls.first?.thumbnailUrl ?? attachmentsUrls.first?.fileUrl),
           let url = URL(string: firstUrl) {
           messageAttachmentImageView.kf.setImage(with: url)
            messageAttachmentImageView.isHidden = false
        } else {
            messageAttachmentImageView.isHidden = true
        }
    }
    
    public func setDataForEdit(_ data: ContentModel) {
        viewData = data
        self.userNameLabel.text = "Edit message"
        self.messageLabel.attributedText = createAttributedString(data)
        messageAttachmentImageView.isHidden = true
        
    }
    
    func createAttributedString(_ data: ContentModel) -> NSAttributedString {
        let message = GetAttributedTextWithRoutes.getAttributedText(from: data.replyMessage ?? "")
        guard let count = data.attachmentsUrls?.count, count > 0, let fileType = data.attachmentsUrls?.first?.fileType  else {
            let attributedText = NSMutableAttributedString(string: "")
            if data.messageType == 10 {
                let image = Constants.shared.images.pollIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
                attributedText.append(NSAttributedString(attachment: NSTextAttachment(image: image)))
            }
            attributedText.append(NSAttributedString(string: " " + (data.replyMessage ?? "")))
            return attributedText
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
            image = Constants.shared.images.micIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Voice note"
        case "pdf", "doc":
            image = Constants.shared.images.documentsIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Document"
        case "link":
            image = Constants.shared.images.linkIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
        case "gif":
            image = Constants.shared.images.gifBadgeIcon
            initalType = "GIF"
        default:
            break
        }
        
        let attributedText = NSMutableAttributedString(string: "")
        
        if fileType.lowercased() == "gif" {
            let textAtt = NSTextAttachment(image: image)
            textAtt.bounds = CGRect(x: 0, y: -4, width: 24, height: 16)
            attributedText.append(NSAttributedString(string: " "))
            attributedText.append(NSAttributedString(attachment: textAtt))
            attributedText.append(NSAttributedString(string: " \(initalType) "))
        } else {
            if count > 1 {
                attributedText.append(NSAttributedString(attachment: NSTextAttachment(image: image)))
                attributedText.append(NSAttributedString(string: " (+\(count - 1) more) "))
            } else {
                attributedText.append(NSAttributedString(string: " "))
                attributedText.append(NSAttributedString(attachment: NSTextAttachment(image: image)))
                attributedText.append(NSAttributedString(string: " \(initalType) "))
            }
        }
        attributedText.append(message)
        
        return attributedText
    }
    
    @objc func cancelReply(_ sender:UIButton) {
        onClickCancelReplyPreview?()
    }
    
    @objc func onReplyPreviewClicked(_ gesture: UITapGestureRecognizer) {
        onClickReplyPreview?()
    }
}
