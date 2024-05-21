//
//  String+Extension.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 11/04/24.
//

import Foundation

extension String {
    var detectedLinks: [String] { DataDetector.find(all: .link, in: self) }
    var detectedFirstLink: String? { DataDetector.first(type: .link, in: self) }
    
}


