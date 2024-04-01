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
        
        layer.borderColor = Appearance.Colors.shared.gray4.cgColor//appearance.colorPalette.border3.cgColor
        layer.cornerRadius = 18
        layer.borderWidth = 1
        backgroundColor = .clear
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
    }
    
    func updateContentData() {
        layer.maskedCorners = content?.roundedCorners ?? []
        backgroundColor = content?.backgroundColor ?? .clear
    }
}
