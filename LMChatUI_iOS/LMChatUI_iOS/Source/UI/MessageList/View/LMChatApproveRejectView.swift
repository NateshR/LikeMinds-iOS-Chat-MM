//
//  LMChatApproveRejectView.swift
//  LikeMindsChatUI
//
//  Created by Pushpendra Singh on 25/06/24.
//

import Foundation

public protocol LMChatApproveRejectDelegate: AnyObject {
    func approveRequest()
    func rejectRequest()
}

open class LMChatApproveRejectView: LMView {
    
    //MARK: UI elements
    
    open private(set) lazy var stackContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fill
        view.alignment = .fill
        view.spacing = 16
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    open private(set) lazy var titleLable: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Appearance.shared.fonts.textFont2
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        return label
    }()
    
    open private(set) lazy var stackActionsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 20
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    open private(set) lazy var approveButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle("Approve", for: .normal)
        button.setFont(Appearance.shared.fonts.headingFont1)
        button.setTitleColor(Appearance.shared.colors.linkColor, for: .normal)
        button.addTarget(self, action: #selector(approveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var rejectButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setTitle("Reject", for: .normal)
        button.setFont(Appearance.shared.fonts.headingFont1)
        button.setTitleColor(Appearance.shared.colors.linkColor, for: .normal)
        button.addTarget(self, action: #selector(rejectButtonClicked), for: .touchUpInside)
        return button
    }()
    
    public var delegate: LMChatApproveRejectDelegate?
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = .secondarySystemBackground
        approveButton.backgroundColor = Appearance.shared.colors.white
        rejectButton.backgroundColor = Appearance.shared.colors.white
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(stackContainerView)
        stackContainerView.addArrangedSubview(titleLable)
        stackActionsContainerView.addArrangedSubview(approveButton)
        stackActionsContainerView.addArrangedSubview(rejectButton)
        stackContainerView.addArrangedSubview(stackActionsContainerView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: stackContainerView, padding: .init(top: 16, left: 16, bottom: -16, right: -16))
        approveButton.setHeightConstraint(with: 40)
        rejectButton.setHeightConstraint(with: 40)
        approveButton.cornerRadius(with: 8)
        rejectButton.cornerRadius(with: 8)
    }
    
    open func updateTitle(withTitleMessage message: String) {
        titleLable.text = message
    }
    
    @objc open func approveButtonClicked(_ sender: UIButton) {
        delegate?.approveRequest()
    }
    
    @objc open func rejectButtonClicked(_ sender: UIButton) {
        delegate?.rejectRequest()
    }
}
