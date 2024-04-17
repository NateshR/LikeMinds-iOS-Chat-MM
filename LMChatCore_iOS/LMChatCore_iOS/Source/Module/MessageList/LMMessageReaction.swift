//
//  LMMessageReaction.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 04/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMMessageReaction: LMView {
    
    public struct ContentModel {
        public let reaction: String
        public let reactionCount: String
    }
    /// The `UIImageView` instance that shows the avatar image.
    /// Container holding all previews.
    open private(set) lazy var previewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 4
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        return view
    }()
    
    open private(set) lazy var emojiLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    open private(set) lazy var countLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = Appearance.shared.fonts.subHeadingFont1
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        return label
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.white
        cornerRadius(with: 14)
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
    
    func setData(_ data: ContentModel) {
        emojiLabel.text = data.reaction
        countLabel.text = data.reactionCount
    }
}
