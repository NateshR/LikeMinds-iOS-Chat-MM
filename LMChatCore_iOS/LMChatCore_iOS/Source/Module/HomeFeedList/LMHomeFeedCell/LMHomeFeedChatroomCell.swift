//
//  LMHomeFeedChatroomCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 09/02/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS
import LikeMindsChat

@IBDesignable
open class LMHomeFeedChatroomCell: LMTableViewCell {
    
    public struct ContentModel {
        public let chatroom: Chatroom?
    }
    
    // MARK: UI Elements
    open private(set) lazy var chatroomView: LMHomeFeedChatroomView = {
        let view = LMCoreComponents.shared.homeFeedChatroomView.init().translatesAutoresizingMaskIntoConstraints()
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
        
        chatroomView.setData(LMHomeFeedChatroomView.ContentModel(userName: data.chatroom?.member?.name ?? "NA",
                                                                 lastMessage: lastMessage,
                                                                 chatroomName: data.chatroom?.header ?? "NA",
                                                                 chatroomImageUrl: data.chatroom?.chatroomImageUrl,
                                                                 isMuted: data.chatroom?.muteStatus ?? false,
                                                                 isSecret: data.chatroom?.isSecret ?? false,
                                                                 isAnnouncementRoom: data.chatroom?.type == ChatroomType.purpose.rawValue,
                                                                 unreadCount: data.chatroom?.unseenCount ?? 0,
                                                                 timestamp: timestampConverted(createdAtInEpoch: data.chatroom?.updatedAt ?? 0) ?? "NA"))
    }
    
    func timestampConverted(createdAtInEpoch: Int) -> String? {
        guard createdAtInEpoch > .zero else { return nil }
        var epochTime = Double(createdAtInEpoch)
        
        if epochTime > Date().timeIntervalSince1970 {
            epochTime = epochTime / 1000
        }
        
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.amSymbol = "AM"
            dateFormatter.pmSymbol = "PM"
            return dateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter.string(from: date)
        }
    }
}

