//
//  SearchListNoResultView.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 05/05/24.
//

import UIKit

open class LMChatSearchNoResultView: LMView {
    open private(set) lazy var containerView: LMView = {
        let view = LMView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open private(set) lazy var placeholderImage: LMImageView = {
        let image = LMImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
//        image.image = UIImage(named: "noDataImage", in: Bundle(for: SearchListNoResultView.self), with: nil)
        return image
    }()
    
    open private(set) lazy var placeholderText: LMLabel = {
        let label = LMLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Results Found"
        label.textAlignment = .center
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.gray51
        return label
    }()
    
    
    open override func setupViews() {
        super.setupViews()
        
        addSubviewWithDefaultConstraints(containerView)
        containerView.addSubview(placeholderImage)
        containerView.addSubview(placeholderText)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        placeholderImage.addConstraint(centerX: (containerView.centerXAnchor, 0),
                                       centerY: (containerView.centerYAnchor, -60))
        placeholderImage.setHeightConstraint(with: 64)
        placeholderImage.setWidthConstraint(with: placeholderImage.heightAnchor)
        
        placeholderText.addConstraint(top: (placeholderImage.bottomAnchor, 16),
                                      leading: (containerView.leadingAnchor, 16),
                                      trailing: (containerView.trailingAnchor, -16))
    }
}
