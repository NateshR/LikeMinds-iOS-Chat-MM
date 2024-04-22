//
//  LMMessageLinkPreview.swift
//  SampleApp
//
//  Created by Devansh Mohata on 02/04/24.
//

import UIKit
import LMChatUI_iOS

open class LMChatMessageLinkPreview: LMView {
    
    public struct ContentModel {
        public let linkUrl: String?
        public let thumbnailUrl: String?
        public let title: String?
        public let subtitle: String?
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var containerStackView: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    open private(set) lazy var imageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.tintColor = Appearance.shared.colors.textColor
        image.layer.masksToBounds = true
        return image
    }()
        
    open private(set) lazy var metaDataContainerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .clear
        return view
    }()
    
    open private(set) lazy var metaDataStackView: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    open private(set) lazy var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Trial Text"
        label.numberOfLines = 2
        label.font = Appearance.shared.fonts.subHeadingFont2
        label.textColor = Appearance.shared.colors.black
        return label
    }()
    
    open private(set) lazy var descriptionLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Trial Description"
        label.numberOfLines = 2
        label.font = Appearance.shared.fonts.subHeadingFont2
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        return label
    }()
        
    var onClickLinkPriview: ((String) -> Void)?
    var viewData: ContentModel?

    // MARK: setupViews
    open override func setupViews() {
        addSubview(containerView)
        containerView.addSubview(containerStackView)
        containerStackView.addArrangedSubview(imageView)
        containerStackView.addArrangedSubview(metaDataContainerView)
        
        metaDataContainerView.addSubview(metaDataStackView)
        
        metaDataStackView.addArrangedSubview(titleLabel)
        metaDataStackView.addArrangedSubview(descriptionLabel)
        
        isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onLinkClicked))
        tapGuesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGuesture)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            metaDataStackView.leadingAnchor.constraint(equalTo: metaDataContainerView.leadingAnchor, constant: 16),
            metaDataStackView.trailingAnchor.constraint(equalTo: metaDataContainerView.trailingAnchor, constant: -16),
            metaDataStackView.topAnchor.constraint(equalTo: metaDataContainerView.topAnchor, constant: 8),
            metaDataStackView.bottomAnchor.constraint(equalTo: metaDataContainerView.bottomAnchor, constant: -8)
        ])
        
        let height = metaDataStackView.heightAnchor.constraint(equalToConstant: 10)
        height.priority = .defaultLow
        height.isActive = true
        
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 3/2).isActive = true
        containerView.backgroundColor = Appearance.shared.colors.previewBackgroundColor
    }
    
    func setData(_ data: ContentModel) {
        viewData = data
        titleLabel.text = data.title
        descriptionLabel.text = data.subtitle
        let placeholder = UIImage(systemName: "link.icloud")
        imageView.kf.setImage(with: URL(string: data.thumbnailUrl ?? ""), placeholder: placeholder)
    }
    
    @objc func onLinkClicked(_ gesture: UITapGestureRecognizer) {
        guard let url = viewData?.linkUrl else { return }
        onClickLinkPriview?(url)
    }
}
