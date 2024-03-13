//
//  UIImage+Extension.swift
//  likeminds-feed-iOS
//
//  Created by Devansh Mohata on 22/12/23.
//

import UIKit

extension UIImage {
    static let circleImage: UIImage = {
        let size: CGSize = CGSize(width: 24, height: 24)
        let renderer = UIGraphicsImageRenderer(size: size)
        let circleImage = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        return circleImage
    }()
    
    public func withSystemImageConfig(pointSize: CGFloat, weight: UIImage.SymbolWeight = .light, scale: UIImage.SymbolScale = .medium) -> UIImage? {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
        let image = self.applyingSymbolConfiguration(largeConfig)
        return image
    }
}
