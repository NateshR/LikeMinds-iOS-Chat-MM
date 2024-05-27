//
//  LMChatMessageReaction.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 04/04/24.
//

import Foundation

public protocol LMChatMessageReactionDelegate: AnyObject {
    func clickedOnReaction(_ reaction: String)
}

open class LMChatMessageReaction: LMView {
    
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
        label.text = nil
        return label
    }()
    
    open private(set) var moreImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.image = Constants.shared.images.ellipsisIcon
        image.tintColor = Appearance.shared.colors.previewSubtitleTextColor
        return image
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
    
    weak var delegate: LMChatMessageReactionDelegate?
    
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
        previewsContainerView.addArrangedSubview(moreImageView)
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(reactionTapped))
        tapGuesture.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGuesture)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: previewsContainerView)
    }
    
    func setData(_ data: ContentModel) {
        emojiLabel.text = data.reaction
        countLabel.text = data.reactionCount
        moreImageView.isHidden = true
    }
    
    func setMoreData() {
        emojiLabel.isHidden = true
        countLabel.isHidden = true
        moreImageView.isHidden = false
    }
    
    @objc func reactionTapped(_ guesture: UITapGestureRecognizer) {
        guard let reaction = emojiLabel.text else {
            delegate?.clickedOnReaction("")
            return
        }
        delegate?.clickedOnReaction(reaction)
    }
}
