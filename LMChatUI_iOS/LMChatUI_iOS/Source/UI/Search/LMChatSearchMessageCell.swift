//
//  LMChatSearchMessageCell.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 16/04/24.
//

import UIKit

public class LMChatSearchMessageCell: LMTableViewCell {
    public struct ContentModel: LMChatSearchCellDataProtocol {
        public var chatroomID: String
        public var messageID: String?
        public let chatroomName: String
        public let message: String
        public let senderName: String
        public let date: TimeInterval
        public let isJoined: Bool
        public let highlightedText: String
        public let userImageUrl: String?

        public init(
            chatroomID: String, messageID: String?, chatroomName: String,
            message: String, senderName: String, date: TimeInterval,
            isJoined: Bool, highlightedText: String, userImageUrl: String?
        ) {
            self.chatroomID = chatroomID
            self.messageID = messageID
            self.chatroomName = chatroomName
            self.message = message
            self.senderName = senderName
            self.date = date
            self.isJoined = isJoined
            self.highlightedText = highlightedText
            self.userImageUrl = userImageUrl
        }
    }

    lazy var userImageIcon: LMImageView = {
        // Create a custom image view, disable default autoresizing mask, and configure appearance.
        let image = LMImageView()
            .translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.setWidthConstraint(with: 60)
        image.setHeightConstraint(with: 60)
        image.cornerRadius(with: 30)
        return image
    }()

    lazy var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Testing"
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.black
        return label
    }()

    lazy var subtitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Notification"
        label.numberOfLines = 0
        label.textColor = Appearance.shared.colors.gray102
        return label
    }()

    lazy var dateLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.headingFont2
        label.textColor = Appearance.shared.colors.gray155
        return label
    }()

    open override func setupViews() {
        super.setupViews()

        contentView.addSubview(containerView)

        containerView.addSubview(userImageIcon)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(dateLabel)
    }

    open override func setupLayouts() {
        super.setupLayouts()

        containerView.addConstraint(
            top: (contentView.topAnchor, 0),
            leading: (contentView.leadingAnchor, 0),
            trailing: (contentView.trailingAnchor, 0))

        containerView.bottomAnchor.constraint(
            lessThanOrEqualTo: contentView.bottomAnchor
        ).isActive = true

        userImageIcon.addConstraint(
            top: (containerView.topAnchor, 8),
            leading: (containerView.leadingAnchor, 16))
        userImageIcon.bottomAnchor.constraint(
            lessThanOrEqualTo: containerView.bottomAnchor, constant: -8
        ).isActive = true

        titleLabel.addConstraint(
            top: (containerView.topAnchor, 8),
            leading: (userImageIcon.trailingAnchor, 8))

        subtitleLabel.addConstraint(
            top: (titleLabel.bottomAnchor, 8),
            leading: (userImageIcon.trailingAnchor, 8))
        subtitleLabel.bottomAnchor.constraint(
            lessThanOrEqualTo: containerView.bottomAnchor, constant: -8
        ).isActive = true
        subtitleLabel.trailingAnchor.constraint(
            lessThanOrEqualTo: containerView.trailingAnchor, constant: -8
        ).isActive = true

        dateLabel.addConstraint(
            top: (titleLabel.topAnchor, 0),
            trailing: (containerView.trailingAnchor, -16))
        dateLabel.leadingAnchor.constraint(
            greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8
        ).isActive = true

    }

    open func configure(with data: ContentModel) {
        titleLabel.text = data.senderName

        var attrText = GetAttributedTextWithRoutes.getAttributedText(
            from: data.message,
            andPrefix: "@",
            allowLink: false,
            allowHashtags: false
        )

        attrText = GetAttributedTextWithRoutes.detectAndHighlightText(
            in: attrText, text: data.highlightedText)

        subtitleLabel.attributedText = attrText
        dateLabel.text = LMChatDateUtility.formatDate(data.date)

        if let image = data.userImageUrl {
            userImageIcon.kf.setImage(
                with: URL(string: image),
                placeholder: UIImage.generateLetterImage(
                    name: data.senderName.components(separatedBy: " ").first
                        ?? ""))
        }
    }
}
