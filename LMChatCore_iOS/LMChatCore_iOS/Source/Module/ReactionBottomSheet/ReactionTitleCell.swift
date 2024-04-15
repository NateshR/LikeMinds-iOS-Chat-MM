//
//  ReactionTitleCell.swift
//  SampleApp
//
//  Created by Devansh Mohata on 14/04/24.
//

import UIKit

class ReactionTitleCell: UICollectionViewCell {
    struct ContentModel {
        let title: String
        let count: Int
        let isSelected: Bool
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        containerView.addSubview(titleLabel)
        containerView.addSubview(selectedView)
    }
    
    func setupLayouts() {
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            titleLabel.bottomAnchor.constraint(equalTo: selectedView.topAnchor, constant: 4),
            
            selectedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            selectedView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            selectedView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            selectedView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(data: ContentModel) {
        titleLabel.text = "\(data.title) \(data.count)"
        selectedView.isHidden = !data.isSelected
    }
}
