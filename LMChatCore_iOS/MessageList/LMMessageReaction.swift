//
//  LMMessageReaction.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 04/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMMessageReaction: LMView {
    /// The `UIImageView` instance that shows the avatar image.
    /// Container holding all previews.
    open private(set) lazy var previewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 2
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    open private(set) lazy var emojiLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = "🥰"
        return label
    }()
    
    open private(set) lazy var countLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "1"
        return label
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = .cyan
        cornerRadius(with: 8)
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(previewsContainerView)
        previewsContainerView.addArrangedSubview(emojiLabel)
        previewsContainerView.addArrangedSubview(countLabel)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: previewsContainerView)
    }
}
