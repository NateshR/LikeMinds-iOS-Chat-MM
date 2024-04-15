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
        
        public init(image: UIImage?, fileUrl: URL?) {
            self.image = image
            self.fileUrl = fileUrl
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageClicked))
        tapGesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(tapGesture)
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
        self.containerView.backgroundColor = .black
    }
    
    // MARK: setData
    open func setData(with data: ContentModel) {
        imageView.borderColor(withBorderWidth: 2, with: .clear)
        if let url = data.fileUrl {
            imageView.image = nil
            playIconImage.isHidden = false
        } else {
            playIconImage.isHidden = true
            imageView.image = data.image
        }
    }
    
    @objc private func imageClicked(_ gesture: UITapGestureRecognizer) {
        self.onCellClick?()
    }
}
