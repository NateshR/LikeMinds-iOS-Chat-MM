//
//  LMChatMessageCell.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 22/03/24.
//

import Foundation
import Kingfisher

public protocol LMChatMessageCellDelegate: AnyObject {
    func onClickReactionOfMessage(reaction: String, indexPath: IndexPath?)
    func onClickAttachmentOfMessage(url: String, indexPath: IndexPath?)
    func onClickGalleryOfMessage(attachmentIndex: Int, indexPath: IndexPath?)
    func onClickReplyOfMessage(indexPath: IndexPath?)
    func didTappedOnSelectionButton(indexPath: IndexPath?)
    func onClickOfSeeMore(for messageID: String, indexPath: IndexPath)
    func didCancelAttachmentUploading(indexPath: IndexPath)
    func didRetryAttachmentUploading(indexPath: IndexPath)
    func didTapOnProfileLink(route: String)
}

@IBDesignable
open class LMChatMessageCell: LMTableViewCell {
    
    public struct ContentModel {
        public let message: LMChatMessageListView.ContentModel.Message?
        public var isSelected: Bool = false
    }
    
    // MARK: UI Elements
    open internal(set) lazy var chatMessageView: LMChatMessageContentView = {
        let view = LMUIComponents.shared.messageContentView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var retryContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 0
        view.addArrangedSubview(retryButton)
        return view
    }()
    
    open private(set) lazy var retryButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.addTarget(self, action: #selector(retrySendMessage), for: .touchUpInside)
        button.setImage(Constants.shared.images.retryIcon.withSystemImageConfig(pointSize: 25), for: .normal)
        button.backgroundColor = Appearance.shared.colors.clear
        button.tintColor = Appearance.shared.colors.red
        button.setWidthConstraint(with: 30)
        button.setHeightConstraint(with: 30)
        button.isHidden = true
        return button
    }()

    open private(set) lazy var selectedButton: LMButton = {
        let button =  LMButton()
            .translatesAutoresizingMaskIntoConstraints()
        button.addTarget(self, action: #selector(selectedRowButton), for: .touchUpInside)
        button.isHidden = true
        button.backgroundColor = Appearance.shared.colors.clear
        return button
    }()
    
    weak var delegate: LMChatMessageCellDelegate?
    var currentIndexPath: IndexPath?
    var originalCenter = CGPoint()
    var replyActionHandler: (() -> Void)?
    
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        retryButton.isHidden = true
        chatMessageView.prepareToResuse()
    }
    
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
        containerView.addSubview(retryContainerStackView)
        contentView.addSubview(selectedButton)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        contentView.pinSubView(subView: containerView)
        NSLayoutConstraint.activate([
            retryContainerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            retryContainerStackView.centerYAnchor.constraint(equalTo: chatMessageView.centerYAnchor),
            
            chatMessageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
            chatMessageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            chatMessageView.trailingAnchor.constraint(equalTo: retryContainerStackView.leadingAnchor, constant: -8),
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
    open func setData(with data: ContentModel, delegate: LMChatAudioProtocol?, index: IndexPath) {
        chatMessageView.setDataView(data, delegate: delegate, index: index)
        chatMessageView.loaderView.delegate = self
        chatMessageView.retryView.delegate = self
        updateSelection(data: data)
        chatMessageView.delegate = self
        if data.message?.isIncoming == false {
            retryButton.isHidden = data.message?.messageStatus != .failed
        }
    }
    
    open func updateSelection(data: ContentModel) {
        let isSelected = data.isSelected
        selectedButton.backgroundColor = isSelected ? Appearance.shared.colors.linkColor.withAlphaComponent(0.4) : Appearance.shared.colors.clear
        selectedButton.isSelected = isSelected
    }
    
    @objc open func retrySendMessage(_ sender: UIButton) {
        guard let currentIndexPath else { return }
        retryButton.isHidden = true
        layoutIfNeeded()
        delegate?.didRetryAttachmentUploading(indexPath: currentIndexPath )
    }
}

extension LMChatMessageCell: LMAttachmentLoaderViewDelegate {
    public func cancelUploadingAttachmentClicked() {
        guard let currentIndexPath else { return }
        chatMessageView.loaderView.isHidden = true
        chatMessageView.retryView.isHidden = false
        delegate?.didCancelAttachmentUploading(indexPath: currentIndexPath )
    }
}
extension LMChatMessageCell: LMAttachmentUploadRetryViewDelegate {
    public func retryUploadingAttachmentClicked() {
        guard let currentIndexPath else { return }
        chatMessageView.loaderView.isHidden = false
        chatMessageView.retryView.isHidden = true
        delegate?.didRetryAttachmentUploading(indexPath: currentIndexPath )
    }
}

extension LMChatMessageCell: LMChatMessageContentViewDelegate {
    
    public func didTapOnReplyPreview() {
        delegate?.onClickReplyOfMessage(indexPath: currentIndexPath)
    }
    
    public func didTapOnProfileLink(route: String) {
        delegate?.didTapOnProfileLink(route: route)
    }
    
    public func clickedOnReaction(_ reaction: String) {
        delegate?.onClickReactionOfMessage(reaction: reaction, indexPath: currentIndexPath)
    }
    
    public func clickedOnAttachment(_ url: String) {
        delegate?.onClickAttachmentOfMessage(url: url, indexPath: currentIndexPath)
    }
}

