//
//  LMChatNotificationCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 09/04/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat

@IBDesignable
open class LMChatNotificationCell: LMTableViewCell {
    
    public struct ContentModel {
        public let message: LMMessageListView.ContentModel.Message?
    }
    
//    open private(set) lazy var infoLabel: LMLabel = {
//        let label =  LMLabel()
//            .translatesAutoresizingMaskIntoConstraints()
//        label.numberOfLines = 3
//        label.textAlignment = .center
//        label.font = Appearance.shared.fonts.subHeadingFont2
//        label.textColor = Appearance.shared.colors.white
//        label.text = ""
//        label.setPadding(with: .init(top: 4, left: 8, bottom: 4, right: 8))
//        label.cornerRadius(with: 12)
//        label.backgroundColor = Appearance.shared.colors.notificationBackgroundColor
//        return label
//    }()
    
    open private(set) lazy var infoLabel: LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
        label.isScrollEnabled = false
        label.font = Appearance.shared.fonts.subHeadingFont2
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
            
            infoLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            infoLabel.leadingAnchor.constraint(greaterThanOrEqualTo: containerView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            infoLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
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
        infoLabel.attributedText =  GetAttributedTextWithRoutes.getAttributedText(from: (data.message?.message ?? "").trimmingCharacters(in: .whitespacesAndNewlines), font: Appearance.shared.fonts.subHeadingFont2, withHighlightedColor: Appearance.shared.colors.white, withTextColor: Appearance.shared.colors.white)
    }
}

