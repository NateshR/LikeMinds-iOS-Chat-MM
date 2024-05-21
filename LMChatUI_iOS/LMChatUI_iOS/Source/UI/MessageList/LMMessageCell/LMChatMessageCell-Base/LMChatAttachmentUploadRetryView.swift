//
//  LMChatAttachmentUploadRetryView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 14/05/24.
//

import Foundation

public protocol LMAttachmentUploadRetryViewDelegate: AnyObject {
    func retryUploadingAttachmentClicked()
}

open class LMChatAttachmentUploadRetryView: LMView {
    
    open private(set) lazy var actionButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.cloudIcon.withSystemImageConfig(pointSize: 30), for: .normal)
        button.setTitle("Retry", for: .normal)
        button.tintColor = Appearance.shared.colors.white
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 0);
        button.addTarget(self, action: #selector(retryUploadingAttachment), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: LMAttachmentUploadRetryViewDelegate?
    
    open override func setupViews() {
        super.setupViews()
        addSubview(actionButton)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: actionButton, padding: .init(top: 4, left: 8, bottom: -4, right: -8))
    }
    
    open override func setupAppearance() {
        backgroundColor = Appearance.shared.colors.black.withAlphaComponent(0.8)
        cornerRadius(with: 8)
    }
    
    @objc
    func retryUploadingAttachment(_ sender: UIButton) {
        delegate?.retryUploadingAttachmentClicked()
    }
    
}
