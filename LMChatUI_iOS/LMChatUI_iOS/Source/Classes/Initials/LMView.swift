//
//  LMView.swift
//  LMFramework
//
//  Created by Devansh Mohata on 24/11/23.
//

import UIKit

public extension UIView {
    
    func roundCorners(_ corners: CACornerMask, with cornerRadius: CGFloat) {
        clipsToBounds = true
        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
    
    func cornerRadius(with cornerRadius: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
    }
    
    func borderColor(withBorderWidth width: CGFloat, with color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
    func roundCornerWithShadow(cornerRadius: CGFloat, shadowRadius: CGFloat, offsetX: CGFloat, offsetY: CGFloat, colour: UIColor, opacity: Float, corners: CACornerMask = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]) {
        self.clipsToBounds = false
        
        let layer = self.layer
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
        layer.shadowOffset = CGSize(width: offsetX, height: offsetY);
        layer.shadowColor = colour.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        
        let bColour = self.backgroundColor
        self.backgroundColor = nil
        layer.backgroundColor = bColour?.cgColor
    }
    
    func pinSubView(subView: UIView, padding: UIEdgeInsets = .zero) {
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: padding.right),
            subView.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            subView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: padding.bottom)
        ])
    }
    
    func addSubviewWithDefaultConstraints(_ subView: UIView) {
        addSubview(subView)
        pinSubView(subView: subView)
    }
    
    func addConstraint(top: (anchor: NSLayoutYAxisAnchor, padding: CGFloat)? = nil,
                       bottom: (anchor: NSLayoutYAxisAnchor, padding: CGFloat)? = nil,
                       leading: (anchor: NSLayoutXAxisAnchor, padding: CGFloat)? = nil,
                       trailing: (anchor: NSLayoutXAxisAnchor, padding: CGFloat)? = nil,
                       centerX: (anchor: NSLayoutXAxisAnchor, padding: CGFloat)? = nil,
                       centerY: (anchor: NSLayoutYAxisAnchor, padding: CGFloat)? = nil) {
        if let top {
            topAnchor.constraint(equalTo: top.anchor, constant: top.padding).isActive = true
        }
        
        if let bottom {
            bottomAnchor.constraint(equalTo: bottom.anchor, constant: bottom.padding).isActive = true
        }
        
        if let leading {
            leadingAnchor.constraint(equalTo: leading.anchor, constant: leading.padding).isActive = true
        }
        
        if let trailing {
            trailingAnchor.constraint(equalTo: trailing.anchor, constant: trailing.padding).isActive = true
        }
        
        if let centerX {
            centerXAnchor.constraint(equalTo: centerX.anchor, constant: centerX.padding).isActive = true
        }
        
        if let centerY {
            centerYAnchor.constraint(equalTo: centerY.anchor, constant: centerY.padding).isActive = true
        }
    }
    
    @discardableResult
    func setHeightConstraint(with value: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        
        return heightConstraint
    }
    
    @discardableResult
    func setWidthConstraint(with value: CGFloat, relatedBy: NSLayoutConstraint.Relation = .equal, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        let widthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: relatedBy, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: value)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        
        return widthConstraint
    }
    
    @discardableResult
    func setHeightConstraint(
        with anchor: NSLayoutDimension,
        relatedBy: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required,
        multiplier: CGFloat = 1,
        constant: CGFloat = .zero
    ) -> NSLayoutConstraint {
        switch relatedBy {
        case .lessThanOrEqual:
            let height = self.heightAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            height.priority = priority
            height.isActive = true
            return height
        case .greaterThanOrEqual:
            let height = self.heightAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            height.priority = priority
            height.isActive = true
            return height
        default:
            let height = self.heightAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            height.priority = priority
            height.isActive = true
            return height
        }
    }
    
    @discardableResult
    func setWidthConstraint(
        with anchor: NSLayoutDimension,
        relatedBy: NSLayoutConstraint.Relation = .equal,
        priority: UILayoutPriority = .required,
        multiplier: CGFloat = 1,
        constant: CGFloat = .zero
    ) -> NSLayoutConstraint {
        switch relatedBy {
        case .lessThanOrEqual:
            let width = self.widthAnchor.constraint(lessThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            width.priority = priority
            width.isActive = true
            return width
        case .greaterThanOrEqual:
            let width = self.widthAnchor.constraint(greaterThanOrEqualTo: anchor, multiplier: multiplier, constant: constant)
            width.priority = priority
            width.isActive = true
            return width
        default:
            let width = self.widthAnchor.constraint(equalTo: anchor, multiplier: multiplier, constant: constant)
            width.priority = priority
            width.isActive = true
            return width
        }
    }
}

@IBDesignable
open class LMView: UIView {
    
    public static var heightOfScreen: CGFloat { UIScreen.main.bounds.height }
    public static var widthOfScreen: CGFloat { UIScreen.main.bounds.width }
    
    public let heightViewSize = widthOfScreen * 0.55
    public let widthViewSize = widthOfScreen * 0.65
    
    public static var minSizeOfScreen: CGFloat {
         min(heightOfScreen, widthOfScreen)
    }
    
    /// Initializes `UIView` and set up subviews, auto layouts and actions.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupViews()
        self.setupLayouts()
        self.setupActions()
        self.setupObservers()
    }
    
    @available(*, unavailable, renamed: "init(frame:)")
    public required init?(coder: NSCoder) {
        fatalError("\(#function) not implemented in \(#filePath)")
    }
    
    /// Lays out subviews and set up styles.
    open override func layoutSubviews() {
        super.layoutSubviews()
        setupAppearance()
    }
    
    public func translatesAutoresizingMaskIntoConstraints() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = 1.8
        self.layer.shadowOpacity = 0.3
    }
}

// MARK: LMViewLifeCycle
// Default Implementation is empty
extension LMView: LMViewLifeCycle {
    open func setupObservers() { }
    
    open func setupViews() { }
    
    open func setupLayouts() { }
    
    open func setupAppearance() { }
    
    open func setupActions() { }
    
}
