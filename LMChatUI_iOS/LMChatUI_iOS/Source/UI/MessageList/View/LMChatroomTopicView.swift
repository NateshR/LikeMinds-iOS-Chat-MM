//
//  LMChatroomTopicView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 24/04/24.
//

import Foundation
import Kingfisher

open class LMChatroomTopicView: LMView {
    
    public struct ContentModel {
        public let title: String
        public let createdBy: String
        public let chatroomImageUrl: String
        public let topicId: String
        
        public init(title: String, createdBy: String, chatroomImageUrl: String, topicId: String) {
            self.title = title
            self.createdBy = createdBy
            self.chatroomImageUrl = chatroomImageUrl
            self.topicId = topicId
        }
    }
    
    /// The `UIImageView` instance that shows the avatar image.
    /// Container holding all previews.
    open private(set) lazy var topicContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 8
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    open private(set) lazy var nameAndTopicContainerView: LMStackView = {
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
        label.text = ""
        label.numberOfLines = 1
        label.font = Appearance.shared.fonts.textFont2
        label.textColor = Appearance.shared.colors.black
        return label
    }()
    
    open private(set) lazy var topicLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.numberOfLines = 2
        label.font = Appearance.shared.fonts.subHeadingFont1
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        return label
    }()
    
    open private(set) lazy var chatProfileImageView: LMChatProfileView = {
        let image = LMChatProfileView().translatesAutoresizingMaskIntoConstraints()
        image.imageView.image = Constants.shared.images.placeholderImage
        return image
    }()
    
    lazy var bottomLine: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.previewBackgroundColor
        return view
    }()
    
    public var onTopicViewClick: ((String) -> Void)?
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
        addSubview(topicContainerView)
        addSubview(bottomLine)
        topicContainerView.addArrangedSubview(chatProfileImageView)
        topicContainerView.addArrangedSubview(nameAndTopicContainerView)
        nameAndTopicContainerView.addArrangedSubview(nameLabel)
        nameAndTopicContainerView.addArrangedSubview(topicLabel)
        
        isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(clickedOnTopicBar))
        tapGuesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGuesture)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            topicContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            topicContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            topicContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            topicContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            topicContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60),
            bottomLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomLine.topAnchor.constraint(equalTo: bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    @objc private func clickedOnTopicBar(_ gesture: UITapGestureRecognizer) {
        onTopicViewClick?(topicData?.topicId ?? "")
    }
    
    public func setData(_ data: ContentModel) {
        topicData = data
        nameLabel.text = data.createdBy
        topicLabel.text = data.title
        chatProfileImageView.imageView.kf.setImage(with: URL(string: data.chatroomImageUrl), placeholder: UIImage.generateLetterImage(name: data.createdBy.components(separatedBy: " ").first ?? ""))
    }
}
