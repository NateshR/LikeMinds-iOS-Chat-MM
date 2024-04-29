//
//  LMReactionTitleCell.swift
//  SampleApp
//
//  Created by Devansh Mohata on 14/04/24.
//

import UIKit
import LMChatUI_iOS

open class LMReactionTitleCell: LMCollectionViewCell {
    struct ContentModel {
        let title: String
        let count: Int
        var isSelected: Bool = false
    }
 
    lazy var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        return label
    }()
    
    lazy var selectedView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .blue
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        containerView.addSubview(titleLabel)
        containerView.addSubview(selectedView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
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
