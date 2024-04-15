//
//  LMChatMessageBubbleView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 27/03/24.
//

import Foundation
import LMChatUI_iOS

/// A view that displays a bubble around a message.
open class LMChatMessageBubbleView: LMView {
    
    var isIncoming = true
    
    let receivedBubble = UIImage(named: "bubble_received", in: LMChatCoreBundle, with: nil)?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch)
        .withRenderingMode(.alwaysTemplate)
    
    let sentBubble = UIImage(named: "bubble_sent", in: LMChatCoreBundle, with: nil)?.resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21), resizingMode: .stretch)
        .withRenderingMode(.alwaysTemplate)
    
    var incomingColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var outgoingColor = UIColor(red: 0.88, green: 0.99, blue: 0.98, alpha: 1)
    var containerViewLeadingConstraint: NSLayoutConstraint?
    var containerViewTrailingConstraint: NSLayoutConstraint?
    
    open private(set) lazy var contentContainer: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 2
        view.backgroundColor = Appearance.shared.colors.clear
        return view
    }()
    
    open private(set) var imageView: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
//        image.clipsToBounds = true
        image.backgroundColor = Appearance.shared.colors.clear
        return image
    }()
    
    /// A type describing the content of this view.
    public struct ContentModel {
        /// The background color of the bubble.
        public let backgroundColor: UIColor
        /// The mask saying which corners should be rounded.
        public let roundedCorners: CACornerMask
        
        public init(backgroundColor: UIColor, roundedCorners: CACornerMask) {
            self.backgroundColor = backgroundColor
            self.roundedCorners = roundedCorners
        }
    }
    
    /// The content this view is rendered based on.
    open var content: ContentModel? {
        didSet { updateContentData() }
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        
//        layer.borderColor = Appearance.Colors.shared.gray4.cgColor//appearance.colorPalette.border3.cgColor
//        layer.cornerRadius = 18
//        layer.borderWidth = 1
        backgroundColor = Appearance.shared.colors.clear
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addContentContainerView()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
    }
    
    func updateContentData() {
//        layer.maskedCorners = content?.roundedCorners ?? []
//        backgroundColor = content?.backgroundColor ?? .clear
    }
    
    private func addContentContainerView() {
        addSubview(imageView)
        addSubview(contentContainer)
        let leading: CGFloat = isIncoming ? 4 : 8
        let trailing: CGFloat = isIncoming ? 8 : 4
        containerViewLeadingConstraint = contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading)
        containerViewTrailingConstraint = contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -trailing)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
        containerViewLeadingConstraint?.isActive = true
        containerViewTrailingConstraint?.isActive = true
    }
    
    open func addArrangeSubview(_ view: UIView) {
//        let leading: CGFloat = isIncoming ? 4 : 8
//        let trailing: CGFloat = isIncoming ? 8 : 4
//        
//        containerViewLeadingConstraint?.constant = leading
//        containerViewTrailingConstraint?.constant = -trailing
        
        contentContainer.addArrangedSubview(view)
    }
    
    func bubbleFor(_ isInComing: Bool) {
        self.isIncoming = isInComing
        containerViewLeadingConstraint?.isActive = false
        containerViewTrailingConstraint?.isActive = false
        if isInComing {
            imageView.image = receivedBubble
            imageView.tintColor = incomingColor
            containerViewLeadingConstraint?.constant = 8
            containerViewTrailingConstraint?.constant = -2
        } else {
            imageView.image = sentBubble
            imageView.tintColor = outgoingColor
            containerViewLeadingConstraint?.constant = 2
            containerViewTrailingConstraint?.constant = -8
        }
        containerViewLeadingConstraint?.isActive = true
        containerViewTrailingConstraint?.isActive = true
    }
    
}
