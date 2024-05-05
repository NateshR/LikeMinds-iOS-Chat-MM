//
//  LMChatroomHeaderMessageView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 25/04/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS

open class LMChatroomHeaderMessageView: LMView {
    
    struct ContentModel {
        let title: String?
        let createdBy: String?
        let chatroomImageUrl: String?
        let messageId: String?
        let customTitle: String?
        let createdTime: String?
    }
    
    open private(set) lazy var creatorProfileContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    open private(set) lazy var nameAndTimeContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .leading
        view.spacing = 2
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    open private(set) lazy var nameLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Pushpendra Singh \(Constants.shared.strings.dot)"
        label.numberOfLines = 1
        label.font = Appearance.shared.fonts.textFont2
        label.textColor = Appearance.shared.colors.black
        return label
    }()
    
    open private(set) lazy var timeLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "01:22"
        label.numberOfLines = 1
        label.font = Appearance.shared.fonts.subHeadingFont1
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        return label
    }()
    
    open private(set) lazy var creatorProfileImageView: LMChatProfileView = {
        let image = LMChatProfileView().translatesAutoresizingMaskIntoConstraints()
        image.imageView.image = Constants.shared.images.placeholderImage
        return image
    }()
    
    open private(set) lazy var chatroomTitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.numberOfLines = 0
        label.font = Appearance.shared.fonts.subHeadingFont2
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        return label
    }()
    
    var onTopicViewClick: ((String) -> Void)?
    var topicData: ContentModel?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = .white
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(creatorProfileContainerView)
        addSubview(chatroomTitleLabel)
        creatorProfileContainerView.addArrangedSubview(creatorProfileImageView)
        creatorProfileContainerView.addArrangedSubview(nameAndTimeContainerView)
        nameAndTimeContainerView.addArrangedSubview(nameLabel)
        nameAndTimeContainerView.addArrangedSubview(timeLabel)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            creatorProfileContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            creatorProfileContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            creatorProfileContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            
            chatroomTitleLabel.leadingAnchor.constraint(equalTo: creatorProfileContainerView.leadingAnchor),
            chatroomTitleLabel.trailingAnchor.constraint(equalTo: creatorProfileContainerView.trailingAnchor),
            chatroomTitleLabel.topAnchor.constraint(equalTo: creatorProfileContainerView.bottomAnchor, constant: 6),
            chatroomTitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func setData(_ data: ContentModel) {
        topicData = data
        nameLabel.text = data.createdBy
        timeLabel.text = data.createdTime
        chatroomTitleLabel.attributedText = GetAttributedTextWithRoutes.getAttributedText(from: data.title ?? "", withTextColor: Appearance.shared.colors.black)
        creatorProfileImageView.imageView.kf.setImage(with: URL(string: data.chatroomImageUrl ?? ""), placeholder: UIImage.generateLetterImage(name: data.createdBy ?? ""))
    }
}
