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
    open private(set) lazy var chatMessageView: LMChatMessageContentView = {
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
//        setSwipeGesture()
        // Add swipe gesture recognizer
        // Add pan gesture recognizer
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        addGestureRecognizer(panGesture)
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translation(in: superview!)
            if abs(translation.x) > abs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            // Save original center position
            originalCenter = center
        case .changed:
            // Calculate translation
            let translation = gestureRecognizer.translation(in: self)
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
        case .ended:
            // Check if the swipe distance meets the threshold for reply
            if frame.origin.x < -frame.size.width / 3 {
                // Perform reply action when swipe distance exceeds threshold
                replyActionHandler?()
                print("perform reply action...")
                
            } else {
                // Return the message view to its original position if swipe distance is not enough
                UIView.animate(withDuration: 0.2) {
                    self.center = self.originalCenter
                }
            }
        default:
            break
        }
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
        
        chatMessageView.galleryView.onClickAttachment = {[weak self] index in
            self?.delegate?.onClickGalleryOfMessage(attachmentIndex: index, indexPath: self?.currentIndexPath)
        }
        
        chatMessageView.clickedOnAttachment = {[weak self] url in
            self?.delegate?.onClickAttachmentOfMessage(url: url, indexPath: self?.currentIndexPath)
        }
        
        chatMessageView.replyMessageView.onClickReplyPreview = { [weak self] in
            self?.delegate?.onClickReplyOfMessage(indexPath: self?.currentIndexPath)
        }
        
        chatMessageView.linkPreview.onClickLinkPriview = {[weak self] url in
            self?.delegate?.onClickAttachmentOfMessage(url: url, indexPath: self?.currentIndexPath)
        }
    }
    
    func updateSelection(data: ContentModel) {
        let isSelected = data.isSelected
        selectedButton.backgroundColor = isSelected ? Appearance.shared.colors.linkColor.withAlphaComponent(0.4) : Appearance.shared.colors.clear
        selectedButton.isSelected = isSelected
    }
    
    open func resetAudio() {
        chatMessageView.resetAudio()
    }
    
    open func seekSlider(to position: Float, url: String) {
        chatMessageView.seekSlider(to: position, url: url)
    }
    
    
    //declare the `UISwipeGestureRecognizer`
    let swipeGesture = UISwipeGestureRecognizer()
    
    //a call back to notify the swipe in `cellForRowAt` as follow.
    var replyCallBack : ( () -> Void)?
    
    func setSwipeGesture(){
        // Add the swipe gesture and set the direction to the right or left according to your needs
        swipeGesture.direction = .right
        contentView.addGestureRecognizer(swipeGesture)
        
        // Add a target to the swipe gesture to handle the swipe
        swipeGesture.addTarget(self, action: #selector(handleSwipe(_:)))
    }
    
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        // Animate the action view onto the screen when the user swipes right
        if gesture.direction == .right {
            UIView.animate(withDuration: 0.15) {
                self.chatMessageView.transform = CGAffineTransform(translationX: self.contentView.frame.width / 2.5, y: 0)
                
                // Schedule a timer to restore the cell after 0.2 seconds or change it according to your needs
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { (_) in
                    UIView.animate(withDuration: 0.1) {
                        self.chatMessageView.transform = .identity
                        
                        //callback to notify in cellForRowAt
                        self.replyCallBack?()
                        
                        //your code when
                    }
                }
            }
        } else {
            // Animate the action view off the screen when the user swipes left
            
            UIView.animate(withDuration: 0.3) {
                self.chatMessageView.transform = .identity
            }
        }
    }
}

