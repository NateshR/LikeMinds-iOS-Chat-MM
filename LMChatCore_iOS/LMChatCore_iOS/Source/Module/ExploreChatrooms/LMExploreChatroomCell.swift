//
//  LMExploreChatroomCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS
import LikeMindsChat

@IBDesignable
open class LMExploreChatroomCell: LMTableViewCell {
    
    public struct ContentModel {
        public let chatroom: Chatroom?
    }
    
    var onJoinButtonClick: ((_ value: Bool, _ chatroomId: String) -> Void)?
    
    // MARK: UI Elements
    open private(set) lazy var chatroomView: LMExploreChatroomView = {
        let view = LMCoreComponents.shared.exploreChatroomView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(containerView)
        containerView.addSubview(chatroomView)
        containerView.addSubview(sepratorView)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            chatroomView.topAnchor.constraint(equalTo: containerView.topAnchor),
            chatroomView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            chatroomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            chatroomView.bottomAnchor.constraint(equalTo: sepratorView.topAnchor),
            
            sepratorView.leadingAnchor.constraint(equalTo: chatroomView.chatroomImageView.leadingAnchor, constant: 5),
            sepratorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sepratorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sepratorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        
        sepratorView.backgroundColor = Appearance.shared.colors.gray4
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
    }
    
    
    // MARK: configure
    open func configure(with data: ContentModel) {
        let creatorName = data.chatroom?.member?.name ?? "NA"
        var lastMessage = "\(creatorName.components(separatedBy: " ").first ?? "NA"): " + "\(data.chatroom?.lastConversation?.answer ?? "NA")"
        lastMessage = GetAttributedTextWithRoutes.getAttributedText(from: lastMessage).string
        
        chatroomView.setData(LMExploreChatroomView.ContentModel(userName: data.chatroom?.member?.name, title: data.chatroom?.title, chatroomName: data.chatroom?.header, chatroomImageUrl: data.chatroom?.chatroomImageUrl, isSecret: data.chatroom?.isSecret, isAnnouncementRoom: data.chatroom?.type == ChatroomType.purpose.rawValue, participantsCount: data.chatroom?.participantsCount, messageCount: data.chatroom?.totalResponseCount, isFollowed: data.chatroom?.followStatus, chatroomId: data.chatroom?.id ?? "", externalSeen: data.chatroom?.externalSeen, isPinned: data.chatroom?.isPinned))
        chatroomView.onJoinButtonClick = {[weak self] (value, chatroomId) in
            data.chatroom?.followStatus = value
            self?.onJoinButtonClick?(value, chatroomId)
        }
    }

}

