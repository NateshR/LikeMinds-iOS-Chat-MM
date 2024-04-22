//
//  BottomMessageComposerView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 31/01/24.
//

import Foundation
import LMChatUI_iOS

public protocol LMBottomMessageComposerDelegate: AnyObject {
    func composeMessage(message: String)
    func composeAttachment()
    func composeAudio()
    func composeGif()
    func linkDetected(_ link: String)
}

@IBDesignable
open class LMBottomMessageComposerView: LMView {
    
    open weak var delegate: LMBottomMessageComposerDelegate?
    let audioButtonTag = 10
    let messageButtonTag = 11
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = Appearance.shared.colors.backgroundColor
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
        view.cornerRadius(with: 18)
        view.backgroundColor = .white
        view.borderColor(withBorderWidth: 1, with: Appearance.shared.colors.gray155)
        return view
    }()
    
    open private(set) lazy var inputTextAndGifHorizontalStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    open private(set) lazy var inputTextView: LMChatTaggingTextView = {
        let view = LMChatTaggingTextView().translatesAutoresizingMaskIntoConstraints()
//        view.textContainerInset = .zero
        view.placeHolderText = "Write somthing"
        view.mentionDelegate = self
        view.isScrollEnabled = false
        return view
    }()
    
    open private(set) var inputTextViewHeightConstraint: NSLayoutConstraint?
    open private(set) var taggingViewHeightConstraints: NSLayoutConstraint?
    
    var linkDetectorTimer: Timer?
    
    open private(set) lazy var gifButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(UIImage(systemName: "giftcard"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(gifButtonClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var sendButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.micIcon, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
//        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(sendMessageButtonClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var attachmentButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.plusIcon, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(attachmentButtonClicked), for: .touchUpInside)
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
        inputTextAndGifHorizontalStackView.addArrangedSubview(gifButton)
        
        horizontalStackView.addArrangedSubview(attachmentButton)
        horizontalStackView.addArrangedSubview(inputTextContainerView)
        horizontalStackView.addArrangedSubview(sendButton)
        
        addOnVerticleStackView.addArrangedSubview(linkPreviewView)
        addOnVerticleStackView.addArrangedSubview(replyMessageView)
        addOnVerticleStackView.insertArrangedSubview(taggingListView, at: 0)
        
        linkPreviewView.isHidden = true
        replyMessageView.isHidden = true
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
    
    @objc func sendMessageButtonClicked(_ sender: UIButton) {
        if sender.tag == audioButtonTag {
            audioButtonClicked(sender)
            return
        }
        let message = inputTextView.getText()
        guard !message.isEmpty,
              message != inputTextView.placeHolderText else {
            return
        }
        inputTextView.text = ""
        contentHeightChanged()
        delegate?.composeMessage(message: message)
    }
    
    @objc func attachmentButtonClicked(_ sender: UIButton) {
        delegate?.composeAttachment()
    }
    
    @objc func gifButtonClicked(_ sender: UIButton) {
        delegate?.composeGif()
    }
    
    @objc func audioButtonClicked(_ sender: UIButton) {
        delegate?.composeAudio()
    }
}

extension LMBottomMessageComposerView: LMFeedTaggingTextViewProtocol {
    
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
        
        if inputTextView.text.isEmpty || inputTextView.placeHolderText == inputTextView.text {
            sendButton.setImage(Constants.shared.images.micIcon, for: .normal)
            sendButton.tag = audioButtonTag
        } else {
            sendButton.tag = messageButtonTag
            sendButton.setImage(Constants.shared.images.paperplaneFilled, for: .normal)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        // Find first url link here and ignore email
        let links = textView.text.detectedLinks
        if !links.isEmpty, let link = links.first(where: {!$0.isEmail()}) {
            print("detected first link: \(link)")
            linkPreviewView.isHidden = false
            linkDetectorTimer?.invalidate()
            linkDetectorTimer = Timer(timeInterval: 1, repeats: false, block: {[weak self] timer in
                print("detected first link: \(link)")
                self?.delegate?.linkDetected(link)
            })
        } else {
            linkPreviewView.isHidden = true
        }
    }
    
}

extension LMBottomMessageComposerView: LMChatTaggedUserFoundProtocol {
    
    public func userSelected(with route: String, and userName: String) {
        inputTextView.addTaggedUser(with: userName, route: route)
        mentionStopped()
    }
    
    public func updateHeight(with height: CGFloat) {
        taggingViewHeightConstraints?.constant = height
    }
    
}
