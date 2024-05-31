//
//  LMNavigationBarItem.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 15/02/24.
//

import Foundation
import UIKit
import LMChatUI_iOS

public class LMBarButtonItem: UIBarButtonItem {
    
    override public init() {
        super.init()
        self.customView = containerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.addSubview(itemsContainerStackView)
        view.pinSubView(subView: itemsContainerStackView)
        view.addSubviewWithDefaultConstraints(actionButton)
        return view
    }()
    
    open private(set) lazy var itemsContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 0
        view.addArrangedSubview(backArrow)
        view.addArrangedSubview(imageView)
        return view
    }()
    
    open private(set) lazy var backArrow: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 18)
        image.setHeightConstraint(with: 24)
        image.contentMode = .center
        image.image = Constants.shared.images.leftArrowIcon.withSystemImageConfig(pointSize: 18, weight: .semibold, scale: .large)
        image.tintColor = .link
        image.isUserInteractionEnabled = true
        return image
    }()
    
    open private(set) lazy var imageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 36)
        image.setHeightConstraint(with: 36)
        image.contentMode = .scaleAspectFill
        image.tintColor = .link
        image.isUserInteractionEnabled = true
        image.cornerRadius(with: 18)
        return image
    }()
    
    open private(set) lazy var actionButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        return button
    }()
}
