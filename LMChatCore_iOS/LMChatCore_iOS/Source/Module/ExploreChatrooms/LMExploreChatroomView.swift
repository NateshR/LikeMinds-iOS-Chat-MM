//
//  LMExploreChatroomView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LMChatUI_iOS
import Kingfisher

@IBDesignable
open class LMExploreChatroomView: LMView {
    
    public struct ContentModel {
        public let userName: String?
        public let title: String?
        public let chatroomName: String?
        public let chatroomImageUrl: String?
        public let isSecret: Bool?
        public let isAnnouncementRoom: Bool?
        public let participantsCount: Int?
        public let messageCount: Int?
        public let isFollowed: Bool?
        public let chatroomId: String
        public let externalSeen: Bool?
        public let isPinned: Bool?
        
        public init(userName: String?, title: String?, chatroomName: String?, chatroomImageUrl: String?, isSecret: Bool?, isAnnouncementRoom: Bool?, participantsCount: Int?, messageCount: Int?, isFollowed: Bool?, chatroomId: String, externalSeen: Bool?, isPinned: Bool?) {
            self.userName = userName
            self.title = title
            self.chatroomName = chatroomName
            self.chatroomImageUrl = chatroomImageUrl
            self.isFollowed = isFollowed
            self.isSecret = isSecret
            self.isAnnouncementRoom = isAnnouncementRoom
            self.participantsCount = participantsCount
            self.messageCount = messageCount
            self.chatroomId = chatroomId
            self.externalSeen = externalSeen
            self.isPinned = isPinned
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
        view.alignment = .top
        view.spacing = 10
        view.addArrangedSubview(chatroomImageView)
        view.addArrangedSubview(chatroomNameAndCountContainerStackView)
        view.addArrangedSubview(joinButton)
        return view
    }()
    
    open private(set) lazy var chatroomNameAndCountContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .top
        view.spacing = 2
        view.addArrangedSubview(chatroomNameContainerStackView)
        view.addArrangedSubview(chatroomParticipantsCountLabel)
        return view
    }()
    
    open private(set) lazy var chatroomNameContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 2
        view.addArrangedSubview(chatroomNameLabel)
        view.addArrangedSubview(lockAndAnnouncementIconContainerStackView)
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
    
    open private(set) lazy var newLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "NEW"
        label.font = Appearance.shared.fonts.textFont2
        label.textColor = Appearance.shared.colors.white
        label.backgroundColor = Appearance.shared.colors.red
        label.numberOfLines = 1
        label.setPadding(with: UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6))
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var chatroomParticipantsCountLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.subHeadingFont1
        label.textColor = Appearance.shared.colors.textColor
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var chatroomTitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "t"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 3
        label.textColor = Appearance.shared.colors.textColor
        return label
    }()

    
    open private(set) lazy var chatroomImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
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
    
    open private(set) lazy var pinnedIconImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 22)
        image.setHeightConstraint(with: 22)
        image.backgroundColor = .white
        image.cornerRadius(with: 11)
        image.image = Constants.shared.images.pinCircleFillIcon.withSystemImageConfig(pointSize: 22)
        image.tintColor = Appearance.shared.colors.linkColor
        return image
    }()
    
    open private(set) lazy var joinButton: LMButton = {
        let button = LMButton.createButton(with: "Join", image: UIImage(systemName: "bell.fill"), textColor: Appearance.shared.colors.linkColor, textFont: Appearance.shared.fonts.headingFont1, contentSpacing: .init(top: 10, left: 10, bottom: 10, right: 10))
        button.setFont(Appearance.shared.fonts.headingFont1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.tintColor = .link
        button.borderColor(withBorderWidth: 1, with: .link)
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.cornerRadius(with: 8)
        button.addTarget(self, action: #selector(joinButtonClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var spacerBetweenLockAndTimestamp: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: 4, relatedBy: .greaterThanOrEqual)
        return view
    }()
    
    var viewData: ContentModel?
    var onJoinButtonClick: ((_ value: Bool, _ chatroomId: String) -> Void)?
    
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(chatroomContainerStackView)
        containerView.addSubview(chatroomTitleLabel)
        containerView.addSubview(pinnedIconImageView)
        containerView.addSubview(newLabel)
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
            
            chatroomTitleLabel.leadingAnchor.constraint(equalTo: chatroomImageView.trailingAnchor, constant: 8),
            chatroomTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chatroomTitleLabel.topAnchor.constraint(equalTo: chatroomContainerStackView.bottomAnchor, constant: -4),
            chatroomTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            newLabel.centerXAnchor.constraint(equalTo: chatroomImageView.centerXAnchor),
            newLabel.topAnchor.constraint(equalTo: chatroomImageView.bottomAnchor, constant: -12),
            pinnedIconImageView.trailingAnchor.constraint(equalTo: chatroomImageView.trailingAnchor, constant: 6),
            pinnedIconImageView.bottomAnchor.constraint(equalTo: chatroomImageView.bottomAnchor, constant: -6),
        ])
    }
    
    open func setData(_ data: ContentModel) {
        self.viewData = data
        chatroomNameLabel.text = data.chatroomName
        chatroomTitleLabel.text = data.title
        getAttachmentText(participantCount: data.participantsCount ?? 0, messageCount: data.messageCount ?? 0)
        newLabel.isHidden = data.externalSeen ?? true
        pinnedIconImageView.isHidden = !(data.isPinned ?? false)
        announcementIconImageView.isHidden = !(data.isAnnouncementRoom ?? false)
        lockIconImageView.isHidden = !(data.isSecret ?? false)
        joinButtonTitle(data.isFollowed ?? false)
        let placeholder = UIImage.generateLetterImage(name: data.chatroomName?.components(separatedBy: " ").first)
        if let imageUrl = data.chatroomImageUrl, let url = URL(string: imageUrl) {
            chatroomImageView.kf.setImage(with: url, placeholder: placeholder)
        } else {
            chatroomImageView.image = placeholder
        }
    }
    
    func getAttachmentText(participantCount: Int, messageCount: Int) {
        let participantsImageAttachment = NSTextAttachment()
        participantsImageAttachment.image = Constants.shared.images.person2Icon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor)
        
        let messageImageAttachment = NSTextAttachment()
        messageImageAttachment.image = Constants.shared.images.messageIcon.withSystemImageConfig(pointSize: 12)?.withTintColor(Appearance.shared.colors.textColor)
        
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: participantsImageAttachment))
        fullString.append(NSAttributedString(string: " \(participantCount) "))
        fullString.append(NSAttributedString(string: " \(Constants.shared.strings.dot) "))
        fullString.append(NSAttributedString(attachment: messageImageAttachment))
        fullString.append(NSAttributedString(string: " \(messageCount) "))
        chatroomParticipantsCountLabel.attributedText = fullString
    }
    
    @objc func joinButtonClicked(_ sender: UIButton) {
        guard let viewData else { return }
        let updatedStatus = !(viewData.isFollowed ?? false)
        joinButtonTitle(updatedStatus)
        onJoinButtonClick?(updatedStatus, viewData.chatroomId)
    }
    
    func joinButtonTitle(_ isFollowed: Bool) {
        if isFollowed {
            joinButton.setTitle("Joined", for: .normal)
            joinButton.tintColor = Appearance.shared.colors.linkColor
            joinButton.setTitleColor(Appearance.shared.colors.linkColor, for: .normal)
            joinButton.backgroundColor = Appearance.shared.colors.white
        } else {
            joinButton.setTitle("Join", for: .normal)
            joinButton.tintColor = Appearance.shared.colors.white
            joinButton.setTitleColor(Appearance.shared.colors.white, for: .normal)
            joinButton.backgroundColor = Appearance.shared.colors.linkColor
        }
    }
}
