//
//  LMAttachmentBottomMessageView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 14/03/24.
//

import Foundation
import LMChatUI_iOS

public protocol LMAttachmentBottomMessageDelegate: AnyObject {
    func addMoreAttachment()
    func sendAttachment(message: String?)
    func addGifAttachment()
}

@IBDesignable
open class LMAttachmentBottomMessageView: LMView {
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .clear
        return view
    }()
    
    open private(set) lazy var topSeparatorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.gray155
        return view
    }()
    
    open private(set) lazy var addOnVerticleStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 0
        return view
    }()
    
    open private(set) lazy var horizontalStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.spacing = 12
        //        view.alignment = .bottom
        return view
    }()
    
    open private(set) lazy var inputTextContainerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
//        view.cornerRadius(with: 18)
        view.backgroundColor = Appearance.shared.colors.clear
        //        view.borderColor(withBorderWidth: 1, with: .lightGray)
        return view
    }()
    
    open private(set) lazy var inputTextAndGifHorizontalStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.spacing = 8
        view.backgroundColor = Appearance.shared.colors.clear
        return view
    }()
    
    open private(set) lazy var inputTextView: LMChatTaggingTextView = {
        let view = LMChatTaggingTextView().translatesAutoresizingMaskIntoConstraints()
        //        view.textContainerInset = .zero
        view.placeHolderText = "Write somthing"
        view.mentionDelegate = self
        view.isScrollEnabled = false
        view.textColor = Appearance.shared.colors.white
        view.font = Appearance.shared.fonts.textFont1
        view.backgroundColor = Appearance.shared.colors.clear
        return view
    }()
    
    open private(set) var inputTextViewHeightConstraint: NSLayoutConstraint?
    open private(set) var taggingViewHeightConstraints: NSLayoutConstraint?
    open weak var delegate: LMAttachmentBottomMessageDelegate?
    
    open private(set) lazy var gifButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(UIImage(systemName: "giftcard"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        //        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        return button
    }()
    
    open private(set) lazy var sendButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.paperplaneIcon, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        //        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(sendAttachmentButtonClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var attachmentButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.plusIcon, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(addMoreAttachmentButtonClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var replyMessageView: LMMessageReplyPreview = {
        let view = LMMessageReplyPreview().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var linkPreviewView: LMBottomMessageLinkPreview = {
        let view = LMBottomMessageLinkPreview().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var taggingListView: LMChatTaggingListView = {
        let view = LMChatTaggingListView().translatesAutoresizingMaskIntoConstraints()
        let viewModel = LMChatTaggingListViewModel(delegate: view)
        view.viewModel = viewModel
        view.delegate = self
        return view
    }()
    
    let maxHeightOfTextView: CGFloat = 120
    let minHeightOfTextView: CGFloat = 44
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(addOnVerticleStackView)
        containerView.addSubview(horizontalStackView)
        inputTextContainerView.addSubview(inputTextAndGifHorizontalStackView)
        inputTextAndGifHorizontalStackView.addArrangedSubview(inputTextView)
//        inputTextAndGifHorizontalStackView.addArrangedSubview(gifButton)
        
        horizontalStackView.addArrangedSubview(attachmentButton)
        horizontalStackView.addArrangedSubview(inputTextContainerView)
        horizontalStackView.addArrangedSubview(sendButton)
        
//        addOnVerticleStackView.addArrangedSubview(linkPreviewView)
//        addOnVerticleStackView.addArrangedSubview(replyMessageView)
        addOnVerticleStackView.insertArrangedSubview(taggingListView, at: 0)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeightOfTextView),
            //            containerView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeightOfTextView),
            
            addOnVerticleStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            addOnVerticleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            addOnVerticleStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            
            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            horizontalStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            horizontalStackView.topAnchor.constraint(equalTo: addOnVerticleStackView.bottomAnchor, constant: 4),
            horizontalStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            
            inputTextAndGifHorizontalStackView.leadingAnchor.constraint(equalTo: inputTextContainerView.leadingAnchor, constant: 8),
            inputTextAndGifHorizontalStackView.trailingAnchor.constraint(equalTo: inputTextContainerView.trailingAnchor, constant: -10),
            inputTextAndGifHorizontalStackView.topAnchor.constraint(equalTo: inputTextContainerView.topAnchor),
            inputTextAndGifHorizontalStackView.bottomAnchor.constraint(equalTo: inputTextContainerView.bottomAnchor),
            inputTextContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        inputTextViewHeightConstraint = inputTextView.setHeightConstraint(with: 36)
        taggingViewHeightConstraints = taggingListView.setHeightConstraint(with: 0)
    }
    
    @objc func sendAttachmentButtonClicked(_ sender: UIButton) {
        
        let message = inputTextView.getText()
        guard message != inputTextView.placeHolderText, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        inputTextView.text = ""
        contentHeightChanged()
        delegate?.sendAttachment(message: message)
    }
    
    @objc func addMoreAttachmentButtonClicked(_ sender: UIButton) {
        delegate?.addMoreAttachment()
    }
}

extension LMAttachmentBottomMessageView: LMFeedTaggingTextViewProtocol {
    
    public func mentionStarted(with text: String, chatroomId: String) {
        taggingListView.fetchUsers(for: text, chatroomId: chatroomId)
    }
    
    public func mentionStopped() {
        taggingListView.stopFetchingUsers()
    }
    
    
    public func contentHeightChanged() {
        let width = inputTextView.frame.size.width
        
        let newSize = inputTextView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        
        inputTextView.isScrollEnabled = newSize.height > maxHeightOfTextView
        inputTextViewHeightConstraint?.constant = min(newSize.height, maxHeightOfTextView)
    }
}

extension LMAttachmentBottomMessageView: LMChatTaggedUserFoundProtocol {
    
    public func userSelected(with route: String, and userName: String) {
        inputTextView.addTaggedUser(with: userName, route: route)
        mentionStopped()
    }
    
    public func updateHeight(with height: CGFloat) {
        taggingViewHeightConstraints?.constant = height
    }
    
}
