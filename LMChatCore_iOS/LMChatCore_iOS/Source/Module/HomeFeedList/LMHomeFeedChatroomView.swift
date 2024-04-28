//
//  LMHomeFeedChatroomView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 08/02/24.
//

import Foundation
import LMChatUI_iOS
import Kingfisher

@IBDesignable
open class LMHomeFeedChatroomView: LMView {
    
    public struct ContentModel {
        public let userName: String
        public let lastMessage: String
        public let chatroomName: String
        public let chatroomImageUrl: String?
        public let isMuted: Bool
        public let isSecret: Bool
        public let isAnnouncementRoom: Bool
        public let unreadCount: Int
        public let timestamp: String
        public let fileType: String?
        
        public init(userName: String, lastMessage: String, chatroomName: String, chatroomImageUrl: String?, isMuted: Bool, isSecret: Bool, isAnnouncementRoom: Bool, unreadCount: Int, timestamp: String, fileType: String?) {
            self.userName = userName
            self.lastMessage = lastMessage
            self.chatroomName = chatroomName
            self.chatroomImageUrl = chatroomImageUrl
            self.isMuted = isMuted
            self.isSecret = isSecret
            self.isAnnouncementRoom = isAnnouncementRoom
            self.unreadCount = unreadCount
            self.timestamp = timestamp
            self.fileType = fileType
        }
        
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var subviewContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 8)
        view.backgroundColor = Appearance.shared.colors.gray3
        return view
    }()
    
    open private(set) lazy var chatroomContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 10
        view.addArrangedSubview(chatroomImageView)
        view.addArrangedSubview(chatroomNameAndMessageContainerStackView)
        return view
    }()
    
    open private(set) lazy var chatroomNameAndMessageContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 5
        view.addArrangedSubview(chatroomNameContainerStackView)
        view.addArrangedSubview(chatroomMessageContainerStackView)
        return view
    }()
    
    open private(set) lazy var chatroomNameContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 2
        view.addArrangedSubview(chatroomNameLabel)
        view.addArrangedSubview(lockAndAnnouncementIconContainerStackView)
        view.addArrangedSubview(spacerBetweenLockAndTimestamp)
        view.addArrangedSubview(timestampLabel)
        return view
    }()
    
    open private(set) lazy var chatroomMessageContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 2
        view.addArrangedSubview(lastMessageLabel)
        view.addArrangedSubview(muteAndBadgeIconContainerStackView)
        return view
    }()
    
    open private(set) lazy var chatroomNameLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Chatname"
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.textColor
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var lastMessageLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "You: test the facebook.com data present"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 1
        label.textColor = Appearance.shared.colors.textColor
        return label
    }()
    
    open private(set) lazy var timestampLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "yesterday"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 1
        label.textColor = Appearance.shared.colors.textColor
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var chatroomImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.setWidthConstraint(with: 54)
        image.setHeightConstraint(with: 54)
        image.image = Constants.shared.images.personCircleFillIcon
        image.cornerRadius(with: 27)
        return image
    }()
    
    open private(set) lazy var lockAndAnnouncementIconContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 5
        view.addArrangedSubview(lockIconImageView)
        view.addArrangedSubview(announcementIconImageView)
        return view
    }()
    
    open private(set) lazy var lockIconImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 18)
        image.setHeightConstraint(with: 18)
        image.image = Constants.shared.images.lockFillIcon
        image.tintColor = .lightGray
        return image
    }()
    
    open private(set) lazy var announcementIconImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 18)
        image.setHeightConstraint(with: 18)
        image.image = Constants.shared.images.annoucementIcon
        image.tintColor = .systemYellow
        return image
    }()
    
    open private(set) lazy var spacerBetweenLockAndTimestamp: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: 4, relatedBy: .greaterThanOrEqual)
        return view
    }()
    
    open private(set) lazy var muteAndBadgeIconContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fill
        view.spacing = 5
        view.addArrangedSubview(tagIconImageView)
        view.addArrangedSubview(muteIconImageView)
        view.addArrangedSubview(chatroomCountBadgeLabel)
        return view
    }()
    
    open private(set) lazy var tagIconImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 18)
        image.setHeightConstraint(with: 18)
        image.image = Constants.shared.images.tagFillIcon
        image.tintColor = .systemGreen
        return image
    }()
    
    open private(set) lazy var muteIconImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 18)
        image.setHeightConstraint(with: 18)
        image.image = Constants.shared.images.muteFillIcon
        image.tintColor = .lightGray
        return image
    }()
    
    open private(set) lazy var chatroomCountBadgeLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "20+"
        label.font = Appearance.shared.fonts.headingFont2
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemGreen
        label.setWidthConstraint(with: 18, relatedBy: .greaterThanOrEqual)
        label.setHeightConstraint(with: 18)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.cornerRadius(with: 9)
        label.setPadding(with: UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4))
        return label
    }()
    
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(chatroomContainerStackView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            chatroomContainerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            chatroomContainerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chatroomContainerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            chatroomContainerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
        ])
    }
    
    open func setData(_ data: ContentModel) {
        chatroomNameLabel.text = data.chatroomName
//        lastMessageLabel.text = data.lastMessage
        lastMessageLabelSet(data)
        muteIconImageView.isHidden = !data.isMuted
        announcementIconImageView.isHidden = !data.isAnnouncementRoom
        lockIconImageView.isHidden = !data.isSecret
        tagIconImageView.isHidden = true
        chatroomCountBadgeLabel.isHidden = data.unreadCount <= 0
        chatroomCountBadgeLabel.text = data.unreadCount > 99 ? "+99" : "\(data.unreadCount)"
        timestampLabel.text = data.timestamp
        let placeholder = UIImage.generateLetterImage(name: data.chatroomName.components(separatedBy: " ").first ?? "")
        if let imageUrl = data.chatroomImageUrl, let url = URL(string: imageUrl) {
            chatroomImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            chatroomImageView.image = placeholder
        }
    }
    
    func lastMessageLabelSet(_ data: ContentModel) {
        let fileType = data.fileType ?? ""
        var initalType = ""
        var image = UIImage()
        switch fileType.lowercased() {
        case "image", "video":
            image = Constants.shared.images.galleryIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor) ?? UIImage()
            initalType = "Photo"
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
        let textAfterIcon = NSAttributedString(string: initalType + " " + (data.lastMessage))
        completeText.append(textAfterIcon)
        lastMessageLabel.attributedText = textAfterIcon
    }
}
