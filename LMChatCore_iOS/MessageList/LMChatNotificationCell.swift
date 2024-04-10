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
    
    open private(set) lazy var infoLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = Appearance.shared.colors.white
        label.text = ""
        label.setPadding(with: .init(top: 4, left: 8, bottom: 4, right: 8))
        label.cornerRadius(with: 12)
        label.backgroundColor = Appearance.shared.colors.notificationBackgroundColor
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
            infoLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
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
    open func configure(with data: ContentModel) {
        infoLabel.text = data.message?.message
    }
    
    func timestampConverted(createdAtInEpoch: Int) -> String? {
        guard createdAtInEpoch > .zero else { return nil }
        var epochTime = Double(createdAtInEpoch)
        
        if epochTime > Date().timeIntervalSince1970 {
            epochTime = epochTime / 1000
        }
        
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            return dateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter.string(from: date)
        }
    }
}

