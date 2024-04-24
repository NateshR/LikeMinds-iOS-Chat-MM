//
//  LMReactionViewCell.swift
//  SampleApp
//
//  Created by Devansh Mohata on 14/04/24.
//

import UIKit
import LMChatUI_iOS

open class LMReactionViewCell: LMTableViewCell {
    struct ContentModel {
        let image: String?
        let username: String
        let isSelfReaction: Bool
        let reaction: String
    }
    
    lazy var userImageView: LMImageView = {
        let imageV = LMImageView().translatesAutoresizingMaskIntoConstraints()
        imageV.image = Constants.shared.images.placeholderImage
        imageV.setWidthConstraint(with: 34)
        imageV.setHeightConstraint(with: 34)
        imageV.cornerRadius(with: 17)
        return imageV
    }()
    
    lazy var userStackView: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 8
        return stack
    }()
    
    lazy var userName: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var removeLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Tap To Remove"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    lazy var reactionImage: LMLabel = {
        let image = LMLabel().translatesAutoresizingMaskIntoConstraints()
        return image
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupLayouts()
    }
    
    open override func setupViews() {
        super.setupViews()
        contentView.addSubview(containerView)
        
        containerView.addSubview(userImageView)
        containerView.addSubview(userStackView)
        containerView.addSubview(reactionImage)
        
        userStackView.addArrangedSubview(userName)
        userStackView.addArrangedSubview(removeLabel)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            userImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            userStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userStackView.topAnchor.constraint(equalTo: userImageView.topAnchor),
            userStackView.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userStackView.trailingAnchor.constraint(lessThanOrEqualTo: reactionImage.leadingAnchor, constant: 8),
            
            reactionImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            reactionImage.topAnchor.constraint(equalTo: userStackView.topAnchor, constant: 4),
            reactionImage.bottomAnchor.constraint(equalTo: userStackView.bottomAnchor, constant: -4),
        ])
    }
    
    func configure(with data: ContentModel) {
        userName.text = data.username
        removeLabel.isHidden = !data.isSelfReaction
        reactionImage.text = data.reaction
        userImageView.kf.setImage(with: URL(string: data.image ?? ""), placeholder: Constants.shared.images.placeholderImage)
    }
}
