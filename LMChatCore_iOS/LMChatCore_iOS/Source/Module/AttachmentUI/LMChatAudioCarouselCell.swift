//
//  LMChatAudioCarouselCell.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import LikeMindsChatUI

open class LMChatAudioCarouselCell: LMCollectionViewCell {
    
    public struct ContentModel {
        public let image: UIImage?
        public let fileUrl: URL?
        public let fileType: String?
        public let thumbnailUrl: URL?
        public var isSelected: Bool
        public let duration: Int?
        
        public init(image: UIImage?, fileUrl: URL?, fileType: String, thumbnailUrl: URL?, isSelected: Bool, duration: Int?) {
            self.image = image
            self.fileUrl = fileUrl
            self.fileType = fileType
            self.thumbnailUrl = thumbnailUrl
            self.isSelected = isSelected
            self.duration = duration
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var imageView: LMImageView = {
        let image = LMImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.backgroundColor = .systemYellow
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
        image.image = Constants.shared.images.audioIcon
        image.setWidthConstraint(with: 30)
        image.setHeightConstraint(with: 30)
        image.tintColor = .white
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
        playIconImage.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -5).isActive = true
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
        imageView.borderColor(withBorderWidth: 2, with: isSelected ? .green : .clear)
    }
    
    @objc private func imageClicked(_ gesture: UITapGestureRecognizer) {
        self.onCellClick?()
    }
}
