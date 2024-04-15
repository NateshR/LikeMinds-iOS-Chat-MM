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
    
    func getLinkWithHttps() -> String {
        if self.lowercased().hasPrefix("https://") || self.lowercased().hasPrefix("http://") {
            return self
        } else {
            return "https://" + self
        }
    }
    
    func isEmail() -> Bool {
        return match(Regex.email.pattern)
    }
    
    func isNumber() -> Bool {
        return match(Regex.number.pattern)
    }
    
    func isPassword() -> Bool {
        return match(Regex.password.pattern)
    }
    
    func isValidPhoneNumber() -> Bool {
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"
        
        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
    
    func match(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: count)) != nil
        } catch {
            return false
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}


