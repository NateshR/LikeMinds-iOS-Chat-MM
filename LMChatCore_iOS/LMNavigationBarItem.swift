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
        image.setWidthConstraint(with: 20)
        image.setHeightConstraint(with: 40)
        image.contentMode = .center
        image.image = Constants.shared.images.leftArrowIcon.withSystemImageConfig(pointSize: 20, weight: .light, scale: .large)
        image.tintColor = .systemGreen
        image.isUserInteractionEnabled = true
        return image
    }()
    
    open private(set) lazy var imageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 40)
        image.setHeightConstraint(with: 40)
        image.contentMode = .scaleAspectFill
        image.image = Constants.shared.images.personCircleFillIcon//.withSystemImageConfig(pointSize: 40, weight: .light, scale: .large)
        image.tintColor = .systemGreen
        image.isUserInteractionEnabled = true
        return image
    }()
    
    
}
