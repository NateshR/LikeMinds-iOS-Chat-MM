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
    
    var incomingColor = UIColor(red: 0.68, green: 0.72, blue: 0.8, alpha: 1)
    var outgoingColor = UIColor(red: 0.09, green: 0.54, blue: 1, alpha: 1)
    
    open private(set) lazy var contentContainer: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 2
        return view
    }()
    
    open override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let bezierPath = UIBezierPath()
        
        if isIncoming {
            bezierPath.move(to: CGPoint(x: 22, y: height))
            bezierPath.addLine(to: CGPoint(x: width - 17, y: height))
            bezierPath.addCurve(to: CGPoint(x: width, y: height - 17), controlPoint1: CGPoint(x: width - 7.61, y: height), controlPoint2: CGPoint(x: width, y: height - 7.61))
            bezierPath.addLine(to: CGPoint(x: width, y: 17))
            bezierPath.addCurve(to: CGPoint(x: width - 17, y: 0), controlPoint1: CGPoint(x: width, y: 7.61), controlPoint2: CGPoint(x: width - 7.61, y: 0))
            bezierPath.addLine(to: CGPoint(x: 21, y: 0))
            bezierPath.addCurve(to: CGPoint(x: 4, y: 17), controlPoint1: CGPoint(x: 11.61, y: 0), controlPoint2: CGPoint(x: 4, y: 7.61))
            bezierPath.addLine(to: CGPoint(x: 4, y: height - 11))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height), controlPoint1: CGPoint(x: 4, y: height - 1), controlPoint2: CGPoint(x: 0, y: height))
            bezierPath.addLine(to: CGPoint(x: -0.05, y: height - 0.01))
            bezierPath.addCurve(to: CGPoint(x: 11.04, y: height - 4.04), controlPoint1: CGPoint(x: 4.07, y: height + 0.43), controlPoint2: CGPoint(x: 8.16, y: height - 1.06))
            bezierPath.addCurve(to: CGPoint(x: 22, y: height), controlPoint1: CGPoint(x: 16, y: height), controlPoint2: CGPoint(x: 19, y: height))
            
            incomingColor.setFill()
            
        } else {
            bezierPath.move(to: CGPoint(x: width - 22, y: height))
            bezierPath.addLine(to: CGPoint(x: 17, y: height))
            bezierPath.addCurve(to: CGPoint(x: 0, y: height - 17), controlPoint1: CGPoint(x: 7.61, y: height), controlPoint2: CGPoint(x: 0, y: height - 7.61))
            bezierPath.addLine(to: CGPoint(x: 0, y: 17))
            bezierPath.addCurve(to: CGPoint(x: 17, y: 0), controlPoint1: CGPoint(x: 0, y: 7.61), controlPoint2: CGPoint(x: 7.61, y: 0))
            bezierPath.addLine(to: CGPoint(x: width - 21, y: 0))
            bezierPath.addCurve(to: CGPoint(x: width - 4, y: 17), controlPoint1: CGPoint(x: width - 11.61, y: 0), controlPoint2: CGPoint(x: width - 4, y: 7.61))
            bezierPath.addLine(to: CGPoint(x: width - 4, y: height - 11))
            bezierPath.addCurve(to: CGPoint(x: width, y: height), controlPoint1: CGPoint(x: width - 4, y: height - 1), controlPoint2: CGPoint(x: width, y: height))
            bezierPath.addLine(to: CGPoint(x: width + 0.05, y: height - 0.01))
            bezierPath.addCurve(to: CGPoint(x: width - 11.04, y: height - 4.04), controlPoint1: CGPoint(x: width - 4.07, y: height + 0.43), controlPoint2: CGPoint(x: width - 8.16, y: height - 1.06))
            bezierPath.addCurve(to: CGPoint(x: width - 22, y: height), controlPoint1: CGPoint(x: width - 16, y: height), controlPoint2: CGPoint(x: width - 19, y: height))
            
            outgoingColor.setFill()
        }
        
        bezierPath.close()
        bezierPath.fill()
    }
    
    
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
        backgroundColor = .white
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
        addSubview(contentContainer)
        let leading: CGFloat = isIncoming ? 15 : 10
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leading),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    open func addArrangeSubview(_ view: UIView) {
        contentContainer.addArrangedSubview(view)
    }
    
}
