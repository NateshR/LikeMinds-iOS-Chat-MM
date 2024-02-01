//
//  Constants+Images.swift
//  LMFramework
//
//  Created by Devansh Mohata on 12/12/23.
//

import UIKit

extension UIImage {
    convenience init?(named name: String, in bundle: Bundle) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}

public extension Constants {
    struct Images {
        private init() { }
        
        // Shared Instance
        public static var shared = Images()
        
        // Variables
        public var likeIcon = UIImage(systemName: "heart")
        public var commentIcon = UIImage(systemName: "message")
        public var saveIcon = UIImage(systemName: "bookmark")
        public var shareIcon = UIImage(systemName: "arrowshape.turn.up.right")
    }
}
