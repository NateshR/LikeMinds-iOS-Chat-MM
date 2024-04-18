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

@IBDesignable
open class LMChatMessageCell: LMTableViewCell {
    
    public struct ContentModel {
        public let message: LMMessageListView.ContentModel.Message?
    }
    
    // MARK: UI Elements
    open private(set) lazy var chatMessageView: LMChatMessageContentView = {
        let view = LMCoreComponents.shared.messageContentView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        chatMessageView.prepareToResuse()
    }
    
    var originalCenter = CGPoint()
    var replyActionHandler: (() -> Void)?
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        contentView.addSubview(containerView)
        containerView.addSubview(chatMessageView)
        // Add swipe gesture recognizer
        // Add pan gesture recognizer
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
//        addGestureRecognizer(panGesture)
    }
    
//    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
//        switch gestureRecognizer.state {
//        case .began:
//            // Save original center position
//            originalCenter = center
//        case .changed:
//            // Calculate translation
//            let translation = gestureRecognizer.translation(in: self)
//            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
//        case .ended:
//            // Check if the swipe distance meets the threshold for reply
//            if frame.origin.x < -frame.size.width / 2 {
//                // Perform reply action when swipe distance exceeds threshold
//                replyActionHandler?()
//                print("perform reply action...")
//            } else {
//                // Return the message view to its original position if swipe distance is not enough
//                UIView.animate(withDuration: 0.2) {
//                    self.center = self.originalCenter
//                }
//            }
//        default:
//            break
//        }
//    }
    
    
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
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
        chatMessageView.backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.backgroundColor
    }
    
    
    // MARK: configure
    open func setData(with data: ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        chatMessageView.setDataView(data, delegate: delegate, index: index)
    }
    
    public func resetAudio() {
        chatMessageView.resetAudio()
    }
    
    public func seekSlider(to position: Float, url: String) {
        chatMessageView.seekSlider(to: position, url: url)
    }
}

