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
    
    static func createView(_ text: String, delegate: LMChatApproveRejectDelegate?) -> UITableViewHeaderFooterView {
        let view = LMChatDirectMessageFooterView().translatesAutoresizingMaskIntoConstraints()
        view.setupApproveRejectView(text, delegate: delegate)
        let footerView = UITableViewHeaderFooterView()
        footerView.addSubview(view)
        view.leadingAnchor.constraint(equalTo: footerView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: footerView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10).isActive = true
        view.bottomAnchor.constraint(equalTo: footerView.bottomAnchor).isActive = true
        footerView.backgroundColor = Appearance.shared.colors.secondaryBackgroundColor
        footerView.layoutIfNeeded()
        return footerView
    }
}
