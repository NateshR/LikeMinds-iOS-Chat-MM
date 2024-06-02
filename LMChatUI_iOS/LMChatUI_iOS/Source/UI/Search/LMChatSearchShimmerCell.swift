//
//  LMChatSearchShimmerCell.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 06/05/24.
//

import UIKit

open class LMChatSearchShimmerCell: LMView {
    open private(set) lazy var containerView: LMView = {
        let view = LMView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var profileShimmerView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var titleShimmerView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var subtitleShimmerView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var bodyShimmerView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    
    open override func setupViews() {
        super.setupViews()
        
        addSubviewWithDefaultConstraints(containerView)
        containerView.addSubview(profileShimmerView)
        containerView.addSubview(titleShimmerView)
        containerView.addSubview(subtitleShimmerView)
        containerView.addSubview(bodyShimmerView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
                
        profileShimmerView.addConstraint(top: (containerView.topAnchor, 8),
                                         bottom: (containerView.bottomAnchor, -8),
                                         leading: (containerView.leadingAnchor, 8))
        profileShimmerView.setWidthConstraint(with: profileShimmerView.heightAnchor)
        
        titleShimmerView.addConstraint(top: (profileShimmerView.topAnchor, 0),
                                       leading: (profileShimmerView.trailingAnchor, 16))
        titleShimmerView.setHeightConstraint(with: 12)
        titleShimmerView.setWidthConstraint(with: containerView.widthAnchor, multiplier: 0.7)
        
        subtitleShimmerView.addConstraint(top: (titleShimmerView.bottomAnchor, 8),
                                          leading: (titleShimmerView.leadingAnchor, 0))
        subtitleShimmerView.setHeightConstraint(with: 12)
        subtitleShimmerView.setWidthConstraint(with: containerView.widthAnchor, multiplier: 0.3)
        
        bodyShimmerView.addConstraint(top: (subtitleShimmerView.bottomAnchor, 8),
                                      leading: (titleShimmerView.leadingAnchor, 0))
        bodyShimmerView.setHeightConstraint(with: 12)
        bodyShimmerView.setWidthConstraint(with: containerView.widthAnchor, multiplier: 0.7)
        bodyShimmerView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -8).isActive = true
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        
        profileShimmerView.layer.cornerRadius = 16
        titleShimmerView.layer.cornerRadius = 4
        subtitleShimmerView.layer.cornerRadius = 4
        bodyShimmerView.layer.cornerRadius = 4
    }
}
