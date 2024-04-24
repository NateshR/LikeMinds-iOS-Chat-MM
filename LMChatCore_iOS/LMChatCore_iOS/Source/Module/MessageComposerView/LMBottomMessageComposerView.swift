//
//  BottomMessageComposerView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 31/01/24.
//

import AVFoundation
import LMChatUI_iOS
import UIKit

public protocol LMBottomMessageComposerDelegate: AnyObject {
    func composeMessage(message: String)
    func composeAttachment()
    func composeAudio()
    func composeGif()
    func linkDetected(_ link: String)
    
    func audioRecordingStarted()
    func audioRecordingEnded()
    func playRecording()
    func stopRecording(_ onStop: (() -> Void))
    func deleteRecording()
    
    func cancelReply()
    func cancelLinkPreview()
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
        view.backgroundColor = Appearance.shared.colors.white
        view.placeHolderText = "Write somthing"
        view.mentionDelegate = self
        view.isScrollEnabled = false
        return view
    }()
    
    open private(set) var inputTextViewHeightConstraint: NSLayoutConstraint?
    open private(set) var taggingViewHeightConstraints: NSLayoutConstraint?
    
    open private(set) lazy var gifButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(UIImage(systemName: "giftcard"), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        //        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(gifButtonClicked), for: .touchUpInside)
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
        view.onClickCancelReplyPreview = { [weak self] in
            self?.delegate?.cancelReply()
        }
        return view
    }()
    
    open private(set) lazy var replyMessageViewContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.addSubview(replyMessageView)
        view.pinSubView(subView: replyMessageView, padding: .init(top: 6, left: 16, bottom: -4, right: -16))
        view.isHidden = true
        return view
    }()
    
    open private(set) lazy var linkPreviewView: LMBottomMessageLinkPreview = {
        let view = LMBottomMessageLinkPreview().translatesAutoresizingMaskIntoConstraints()
        view.delegate = self
        return view
    }()
    
    open private(set) lazy var taggingListView: LMChatTaggingListView = {
        let view = LMChatTaggingListView().translatesAutoresizingMaskIntoConstraints()
        let viewModel = LMChatTaggingListViewModel(delegate: view)
        view.viewModel = viewModel
        view.delegate = self
        return view
    }()
    
    // MARK:
    open private(set) lazy var audioMessageContainerStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = .zero
        return stack
    }()
    
    
    // MARK: Send Button
    open private(set) lazy var sendButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.micIcon, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        return button
    }()
    
    
    // MARK: Audio Elements
    open private(set) lazy var audioContainerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .clear
        return view
    }()
    
    open private(set) lazy var micFlickerButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle(nil, for: .normal)
        button.setImage(Constants.shared.images.micIcon, for: .normal)
        return button
    }()
    
    open private(set) lazy var recordDuration: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    open private(set) lazy var audioStack: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    open private(set) lazy var slideToCancel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "< Slide To Cancel"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    open private(set) lazy var deleteAudioRecord: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle(nil, for: .normal)
        button.setImage(UIImage(systemName: "x.circle"), for: .normal)
        return button
    }()
    
    open private(set) lazy var restrictionLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Restricted to reply in this chatroom!"
        label.backgroundColor = Appearance.shared.colors.white
        label.paddingRight = 20
        label.paddingLeft = 20
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        label.textColor = Appearance.shared.colors.textColor
        return label
    }()
    
    let maxHeightOfTextView: CGFloat = 120
    let minHeightOfTextView: CGFloat = 44
    var sendButtonTrailingConstraint: NSLayoutConstraint?
    var sendButtonLongPressGesture: UILongPressGestureRecognizer!
    var sendButtonPanPressGesture: UIPanGestureRecognizer!
    var isPlayingAudio = false
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(addOnVerticleStackView)
        
        containerView.addSubview(audioMessageContainerStack)
        containerView.addSubview(sendButton)
        
        audioMessageContainerStack.addArrangedSubview(horizontalStackView)
        audioMessageContainerStack.addArrangedSubview(audioContainerView)
        
        inputTextContainerView.addSubview(inputTextAndGifHorizontalStackView)
        inputTextAndGifHorizontalStackView.addArrangedSubview(inputTextView)
        inputTextAndGifHorizontalStackView.addArrangedSubview(gifButton)
        
        horizontalStackView.addArrangedSubview(attachmentButton)
        horizontalStackView.addArrangedSubview(inputTextContainerView)
        
        addOnVerticleStackView.addArrangedSubview(linkPreviewView)
        addOnVerticleStackView.addArrangedSubview(replyMessageViewContainer)
        addOnVerticleStackView.insertArrangedSubview(taggingListView, at: 0)
        
        audioContainerView.addSubview(micFlickerButton)
        audioContainerView.addSubview(recordDuration)
        audioContainerView.addSubview(audioStack)
        
        audioStack.addArrangedSubview(slideToCancel)
        audioStack.addArrangedSubview(deleteAudioRecord)
        
        linkPreviewView.isHidden = true
        replyMessageViewContainer.isHidden = true
        
        containerView.addSubview(restrictionLabel)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        pinSubView(subView: containerView)
        addOnVerticleStackView.addConstraint(top: (containerView.topAnchor, 4),
                                             leading: (containerView.leadingAnchor, 0),
                                             trailing: (containerView.trailingAnchor, 0))
        
        audioMessageContainerStack.addConstraint(top: (addOnVerticleStackView.bottomAnchor, 4),
                                                 bottom: (containerView.bottomAnchor, -4),
                                                 leading: (containerView.leadingAnchor, 8))
        
        micFlickerButton.addConstraint(top: (audioContainerView.topAnchor, 4),
                                       bottom: (audioContainerView.bottomAnchor, -4),
                                       leading: (audioContainerView.leadingAnchor, 8))
        
        recordDuration.addConstraint(top: (micFlickerButton.topAnchor, 0),
                                     bottom: (micFlickerButton.bottomAnchor, 0),
                                     leading: (micFlickerButton.trailingAnchor, 8))
        
        audioStack.addConstraint(top: (recordDuration.topAnchor, 0),
                                    bottom: (recordDuration.bottomAnchor, 0),
                                    trailing: (audioContainerView.trailingAnchor, -8))
        
        audioStack.leadingAnchor.constraint(greaterThanOrEqualTo: recordDuration.trailingAnchor, constant: 8).isActive = true
        
        
        sendButton.addConstraint(leading: (audioMessageContainerStack.trailingAnchor, 8),
                                 centerY: (containerView.centerYAnchor, 0))
        
        sendButtonTrailingConstraint = sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        sendButtonTrailingConstraint?.isActive = true
        
        sendButton.setHeightConstraint(with: 40)
        sendButton.setWidthConstraint(with: sendButton.heightAnchor)
        
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeightOfTextView),
//            containerView.heightAnchor.constraint(lessThanOrEqualToConstant: maxHeightOfTextView),
            
            inputTextAndGifHorizontalStackView.leadingAnchor.constraint(equalTo: inputTextContainerView.leadingAnchor, constant: 8),
            inputTextAndGifHorizontalStackView.trailingAnchor.constraint(equalTo: inputTextContainerView.trailingAnchor, constant: -10),
            inputTextAndGifHorizontalStackView.topAnchor.constraint(equalTo: inputTextContainerView.topAnchor),
            inputTextAndGifHorizontalStackView.bottomAnchor.constraint(equalTo: inputTextContainerView.bottomAnchor),
            inputTextContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 36)
        ])
        inputTextViewHeightConstraint = inputTextView.setHeightConstraint(with: 36)
        taggingViewHeightConstraints = taggingListView.setHeightConstraint(with: 0)
        
        containerView.pinSubView(subView: restrictionLabel)
    }
    
    open override func setupActions() {
        super.setupActions()
        sendButton.addTarget(self, action: #selector(sendMessageButtonClicked), for: .touchUpInside)
        
        sendButtonLongPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(sendButtonLongPressed))
        sendButtonLongPressGesture.minimumPressDuration = 0.5
        sendButtonLongPressGesture.delegate = self
        
        sendButtonPanPressGesture = UIPanGestureRecognizer(target: self, action: #selector(sendButtonPanPress))
        
        sendButtonLongPressGesture.isEnabled = true
        sendButtonPanPressGesture.isEnabled = true
        
        sendButton.addGestureRecognizer(sendButtonLongPressGesture)
        sendButton.addGestureRecognizer(sendButtonPanPressGesture)
        
        audioContainerView.isHidden = true
        restrictionLabel.isHidden = true
        
        deleteAudioRecord.addTarget(self, action: #selector(deleteRecording), for: .touchUpInside)
        micFlickerButton.addTarget(self, action: #selector(didTapPlayRecording), for: .touchUpInside)
        
        sendButton.tag = audioButtonTag
    }
    
    func enableOrDisableMessageBox(withMessage message: String?, isEnable: Bool) {
        restrictionLabel.text = message
        restrictionLabel.isHidden = isEnable
        containerView.isUserInteractionEnabled = isEnable
    }
    
    @objc func sendMessageButtonClicked(_ sender: UIButton) {
        if sender.tag == audioButtonTag {
            audioButtonClicked(sender)
            hideRecordingView()
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
    
    open override func setupAppearance() {
        super.setupAppearance()
        audioContainerView.backgroundColor = .white
        audioContainerView.layer.cornerRadius = 8
    }
    
    func showReplyView(withData data: LMMessageReplyPreview.ContentModel) {
        replyMessageView.setData(data)
        replyMessageViewContainer.isHidden = false
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
        
        checkSendButtonActions()
        
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
        if !links.isEmpty,
            let link = links.first(where: {!$0.isEmail()}) {
            print("detected first link: \(link)")
            linkPreviewView.isHidden = false
            self.delegate?.linkDetected(link)
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


// MARK: UIGestureRecognizerDelegate
extension LMBottomMessageComposerView: UIGestureRecognizerDelegate {
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == sendButtonLongPressGesture && otherGestureRecognizer == sendButtonPanPressGesture
    }
}


// MARK: AUDIO EXTENSION
extension LMBottomMessageComposerView {
    @objc
    open func sendButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        guard inputTextView.text == inputTextView.placeHolderText || inputTextView.text.isEmpty else { return }
        
        if #available(iOS 17, *) {
            if AVAudioApplication.shared.recordPermission == .granted {
                handleLongPress(sender)
            } else if AVAudioApplication.shared.recordPermission == .denied {
                print("no mic access")
            } else if AVAudioApplication.shared.recordPermission == .undetermined {
                AVAudioApplication.requestRecordPermission { _ in }
            }
        } else {
            switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                handleLongPress(sender)
            case .denied:
                print("No Access to microphone")
            case .undetermined:
                AVAudioSession.sharedInstance().requestRecordPermission { _ in}
            default:
                break
            }
        }
    }
    
    public func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        inputTextView.resignFirstResponder()
        
        switch sender.state {
        case .began:
            // Start Recording
            delegate?.audioRecordingStarted()
        case .ended:
            delegate?.audioRecordingEnded()
        case .cancelled:
            delegate?.audioRecordingEnded()
            break
        default:
            break
        }
    }
    
    @objc
    open func sendButtonPanPress(_ sender: UIPanGestureRecognizer) {
        guard sendButtonLongPressGesture.state == .changed else { return }
        
        let translation = sender.translation(in: self)
        
        if translation.x < -8 {
            if abs(translation.x) < UIScreen.main.bounds.width * 0.3 {
                sendButtonTrailingConstraint?.constant = translation.x
            } else {
                delegate?.deleteRecording()
            }
        }
    }
    
    @objc
    open func didTapPlayRecording() {
        if !isPlayingAudio {
            micFlickerButton.setImage(Constants.shared.images.pauseIcon, for: .normal)
            delegate?.playRecording()
        } else {
            micFlickerButton.setImage(Constants.shared.images.playFill, for: .normal)
            delegate?.stopRecording {
                isPlayingAudio = false
            }
        }
    }
    
    @objc
    open func deleteRecording() {
        delegate?.deleteRecording()
    }
    
    func showRecordingView() {
        horizontalStackView.isHidden = true
        audioContainerView.isHidden = false
        sendButtonTrailingConstraint?.constant = -8
        
        deleteAudioRecord.isHidden = true
        slideToCancel.isHidden = false
        
        micFlickerButton.setImage(Constants.shared.images.micIcon, for: .normal)
        micFlickerButton.tintColor = .red
        micFlickerButton.isEnabled = false
    }
    
    func hideRecordingView() {
        sendButtonTrailingConstraint?.constant = -8
        horizontalStackView.isHidden = false
        audioContainerView.isHidden = true
        recordDuration.text = "00:00"
        
        checkSendButtonActions()
        sendButton.setImage(Constants.shared.images.micIcon, for: .normal)
        sendButtonPanPressGesture.isEnabled = true
        sendButtonLongPressGesture.isEnabled = true
        
        isPlayingAudio = false
    }
    
    func showRecordedView() {
        slideToCancel.isHidden = true
        deleteAudioRecord.isHidden = false
        
        micFlickerButton.setImage(Constants.shared.images.playFill, for: .normal)
        micFlickerButton.tintColor = Appearance.shared.colors.gray51
        micFlickerButton.isEnabled = true
        
        sendButtonTrailingConstraint?.constant = -8
        sendButton.setImage(UIImage(systemName: "paperplane.circle.fill"), for: .normal)
        
        isPlayingAudio = false
    }
    
    func resetRecordedAudioDuration() {
        isPlayingAudio = false
        micFlickerButton.setImage(Constants.shared.images.playFill, for: .normal)
        recordDuration.text = convertSecondsToFormattedTime(seconds: 0)
    }
    
    func checkSendButtonActions() {
        sendButtonLongPressGesture.isEnabled = !(inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || inputTextView.text == inputTextView.placeHolderText)
        sendButtonPanPressGesture.isEnabled = !(inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || inputTextView.text == inputTextView.placeHolderText)
    }
    
    func updateRecordTime(with seconds: Int, isPlayback: Bool = false) {
        recordDuration.text = convertSecondsToFormattedTime(seconds: seconds)
        isPlayingAudio = isPlayback
        
        if !isPlayback {
            UIView.animate(withDuration: 0.3, delay: 0.1) { [weak self] in
                guard let self else { return }
                self.micFlickerButton.alpha = self.micFlickerButton.alpha == 1 ? 0.5 : 1
            }
        }
    }
    
    // TODO: Remove this, when moving it to UI Library, same function exists in `LMChatAudioPreview`
    func convertSecondsToFormattedTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}

extension LMBottomMessageComposerView: LMBottomMessageLinkPreviewDelete {
    
    public func closeLinkPreview() {
        delegate?.cancelLinkPreview()
    }
}
