//
//  LMChatProfileView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 02/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMChatProfileView: LMView {
    /// The `UIImageView` instance that shows the avatar image.
    open private(set) var imageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 48)
        image.setHeightConstraint(with: 48)
        image.image = Constants.shared.images.personCircleFillIcon
        return image
    }()
    
    override open var intrinsicContentSize: CGSize {
        imageView.image?.size ?? super.intrinsicContentSize
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = min(imageView.bounds.width, imageView.bounds.height) / 2
    }

    open override func setupAppearance() {
        super.setupAppearance()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(imageView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: imageView)
    }
}
