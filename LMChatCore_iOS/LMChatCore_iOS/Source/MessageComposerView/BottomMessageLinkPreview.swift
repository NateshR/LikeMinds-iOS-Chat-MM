//
//  BottomMessageLinkPreview.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 31/01/24.
//

import Foundation
import LMChatUI_iOS

@IBDesignable
open class BottomMessageLinkPreview: LMView {
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = Appearance.shared.colors.gray3
        return view
    }()
    
    open private(set) lazy var subviewContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 8)
        view.backgroundColor = Appearance.shared.colors.gray3
        return view
    }()
    
    open private(set) lazy var linkTitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "fabook new wil "
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.textColor
        label.numberOfLines = 1
        return label
    }()
    
    open private(set) lazy var linkSubtitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "test the facebook.com data present"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 1
        label.textColor = Appearance.shared.colors.textColor
        return label
    }()
    
    open private(set) lazy var linkLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "facebeook.com"
        label.font = Appearance.shared.fonts.textFont2
        label.numberOfLines = 1
        label.textColor = Appearance.shared.colors.textColor
        return label
    }()
    
    open private(set) lazy var messageAttachmentImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.backgroundColor = .green
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
    
    open private(set) lazy var verticleLinkDetailContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 2
        return view
    }()
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(horizontalReplyStackView)
        containerView.addSubview(messageAttachmentImageView)
        horizontalReplyStackView.addArrangedSubview(verticleLinkDetailContainerStackView)
        horizontalReplyStackView.addArrangedSubview(closeReplyButton)
        verticleLinkDetailContainerStackView.addArrangedSubview(linkTitleLabel)
        verticleLinkDetailContainerStackView.addArrangedSubview(linkSubtitleLabel)
        verticleLinkDetailContainerStackView.addArrangedSubview(linkLabel)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            messageAttachmentImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            messageAttachmentImageView.widthAnchor.constraint(equalToConstant: 50),
            messageAttachmentImageView.heightAnchor.constraint(equalToConstant: 50),
            messageAttachmentImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            horizontalReplyStackView.leadingAnchor.constraint(equalTo: messageAttachmentImageView.trailingAnchor, constant: 10),
            horizontalReplyStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            horizontalReplyStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            horizontalReplyStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
            
        ])
    }
}
