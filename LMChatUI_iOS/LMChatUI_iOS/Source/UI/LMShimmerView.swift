//
//  LMShimmerView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 30/04/24.
//

import UIKit

@IBDesignable
open class LMChatShimmerView: LMView {
    private let gradientLayer = CAGradientLayer()
    private var gradientColorOne = UIColor(white: 0.85, alpha: 1.0).cgColor
    private var gradientColorTwo = UIColor(white: 0.95, alpha: 1.0).cgColor
    
    open override func setupViews() {
        super.setupViews()
        
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.locations = [0.0, 0.5, 1.0]
        layer.addSublayer(gradientLayer)
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        
        gradientLayer.frame = self.bounds
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
}
