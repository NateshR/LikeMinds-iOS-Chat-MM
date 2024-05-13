//
//  LMChatMessageCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 22/03/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS
import LikeMindsChat

public protocol LMChatMessageCellDelegate: AnyObject {
    func onClickReactionOfMessage(reaction: String, indexPath: IndexPath?)
    func onClickAttachmentOfMessage(url: String, indexPath: IndexPath?)
    func onClickGalleryOfMessage(attachmentIndex: Int, indexPath: IndexPath?)
    func onClickReplyOfMessage(indexPath: IndexPath?)
    func didTappedOnSelectionButton(indexPath: IndexPath?)
}

@IBDesignable
open class LMChatMessageCell: LMTableViewCell {
    
    public struct ContentModel {
        public let message: LMMessageListView.ContentModel.Message?
        public var isSelected: Bool = false
    }
    
    // MARK: UI Elements
    open internal(set) lazy var chatMessageView: LMChatMessageContentView = {
        let view = LMCoreComponents.shared.messageContentView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()

    open private(set) lazy var selectedButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.addTarget(self, action: #selector(selectedRowButton), for: .touchUpInside)
        button.isHidden = true
        button.backgroundColor = Appearance.shared.colors.clear
        return button
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        chatMessageView.prepareToResuse()
    }
    weak var delegate: LMChatMessageCellDelegate?
    var currentIndexPath: IndexPath?
    var originalCenter = CGPoint()
    var replyActionHandler: (() -> Void)?
    
    @objc func selectedRowButton(_ sender: UIButton) {
        let isSelected = !sender.isSelected
        sender.backgroundColor = isSelected ? Appearance.shared.colors.linkColor.withAlphaComponent(0.4) : Appearance.shared.colors.clear
        sender.isSelected = isSelected
        delegate?.didTappedOnSelectionButton(indexPath: currentIndexPath)
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        contentView.addSubview(containerView)
        containerView.addSubview(chatMessageView)
        contentView.addSubview(selectedButton)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            chatMessageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            chatMessageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            chatMessageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            chatMessageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        contentView.pinSubView(subView: selectedButton)
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
        chatMessageView.backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.clear
    }
    
    
    // MARK: configure
    open func setData(with data: ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        chatMessageView.setDataView(data, delegate: delegate, index: index)
        updateSelection(data: data)
        chatMessageView.clickedOnReaction = {[weak self] reaction in
            self?.delegate?.onClickReactionOfMessage(reaction: reaction, indexPath: self?.currentIndexPath)
        }
        chatMessageView.replyMessageView.onClickReplyPreview = { [weak self] in
            self?.delegate?.onClickReplyOfMessage(indexPath: self?.currentIndexPath)
        }
        chatMessageView.layoutIfNeeded()
    }
    
    func updateSelection(data: ContentModel) {
        let isSelected = data.isSelected
        selectedButton.backgroundColor = isSelected ? Appearance.shared.colors.linkColor.withAlphaComponent(0.4) : Appearance.shared.colors.clear
        selectedButton.isSelected = isSelected
    }
}

