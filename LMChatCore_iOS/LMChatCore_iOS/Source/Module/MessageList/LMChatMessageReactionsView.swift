//
//  LMChatMessageReactionsView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 03/04/24.
//

import Foundation
import LMChatUI_iOS

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
        return view
    }()
    
    open var clickedOnReaction: ((String) -> Void)?
    
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
    
    func createEmojiView() -> LMMessageReaction {
        let view = LMMessageReaction().translatesAutoresizingMaskIntoConstraints()
        return view
    }
    
    func setData(_ data: [LMMessageListView.ContentModel.Reaction]) {
        previewsContainerView.arrangedSubviews.forEach({$0.isHidden = true})
        for (index, item) in data.enumerated() {
            if index > 1 { return }
            let preview = (previewsContainerView.arrangedSubviews[index] as? LMMessageReaction)
            preview?.setData(.init(reaction: item.reaction, reactionCount: "\(item.count)"))
            preview?.clickedOnReaction = {[weak self] in
                self?.clickedOnReaction?(item.reaction)
            }
            previewsContainerView.arrangedSubviews[index].isHidden = false
        }
    }
}
