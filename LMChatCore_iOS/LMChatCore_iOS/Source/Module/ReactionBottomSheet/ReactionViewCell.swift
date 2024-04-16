//
//  ReactionViewCell.swift
//  SampleApp
//
//  Created by Devansh Mohata on 14/04/24.
//

import UIKit

class ReactionViewCell: UITableViewCell {
    struct ContentModel {
        let image: String?
        let username: String
        let isSelfReaction: Bool
        let reaction: String
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var userImageView: UIImageView = {
        let imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.image = UIImage(systemName: "mic.fill")
        return imageV
    }()
    
    lazy var userStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalSpacing
        stack.spacing = 4
        return stack
    }()
    
    lazy var userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Devansh"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var removeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tap To Remove"
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    lazy var reactionImage: UILabel = {
        let image = UILabel()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupLayouts()
    }
    
    func setupViews() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(userImageView)
        containerView.addSubview(userStackView)
        containerView.addSubview(reactionImage)
        
        userStackView.addArrangedSubview(userName)
        userStackView.addArrangedSubview(removeLabel)
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            userImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            userStackView.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 16),
            userStackView.topAnchor.constraint(greaterThanOrEqualTo: userImageView.topAnchor),
            userStackView.bottomAnchor.constraint(lessThanOrEqualTo: userImageView.bottomAnchor),
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
    }
}
