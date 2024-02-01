//
//  Appearance+Fonts.swift
//  LMFramework
//
//  Created by Devansh Mohata on 07/12/23.
//

import UIKit

public extension LMTheme {
    struct Colors {
        private init() { }
        
        // Shared Instance
        public static var shared = Colors()
        
        // Custom Colors
        public var gray1: UIColor = .init(red: 34 / 255, green: 32 / 255, blue: 32 / 255, alpha: 1)
        public var gray2: UIColor = .init(red: 80 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1)
        public var gray3: UIColor = .init(red: 15 / 255, green: 30 / 255, blue: 61 / 255, alpha: 0.4)
        public var textColor: UIColor = .init(red: 102 / 255, green: 102 / 255, blue: 102 / 255, alpha: 1)
        public var backgroundColor: UIColor = .init(red: 209 / 255, green: 216 / 255, blue: 225 / 255, alpha: 1)
        public var navigationTitleColor: UIColor = .init(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1)
        public var navigationBackgroundColor: UIColor = .init(red: 249 / 255, green: 249 / 255, blue: 249 / 255, alpha: 0.94)
        
        // UIKit Colors
        public var appTintColor: UIColor = .purple
        public var white: UIColor = .white
        public var black: UIColor = .black
        public var clear: UIColor = .clear
    }
}
