//
//  LMChatMessageReactionsView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 03/04/24.
//

import Foundation

public protocol LMChatMessageReactionsViewDelegate: AnyObject {
    func clickedOnReaction(_ reaction: String)
}

open class LMChatMessageReactionsView: LMView {
    /// The `UIImageView` instance that shows the avatar image.
    /// Container holding all previews.
    open private(set) lazy var previewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.alignment = .center
        view.spacing = 2
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        view.setHeightConstraint(with: 34)
        return view
    }()
    
    weak var delegate: LMChatMessageReactionsViewDelegate?
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(previewsContainerView)
        previewsContainerView.addArrangedSubview(createEmojiView())
        previewsContainerView.addArrangedSubview(createEmojiView())
        previewsContainerView.addArrangedSubview(createEmojiView())
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: previewsContainerView)
    }
    
    func createEmojiView() -> LMChatMessageReaction {
        let view = LMChatMessageReaction().translatesAutoresizingMaskIntoConstraints()
        return view
    }
    
    func setData(_ data: [LMChatMessageListView.ContentModel.Reaction]) {
        previewsContainerView.arrangedSubviews.forEach({$0.isHidden = true})
        for (index, item) in data.enumerated() {
            if index > 1 {
                let preview = (previewsContainerView.arrangedSubviews[index] as? LMChatMessageReaction)
                preview?.setMoreData()
                preview?.delegate = self
                previewsContainerView.arrangedSubviews[index].isHidden = false
                return
            }
            let preview = (previewsContainerView.arrangedSubviews[index] as? LMChatMessageReaction)
            preview?.setData(.init(reaction: item.reaction, reactionCount: "\(item.count)"))
            preview?.delegate = self
            previewsContainerView.arrangedSubviews[index].isHidden = false
        }
    }
}

extension LMChatMessageReactionsView: LMChatMessageReactionDelegate {
    public func clickedOnReaction(_ reaction: String) {
        delegate?.clickedOnReaction(reaction)
    }
}
