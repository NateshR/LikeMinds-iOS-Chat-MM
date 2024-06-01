//
//  LMChatReactionPopupView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 15/04/24.
//

import Foundation

open class LMChatReactionPopupView: LMView {
    
    enum ReactionType: String {
        case heart = "❤️"
        case laugh = "😂"
        case surprise = "😲"
        case sad = "😢"
        case angry = "😡"
        case like = "👍"
        case more = "more"
    }
    
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
    
    open private(set) lazy var heartButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.setFont(Appearance.shared.fonts.emojiTrayFont)
        button.setTitle(ReactionType.heart.rawValue, for: .normal)
        button.addTarget(self, action: #selector(emojiSelected), for: .touchUpInside)
        button.setWidthConstraint(with: 40)
        button.setHeightConstraint(with: 40)
        return button
    }()
    
    open private(set) lazy var likeButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.setFont(Appearance.shared.fonts.emojiTrayFont)
        button.setTitle(ReactionType.like.rawValue, for: .normal)
        button.addTarget(self, action: #selector(emojiSelected), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var sadButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.setFont(Appearance.shared.fonts.emojiTrayFont)
        button.setTitle(ReactionType.sad.rawValue, for: .normal)
        button.addTarget(self, action: #selector(emojiSelected), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var surpriseButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.setFont(Appearance.shared.fonts.emojiTrayFont)
        button.setTitle(ReactionType.surprise.rawValue, for: .normal)
        button.addTarget(self, action: #selector(emojiSelected), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var angryButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.setFont(Appearance.shared.fonts.emojiTrayFont)
        button.setTitle(ReactionType.angry.rawValue, for: .normal)
        button.addTarget(self, action: #selector(emojiSelected), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var laughButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.setFont(Appearance.shared.fonts.emojiTrayFont)
        button.setTitle(ReactionType.laugh.rawValue, for: .normal)
        button.addTarget(self, action: #selector(emojiSelected), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var moreButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.setFont(Appearance.shared.fonts.emojiTrayFont)
        button.setTitleColor(.black, for: .normal)
        button.setBackgroundImage(Constants.shared.images.addMoreEmojiIcon, for: .normal)
        button.addTarget(self, action: #selector(moreEmojiSelected), for: .touchUpInside)
        button.setWidthConstraint(with: 40)
        button.setHeightConstraint(with: 44)
        return button
    }()
    
    var onReaction: ((ReactionType) -> Void)?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        cornerRadius(with: 12)
        backgroundColor = .white
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(previewsContainerView)
        previewsContainerView.addArrangedSubview(heartButton)
        previewsContainerView.addArrangedSubview(laughButton)
        previewsContainerView.addArrangedSubview(surpriseButton)
        previewsContainerView.addArrangedSubview(sadButton)
        previewsContainerView.addArrangedSubview(angryButton)
        previewsContainerView.addArrangedSubview(likeButton)
        previewsContainerView.addArrangedSubview(moreButton)
        doAnimation()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: previewsContainerView, padding: .init(top: 4, left: 8, bottom: -4, right: -8))
    }
    
    func doAnimation() {
//        let offset = CGPoint(x: UIScreen.main.bounds.width, y: 0)
//        self.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.transform = .identity
            self.alpha = 1
        },
                       completion: { [weak self] _ in
            guard let self = self else { return }
            self.previewsContainerView.arrangedSubviews.forEach { view in
                UIView.animate(withDuration: 0.5,
                               delay: 0.0,
                               options: .curveEaseIn,
                               animations: {
                    view.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.5, animations: {
                        view.transform = .identity
                    })
                })
            }
        })
        
    }
    
    @objc func emojiSelected(_ sender: UIButton) {
        onReaction?(ReactionType(rawValue:sender.titleLabel?.text ?? "NA") ?? .like)
    }
    
    @objc func moreEmojiSelected(_ sender: UIButton) {
        onReaction?(.more)
    }
}
