//
//  LMChatMessageLoading.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 01/05/24.
//

import Foundation

@IBDesignable
open class LMChatMessageLoading: LMView {
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    let receivedBubble = UIImage(named: "bubble_received", in: LMChatUIBundle, with: nil)?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch)
        .withRenderingMode(.alwaysTemplate)
    
    let sentBubble = UIImage(named: "bubble_sent", in: LMChatUIBundle, with: nil)?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch)
        .withRenderingMode(.alwaysTemplate)
    
    var incomingColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
    var outgoingColor = UIColor(red: 0.88, green: 0.99, blue: 0.98, alpha: 0.4)
    
    open private(set) lazy var outgoingImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.image = sentBubble
        image.tintColor = outgoingColor
        image.backgroundColor = Appearance.shared.colors.clear
//        image.setWidthConstraint(with: 150)
        image.setHeightConstraint(with: 40)
        return image
    }()
    
    open private(set) lazy var incomingImageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.image = receivedBubble
        image.backgroundColor = Appearance.shared.colors.clear
        image.tintColor = incomingColor
//        image.setWidthConstraint(with: 150)
        image.setHeightConstraint(with: 40)
        return image
    }()

    open private(set) lazy var profileMessageView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setWidthConstraint(with: 36)
        view.setHeightConstraint(with: 36)
        view.cornerRadius(with: 18)
        view.backgroundColor = Appearance.shared.colors.previewSubtitleTextColor
        return view
    }()
    
    open private(set) lazy var sentmessageTitleView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setHeightConstraint(with: 14)
        view.cornerRadius(with: 7)
        view.backgroundColor = Appearance.shared.colors.previewSubtitleTextColor
        return view
    }()
    
    open private(set) lazy var incomingMessageTitleView: LMChatShimmerView = {
        let view = LMUIComponents.shared.shimmerView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setHeightConstraint(with: 14)
        view.cornerRadius(with: 7)
        view.backgroundColor = Appearance.shared.colors.previewSubtitleTextColor
        return view
    }()
    
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(profileMessageView)
        containerView.addSubview(incomingImageView)
        containerView.addSubview(outgoingImageView)
        
        outgoingImageView.addSubview(sentmessageTitleView)
        incomingImageView.addSubview(incomingMessageTitleView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            profileMessageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            profileMessageView.bottomAnchor.constraint(equalTo: incomingImageView.bottomAnchor),
            
            incomingImageView.leadingAnchor.constraint(equalTo: profileMessageView.trailingAnchor),
            incomingImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -100),
            incomingImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            incomingMessageTitleView.leadingAnchor.constraint(equalTo: incomingImageView.leadingAnchor, constant: 16),
            incomingMessageTitleView.trailingAnchor.constraint(equalTo: incomingImageView.trailingAnchor, constant: -30),
            incomingMessageTitleView.topAnchor.constraint(equalTo: incomingImageView.topAnchor,constant: 12),
            
            outgoingImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 100),
            outgoingImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            outgoingImageView.topAnchor.constraint(equalTo: incomingImageView.bottomAnchor, constant: 20),
            outgoingImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            
            sentmessageTitleView.leadingAnchor.constraint(equalTo: outgoingImageView.leadingAnchor, constant: 30),
            sentmessageTitleView.trailingAnchor.constraint(equalTo: outgoingImageView.trailingAnchor, constant: -16),
            sentmessageTitleView.topAnchor.constraint(equalTo: outgoingImageView.topAnchor,constant: 12),
        ])
    }
}
