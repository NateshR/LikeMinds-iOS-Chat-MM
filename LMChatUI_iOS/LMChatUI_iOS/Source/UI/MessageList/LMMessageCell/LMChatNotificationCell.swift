//
//  LMChatNotificationCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 09/04/24.
//

import Foundation

@IBDesignable
open class LMChatNotificationCell: LMTableViewCell {
    
    public struct ContentModel {
        public let message: LMChatMessageListView.ContentModel.Message?
        public let loggedInUserTag: String
        public let loggedInUserReplaceTag: String
    }

    open private(set) lazy var infoLabel: LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
        label.isScrollEnabled = false
        label.font = Appearance.shared.fonts.textFont1
        label.backgroundColor = Appearance.shared.colors.notificationBackgroundColor
        label.textColor = Appearance.shared.colors.white
        label.textAlignment = .center
        label.textContainer.maximumNumberOfLines = 2
        label.textContainer.lineBreakMode = .byTruncatingTail
        label.isEditable = false
        label.tintColor = Appearance.shared.colors.white
        label.textContainerInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        label.cornerRadius(with: 12)
        label.text = ""
        return label
    }()
    
    open var infoLabelTextFont: UIFont = Appearance.shared.fonts.textFont1
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        contentView.addSubview(containerView)
        containerView.addSubview(infoLabel)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 6),
            infoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            infoLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -6)
        ])
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.backgroundColor
    }
    
    
    // MARK: configure
    open func setData(with data: ContentModel) {
        let message = (data.message?.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: data.loggedInUserTag, with: data.loggedInUserReplaceTag)
        infoLabel.attributedText =  GetAttributedTextWithRoutes.getAttributedText(from: message, font: infoLabelTextFont, withHighlightedColor: Appearance.shared.colors.white, withTextColor: Appearance.shared.colors.white)
        self.layoutIfNeeded()
    }
}

