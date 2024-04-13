//
//  LMBottomMessageLinkPreview.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 31/01/24.
//

import Foundation
import LMChatUI_iOS
import Kingfisher

public protocol LMBottomMessageLinkPreviewDelete: AnyObject {
    func closeLinkPreview()
}

@IBDesignable
open class LMBottomMessageLinkPreview: LMView {
    
    public struct ContentModel {
        public let link: String
        public let title: String
        public let description: String
        public let imageUrl: String?
        
        public init(title: String, description: String, link: String, imageUrl: String?) {
            self.title = title
            self.description = description
            self.link = link
            self.imageUrl = imageUrl
        }
    }
    
    public weak var delegate: LMBottomMessageLinkPreviewDelete?
    
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
    
    open private(set) lazy var linkPreviewImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.backgroundColor = .green
        return image
    }()
    
    open private(set) lazy var closeReplyButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.xmarkIcon, for: .normal)
        button.addTarget(self, action: #selector(closeButtonClicked), for: .touchUpInside)
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
        containerView.addSubview(linkPreviewImageView)
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
            
            linkPreviewImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            linkPreviewImageView.widthAnchor.constraint(equalToConstant: 50),
            linkPreviewImageView.heightAnchor.constraint(equalToConstant: 50),
            linkPreviewImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            horizontalReplyStackView.leadingAnchor.constraint(equalTo: linkPreviewImageView.trailingAnchor, constant: 10),
            horizontalReplyStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            horizontalReplyStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            horizontalReplyStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
            
        ])
    }
    
    public func setData(_ data: ContentModel) {
        linkLabel.text = data.link
        linkTitleLabel.text = data.title
        linkSubtitleLabel.text = data.description
        let placeholder = Constants.Images.shared.brokenLink
        if let imageUrl = data.imageUrl, let url = URL(string: imageUrl) {
            linkPreviewImageView.kf.setImage(with: url)
        } else {
            linkPreviewImageView.image = placeholder
        }
    }
    
    @objc func closeButtonClicked(_ sender:UIButton) {
        delegate?.closeLinkPreview()
    }
    
}
