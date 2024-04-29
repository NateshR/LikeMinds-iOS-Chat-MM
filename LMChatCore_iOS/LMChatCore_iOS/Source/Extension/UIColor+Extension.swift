//
//  UIColor+Extension.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 24/04/24.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex: UInt, alpha: CGFloat) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
}
