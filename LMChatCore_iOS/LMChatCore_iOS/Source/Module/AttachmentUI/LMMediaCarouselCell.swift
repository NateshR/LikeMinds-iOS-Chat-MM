//
//  LMMediaCarouselCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 14/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMMediaCarouselCell: LMCollectionViewCell {
    
    public struct ContentModel {
        public let image: UIImage?
        public let fileUrl: URL?
        public let fileType: String?
        public let thumbnailUrl: URL?
        public var isSelected: Bool
        
        public init(image: UIImage?, fileUrl: URL?, fileType: String, thumbnailUrl: URL?, isSelected: Bool) {
            self.image = image
            self.fileUrl = fileUrl
            self.fileType = fileType
            self.thumbnailUrl = thumbnailUrl
            self.isSelected = isSelected
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var imageView: LMImageView = {
        let image = LMImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = Appearance.shared.colors.black
        image.isUserInteractionEnabled = true
        image.cornerRadius(with: 8)
        return image
    }()
    
    // MARK: UI Elements
    open private(set) lazy var playIconImage: LMImageView = {
        let image = LMImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .clear
        image.isUserInteractionEnabled = false
        image.image = Constants.shared.images.playIcon
        image.setWidthConstraint(with: 30)
        image.setHeightConstraint(with: 30)
        image.tintColor = .white
//        image.cornerRadius(with: 8)
        return image
    }()
    
    public var onCellClick: (() -> Void)?

    // MARK: setupViews
    public override func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(playIconImage)
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
//        tapGesture.numberOfTapsRequired = 1
//        imageView.addGestureRecognizer(tapGesture)
    }
    
    
    // MARK: setupLayouts
    public override func setupLayouts() {
        contentView.pinSubView(subView: containerView)
        containerView.pinSubView(subView: imageView)
        playIconImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        playIconImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
    
    
    // MARK: setupActions
    open override func setupActions() {
        super.setupActions()
    }
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        self.containerView.backgroundColor = .clear
    }
    
    // MARK: setData
    open func setData(with data: ContentModel) {
        if self.isSelected {
            imageView.borderColor(withBorderWidth: 2, with: .green)
        } else {
            imageView.borderColor(withBorderWidth: 2, with: .clear)
        }
        guard let url = data.fileUrl else { return }
        playIconImage.isHidden = true
        switch data.fileType {
        case "photo", "image", "gif":
            imageView.kf.setImage(with: url, options: [.forceRefresh])
        case "video":
            imageView.kf.setImage(with: data.thumbnailUrl)
            playIconImage.isHidden = false
        case "pdf":
            imageView.kf.setImage(with: data.thumbnailUrl)
        case "audio":
            imageView.kf.setImage(with: data.thumbnailUrl)
        default:
            break
        }
    }
    
    @objc private func imageClicked(_ gesture: UITapGestureRecognizer) {
        self.onCellClick?()
    }
}
