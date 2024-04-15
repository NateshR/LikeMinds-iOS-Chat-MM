//
//  RegexPattern.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/04/24.
//

import Foundation

public enum Regex: String {
    
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    case number = "^[0-9]+$"
    case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
    
    var pattern: String {
        return rawValue
    }
}
