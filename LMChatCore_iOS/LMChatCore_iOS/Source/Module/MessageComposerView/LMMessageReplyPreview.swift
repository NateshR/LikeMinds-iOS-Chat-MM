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
        public let attachmentsUrls: [(thumbnailUrl: String?, fileUrl: String?)]?
        
        public init(username: String?, replyMessage: String?, attachmentsUrls: [(thumbnailUrl: String?, fileUrl: String?)]?) {
            self.username = username
            self.replyMessage = replyMessage
            self.attachmentsUrls = attachmentsUrls
        }
    }
    
    public weak var delegate: LMBottomMessageReplyPreviewDelegate?
    
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
    
    open private(set) lazy var sidePannelColorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.red
        return view
    }()
    
    open private(set) lazy var userNameLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Username"
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.textColor
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
        image.backgroundColor = .green
        image.cornerRadius(with: 8)
        return image
    }()
    
    open private(set) lazy var closeReplyButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.xmarkIcon, for: .normal)
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
        return view
    }()
    
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
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            sidePannelColorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            sidePannelColorView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            sidePannelColorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            sidePannelColorView.widthAnchor.constraint(equalToConstant: 4),
            
            horizontalReplyStackView.leadingAnchor.constraint(equalTo: sidePannelColorView.leadingAnchor, constant: 10),
            horizontalReplyStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            horizontalReplyStackView.topAnchor.constraint(equalTo: sidePannelColorView.topAnchor),
            horizontalReplyStackView.bottomAnchor.constraint(equalTo: sidePannelColorView.bottomAnchor),
            
            messageAttachmentImageView.widthAnchor.constraint(equalToConstant: 50),
            messageAttachmentImageView.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    
    public func setData(_ data: ContentModel) {
        self.userNameLabel.text = data.username
        self.messageLabel.text = data.replyMessage
        if let attachmentsUrls = data.attachmentsUrls,
           let firstUrl = (attachmentsUrls.first?.thumbnailUrl ?? attachmentsUrls.first?.fileUrl),
           let url = URL(string: firstUrl) {
           messageAttachmentImageView.kf.setImage(with: url)
        }
    }
    
    @objc func clearButtonClicked(_ sender:UIButton) {
        delegate?.clearReplyPreview()
    }
}
