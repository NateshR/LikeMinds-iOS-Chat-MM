//
//  SearchGroupCell.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 15/04/24.
//

import LMChatUI_iOS
import Kingfisher
import UIKit

public protocol SearchCellProtocol { 
    var chatroomID: String { get }
    var messageID: String? { get }
}


public class SearchGroupCell: LMTableViewCell {
    public struct ContentModel: SearchCellProtocol {
        public var chatroomID: String
        public var messageID: String?
        public let image: String?
        public let chatroomName: String
        
        
        public init(chatroomID: String, image: String?, chatroomName: String) {
            self.chatroomID = chatroomID
            self.messageID = nil
            self.image = image
            self.chatroomName = chatroomName
        }
    }
    
    lazy var groupIcon: LMImageView = {
        let imageView = LMImageView().translatesAutoresizingMaskIntoConstraints()
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Trial Text"
        return label
    }()
    
    lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .lightGray
        return view
    }()
    
    
    open override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(groupIcon)
        containerView.addSubview(titleLabel)
        containerView.addSubview(sepratorView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        containerView.addConstraint(top: (contentView.topAnchor, 0),
                                    leading: (contentView.leadingAnchor, 0),
                                    trailing: (contentView.trailingAnchor, 0))
        
        containerView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor).isActive = true
        
        groupIcon.addConstraint(top: (containerView.topAnchor, 16),
                                leading: (containerView.leadingAnchor, 8))
        groupIcon.setHeightConstraint(with: 64)
        groupIcon.setWidthConstraint(with: groupIcon.heightAnchor)
        
        titleLabel.addConstraint(leading: (groupIcon.trailingAnchor, 8),
                                 trailing: (containerView.trailingAnchor, -8),
                                 centerY: (containerView.centerYAnchor, 0))
        
        sepratorView.addConstraint(top: (groupIcon.bottomAnchor, 8),
                                   bottom: (containerView.bottomAnchor, -4),
                                   leading: (titleLabel.leadingAnchor, 0),
                                   trailing: (containerView.trailingAnchor, 0))
        sepratorView.setHeightConstraint(with: 1)
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        
        sepratorView.isHidden = true
        groupIcon.layer.cornerRadius = 32
    }
    
    open func configure(with data: ContentModel) {
        // TODO: set placeholder image
        groupIcon.kf.setImage(with: URL(string: data.image ?? ""), placeholder: nil)
        titleLabel.text = data.chatroomName
    }
}
