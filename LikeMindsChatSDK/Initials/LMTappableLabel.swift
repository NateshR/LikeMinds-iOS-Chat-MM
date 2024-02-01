//
//  LMTappableLabel.swift
//  LMFramework
//
//  Created by Devansh Mohata on 04/12/23.
//

import UIKit

protocol LMTappableLabelDelegate: AnyObject {
    func didTapOnLink(_ link: LMTappableLabel.LabelLink, in tappableLabel: LMTappableLabel)
}

public class LMTappableLabel: LMLabel {
    public typealias LabelLink = (text: String, link: String?)
    
    weak var delegate: LMTappableLabelDelegate?
            
    @objc
    private func tappedLabel(_ tap: UITapGestureRecognizer) {
        guard let label = tap.view as? LMTappableLabel,
              label == self,
              tap.state == .ended else {
            return
        }
        let location = tap.location(in: label)
        processInteraction(at: location, wasTap: true)
    }
    
    private func processInteraction(at location: CGPoint, wasTap: Bool) {
        let label = self
        
        guard let attributedText = label.attributedText else {
            return
        }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let textContainer = NSTextContainer(size: label.bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        
        
        let characterIndex = layoutManager.characterIndex(for: location,
                                                          in: textContainer,
                                                          fractionOfDistanceBetweenInsertionPoints: nil)
        if characterIndex < textStorage.length,
           let labelLink = attributedText.attribute(.hyperlink, at: characterIndex, effectiveRange: nil) as? LabelLink {
                self.delegate?.didTapOnLink(labelLink, in: self)
        }
    }
    
    /*:
     - Note:
     Use this method when you want to add Tappable Links in the Label text. Using the existing `.text` or `.attributedText` won't set the Tappable Link behaviour.
     */
    func setText(_ text: String, withCallbacksOn callbackStrings: [LabelLink] = [], textColor: UIColor = .black, textFont: UIFont = .systemFont(ofSize: 16), linkTextColor: UIColor = .blue) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedLabel))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
        self.text = text
        
        let attributedString = NSMutableAttributedString(string: text)
        
        let coreAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : textColor,
            .font: textFont
        ]
        
        attributedString.setAttributes(coreAttributes, range: NSRange(location: 0, length: text.count))
        
        callbackStrings.forEach { LabelLink in
            let ranges = findAllOccurrences(of: LabelLink.text, in: text)
            ranges.forEach { range in
                var additionalAttributes = coreAttributes
                additionalAttributes[.hyperlink] = LabelLink
                additionalAttributes[.foregroundColor] = linkTextColor
                attributedString.setAttributes(additionalAttributes, range: NSRange(range, in: text))
            }
        }
        
        self.attributedText = attributedString
    }
    
    func findAllOccurrences(of substring: String, in text: String) -> [Range<String.Index>] {
        var occurrences: [Range<String.Index>] = []
        var startIndex = text.startIndex
        
        while let range = text.range(of: substring, range: startIndex ..< text.endIndex) {
            occurrences.append(range)
            startIndex = range.upperBound
        }
        
        return occurrences
    }
}
