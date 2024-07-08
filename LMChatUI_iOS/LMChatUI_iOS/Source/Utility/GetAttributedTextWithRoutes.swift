//
//  GetAttributedTextWithRoutes.swift
//  LMFramework
//
//  Created by Devansh Mohata on 18/12/23.
//

import UIKit

// MARK: NameWithRoute
public struct NameWithRoute {
    var name: String
    var route: String
    
    func getIdFromRoute() -> String {
        self.route.components(separatedBy: "/").last ?? ""
    }
    
    public init(name: String, route: String) {
        self.name = name
        self.route = route
    }
}

// MARK: GetAttributedTextWithRoutes
public struct GetAttributedTextWithRoutes {
    public static func getAttributedText(from text: String,
                                  andPrefix: Character? = nil,
                                  allowLink: Bool = true,
                                  allowHashtags: Bool = true,
                                  font: UIFont = Appearance.shared.fonts.textFont1,
                                  withHighlightedColor: UIColor = Appearance.shared.colors.linkColor,
                                  withTextColor: UIColor = Appearance.shared.colors.textColor) -> NSMutableAttributedString {
        var attributedString = replaceRouteToName(with: text, andPrefix: andPrefix, font: font, withHighlightedColor: withHighlightedColor, withTextColor: withTextColor)
        
        if allowLink {
            attributedString = detectAndHighlightURLs(in: attributedString)
        }
        
        if allowHashtags {
            attributedString = detectAndHighlightHashtags(in: attributedString)
        }
        
        return attributedString
    }
    
    static func detectAndHighlightURLs(in attributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let text = attributedString.string
            let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            
            for match in matches {
                if let url = match.url,
                   !attributedString.containsAttribute(.route, in: match.range) {
                    let range = match.range
                    attributedString.addAttribute(.foregroundColor, value: Appearance.shared.colors.linkColor, range: range)
                    attributedString.addAttribute(.link, value: url, range: range)
                }
            }
        } catch {
            print("Error creating URL detector: \(error)")
        }
        
        return attributedString
    }
    
    static func detectAndHighlightHashtags(in attributedString: NSMutableAttributedString) -> NSMutableAttributedString {
        do {
            let detector = try NSRegularExpression(pattern: "#(\\w+)", options: [])
            let text = attributedString.string
            let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            
            for match in matches {
                if let range = Range(match.range(at: 1), in: text),
                   !attributedString.containsAttribute(.route, in: match.range),
                   !attributedString.containsAttribute(.link, in: match.range) {
                    let hashtag = String(text[range])
                    
                    attributedString.addAttribute(.hashtags, value: hashtag, range: match.range)
                    attributedString.addAttribute(.foregroundColor, value: Appearance.shared.colors.hashtagColor, range: match.range)
                }
            }
        } catch {
            print("Error creating URL detector: \(error)")
        }
        
        return attributedString
    }
    
    static func getUserNames(in answer: String) -> [NameWithRoute] {
        guard !answer.isEmpty else { return [] } // Handle nil case early
        
        let charSet = CharacterSet(charactersIn: "<<>>")
        
        let routeStringArray = answer.components(separatedBy: charSet)
            .filter { $0.contains("|") }
        
        let nameWithRoutes: [NameWithRoute] = routeStringArray.compactMap {
            let components = $0.split(separator: "|")
            guard components.count == 2 else { return nil }
            return NameWithRoute(name: String(components[0]), route: String(components[1]))
        }
        
        return nameWithRoutes
    }
    
    static func replaceRouteToName(
        with answer: String,
        andPrefix prefix: Character? = nil,
        font: UIFont,
        withHighlightedColor: UIColor,
        withTextColor: UIColor
    ) -> NSMutableAttributedString {
        let nameWithRoutes = getUserNames(in: answer)
        
        let attrString = NSMutableAttributedString(string: answer, attributes: [
            .foregroundColor: withTextColor,
            .font: font
        ])
        
        for nameWithRoute in nameWithRoutes {
            let routeString = "<<\(nameWithRoute.name.replacingOccurrences(of: "<<", with: ""))|\(nameWithRoute.route)>>"
            
            var replaceString = nameWithRoute.name
            
            if let prefix {
                replaceString = "\(prefix)\(replaceString)"
            }
            
            let replaceAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: withHighlightedColor,
                .font: font,
                .route: nameWithRoute.route
            ]
            
            let newAttributedString = NSAttributedString(string: replaceString, attributes: replaceAttributes)
            
            var range = (attrString.string as NSString).range(of: routeString)
            while range.location != NSNotFound {
                attrString.replaceCharacters(in: range, with: newAttributedString)
                range = (attrString.string as NSString).range(of: routeString)
            }
        }
        
        return attrString
    }
    
    static func detectAndHighlightText(
        in attributedString: NSMutableAttributedString,
        text: String,
        color: UIColor = .black,
        font: UIFont = Appearance.shared.fonts.headingFont1
    ) -> NSMutableAttributedString {
        let originalText = attributedString.string
        let range = NSRange(location: 0, length: originalText.count)
        let pattern = text
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches = regex.matches(in: originalText, range: range)
            
            for match in matches.reversed() {
                attributedString.addAttribute(.foregroundColor, value: color, range: match.range)
                attributedString.addAttribute(.font, value: font, range: match.range)
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
        
        return attributedString
    }
}
