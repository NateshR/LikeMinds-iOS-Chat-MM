//
//  LMChatMessageFooterView.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 25/06/24.
//

import Foundation
import LikeMindsChatUI

class LMChatDirectMessageFooterView: LMView {
    
    //MARK: UI Elements
    open private(set) lazy var approveRejectView: LMChatApproveRejectView = {[unowned self] in
        let view = LMUIComponents.shared.approveRejectRequestView.init().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var footerMessageLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.textAlignment = .center
        label.font = Appearance.shared.fonts.textFont2
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        label.numberOfLines = 0
        return label
    }()
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
    }
    
    func setupLabel(_ text: String) {
        addSubview(footerMessageLabel)
        footerMessageLabel.text = text
        pinSubView(subView: footerMessageLabel, padding: .init(top: 5, left: 16, bottom: 0, right: -16))
    }
    
    func setupApproveRejectView(_ text: String, delegate: LMChatApproveRejectDelegate?) {
        addSubview(approveRejectView)
        approveRejectView.delegate = delegate
        approveRejectView.updateTitle(withTitleMessage: text)
        pinSubView(subView: approveRejectView)
    }
    
    static func createView(_ text: String, isApproveRejectView: Bool, delegate: LMChatApproveRejectDelegate?) -> LMChatDirectMessageFooterView {
        let view = LMChatDirectMessageFooterView().translatesAutoresizingMaskIntoConstraints()
        if isApproveRejectView {
            view.setupApproveRejectView(text, delegate: delegate)
        } else {
            view.setupLabel(text)
        }
        return view
    }
    
//    func updateFooterView(chatRequestState: Chatre?) {
//     
//            if chatRoom.chatRequestState == .initiated && (UserBasicInfoUtil.loggedInMemberUUID != chatRoom.chatRequestedBy?.sdkClientInfo?.uuid) {
//                guard let footer = DirecetMessageConfirmationView.nib.instantiate(withOwner: nil).first as? DirecetMessageConfirmationView else { return }
//                footer.delegate = delegate
//                self.addSubview(footer)
//                self.backgroundColor = .white
//                footer.translatesAutoresizingMaskIntoConstraints = false
//                footer.addConstraintsToView(superView: self)
//            } else if chatRoom.isPrivateMember == true,
//                      chatRoom.chatRequestState == nil {
//                let label = UILabel()
//                label.numberOfLines = 0
//                let member = UserBasicInfoUtil.loggedInMemberUUID == chatRoom.chatroomWithUser?.sdkClientInfo?.uuid ? chatRoom.member : chatRoom.chatroomWithUser
//                label.text = String(format: Constant.DirectMessage.bottomMessage, member?.name ?? "")
//                label.font = UIFont.systemFont(ofSize: 12)
//                label.textAlignment = .center
//                label.textColor = LMColors.charcoalGrey
//                self.addSubview(label)
//                self.frame.size.height = 100
//                label.translatesAutoresizingMaskIntoConstraints = false
//                label.addConstraintsToView(superView: self, top: 5, bottom: 0, leading: 16, trailing: -16)
//            }
//        }

}
