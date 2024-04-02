//
//  LMChatMessageContentView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 22/03/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat
import Kingfisher

@IBDesignable
open class LMChatMessageContentView: LMView {
    
    public struct ContentModel {
        public let message: Conversation?
        public let isIncommingMessage: Bool
        
        init(message: Conversation?, isIncommingMessage: Bool) {
            self.message = message
            self.isIncommingMessage = isIncommingMessage
        }
    }
    
    var isIncommingMessage: Bool = true
    
    open private(set) lazy var bubbleView: LMChatMessageBubbleView = {
        return LMCoreComponents.shared
            .messageBubbleView
            .init()
            .translatesAutoresizingMaskIntoConstraints()
    }()
    
    open private(set) lazy var chatProfileImageContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .bottom
        //        view.distribution = .fillProportionally
        view.spacing = 10
        view.addArrangedSubview(chatProfileImageView)
        return view
    }()
    
    open private(set) lazy var chatProfileImageView: LMChatProfileView = {
        let image = LMChatProfileView().translatesAutoresizingMaskIntoConstraints()
        return image
    }()
    
    var textLabel: LMTextView = {
        let label =  LMTextView()
            .translatesAutoresizingMaskIntoConstraints()
//        label.numberOfLines = 0
        label.isScrollEnabled = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .left
        label.isEditable = false
        label.textContainerInset = .zero
        label.text = "Test viaslf alf asldjl asj dajs ldffj lasdj flajlsdf aldj f alsdjf las fjdlasd"
        return label
    }()
    
    open private(set) lazy var timestampLabel: LMLabel = {
        let label =  LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.text = "12:20 PM"
        return label
    }()

    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        isIncommingMessage = ((Int(arc4random_uniform(6)) + 1)/2) == 0
        let bubble = createBubbleView(forIncoming: isIncommingMessage)
        bubbleView = bubble
        addSubview(bubble)
        addSubview(chatProfileImageContainerStackView)
        bubble.addArrangeSubview(textLabel)
        bubble.addSubview(timestampLabel)
        let interaction = UIContextMenuInteraction(delegate: self)
        bubble.addInteraction(interaction)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            chatProfileImageContainerStackView.topAnchor.constraint(equalTo: topAnchor),
            chatProfileImageContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            chatProfileImageContainerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bubbleView.topAnchor.constraint(equalTo: topAnchor),
            bubbleView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            timestampLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5),
            timestampLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -15),
            timestampLabel.leadingAnchor.constraint(greaterThanOrEqualTo: bubbleView.leadingAnchor, constant: 10),
        ])
        
        if !isIncommingMessage {
            chatProfileImageView.isHidden = true
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: chatProfileImageContainerStackView.trailingAnchor, constant: 40).isActive = true
            bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        } else {
            chatProfileImageView.isHidden = false
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -40).isActive = true
            bubbleView.leadingAnchor.constraint(equalTo: chatProfileImageContainerStackView.trailingAnchor).isActive = true
            
        }
    }
    
    open func createBubbleView(forIncoming: Bool) -> LMChatMessageBubbleView {
        let bubble = LMCoreComponents.shared
            .messageBubbleView
            .init()
            .translatesAutoresizingMaskIntoConstraints()
        bubble.isIncoming = forIncoming
        return bubble
    }
    
}

extension LMChatMessageContentView: UIContextMenuInteractionDelegate {
    
    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: { suggestedActions in
            let saveAction = UIAction(title: NSLocalizedString("Save", comment: ""),
                                      image: UIImage(systemName: "arrow.down.square")) { action in
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""),
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { action in
            }
            
            return UIMenu(title: "Select Action", children: [saveAction, deleteAction])
        })
    }
}

