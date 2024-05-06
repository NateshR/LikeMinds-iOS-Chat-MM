//
//  SearchMessageCell.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 16/04/24.
//

// TODO: Move to UI Library

import LMChatUI_iOS
import UIKit

public class SearchMessageCell: LMTableViewCell {
    public struct ContentModel: SearchCellProtocol {
        public var chatroomID: String
        public var messageID: String?
        public let chatroomName: String
        public let message: String
        public let senderName: String
        public let date: Date
        public let isJoined: Bool
        
        public init(chatroomID: String, messageID: String, chatroomName: String, message: String, senderName: String, date: Date, isJoined: Bool) {
            self.chatroomID = chatroomID
            self.messageID = messageID
            self.chatroomName = chatroomName
            self.message = message
            self.senderName = senderName
            self.date = date
            self.isJoined = isJoined
        }
    }
    
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
        label.numberOfLines = 2
        return label
    }()
    
    lazy var dateLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.headingFont2
        label.textColor = Appearance.shared.colors.black
        return label
    }()
    
    lazy var isJoinedLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "chat room not joined yet"
        label.font = Appearance.shared.fonts.headingFont2
        label.textColor = Appearance.shared.colors.gray51
        return label
    }()
    
    lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .lightGray
        return view
    }()
    
    open override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(isJoinedLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(sepratorView)
    }
    
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        containerView.addConstraint(top: (contentView.topAnchor, 0),
                                    leading: (contentView.leadingAnchor, 0),
                                    trailing: (contentView.trailingAnchor, 0))
        
        containerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor).isActive = true
        
        titleLabel.addConstraint(top: (containerView.topAnchor, 8),
                                 leading: (containerView.leadingAnchor, 8))
        
        subtitleLabel.addConstraint(top: (titleLabel.bottomAnchor, 8),
                                    leading: (titleLabel.leadingAnchor, 0))
        subtitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -8).isActive = true
        
        isJoinedLabel.addConstraint(top: (subtitleLabel.bottomAnchor, 8),
                                    leading: (subtitleLabel.leadingAnchor, 0))
        
        sepratorView.addConstraint(bottom: (containerView.bottomAnchor, 0),
                                   leading: (titleLabel.leadingAnchor, 0),
                                   trailing: (dateLabel.trailingAnchor, 0))
        sepratorView.topAnchor.constraint(equalTo: isJoinedLabel.bottomAnchor, constant: 8).isActive = true
        sepratorView.setHeightConstraint(with: 1)
        
        dateLabel.addConstraint(top: (titleLabel.topAnchor, 0),
                                trailing: (containerView.trailingAnchor, -8))
        dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8).isActive = true
        
        
        sepratorView.isHidden = true
    }
    
    func configure(with data: ContentModel) {
        titleLabel.text = data.chatroomName
        subtitleLabel.attributedText = GetAttributedTextWithRoutes.getAttributedText(
            from: "\(data.senderName): \(data.message)",
            andPrefix: "@",
            allowLink: false,
            allowHashtags: false
        )
        isJoinedLabel.isHidden = data.isJoined
        dateLabel.text = data.date.inString(dateFormat: "dd/MM/yy")
    }
}


// TODO: Move to UI Library
extension Date {
    func inString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
