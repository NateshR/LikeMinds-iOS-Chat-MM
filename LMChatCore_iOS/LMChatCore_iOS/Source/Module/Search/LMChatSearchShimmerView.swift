//
//  LMChatSearchShimmerView.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 06/05/24.
//

import LMChatUI_iOS
import UIKit

open class LMChatSearchShimmerView: LMView {
    open private(set) lazy var containerView: LMView = {
        let view = LMView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open private(set) lazy var stackView: LMStackView = {
        let stack = LMStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }()
    
    
    open override func setupViews() {
        super.setupViews()
        addSubviewWithDefaultConstraints(stackView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        pinSubView(subView: stackView)
        
        for _ in 0..<5 {
            let shimmer = LMChatSearchShimmerCell()
            shimmer.translatesAutoresizingMaskIntoConstraints = false
            shimmer.setHeightConstraint(with: 88)
            stackView.addArrangedSubview(shimmer)
        }
        
        stackView.addArrangedSubview(UIView())
    }
}
