//
//  String+Extension.swift
//  likeminds-feed-iOS
//
//  Created by Devansh Mohata on 21/12/23.
//

import Foundation

public extension String {
    func sizeOfString(with font: UIFont = .systemFont(ofSize: 16)) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = (self as NSString).size(withAttributes: fontAttributes)
        return size
    }
    
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

public enum Regex: String {
    
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    case number = "^[0-9]+$"
    case password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
    
    var pattern: String {
        return rawValue
    }
}
