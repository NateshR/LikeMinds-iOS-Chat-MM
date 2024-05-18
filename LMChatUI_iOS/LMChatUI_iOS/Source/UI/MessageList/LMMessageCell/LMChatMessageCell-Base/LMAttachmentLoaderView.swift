//
//  LMAttachmentLoaderView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 04/05/24.
//

import Foundation

public protocol LMAttachmentLoaderViewDelegate: AnyObject {
    func cancelUploadingAttachmentClicked()
}

open class LMAttachmentLoaderView: LMView {
    
    open private(set) lazy var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = Appearance.shared.colors.white
        loader.startAnimating()
        return loader
    }()
    
    open private(set) lazy var actionButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.crossIcon.withSystemImageConfig(pointSize: 30), for: .normal)
        button.tintColor = Appearance.shared.colors.white
        button.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        button.addTarget(self, action: #selector(cancelUploadingAttachment), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: LMAttachmentLoaderViewDelegate?
    
    open override func setupViews() {
        super.setupViews()
        addSubview(loaderView)
        addSubview(actionButton)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: loaderView, padding: .init(top: 4, left: 4, bottom: -4, right: -4))
        pinSubView(subView: actionButton, padding: .init(top: 4, left: 4, bottom: -4, right: -4))
    }
    
    open override func setupAppearance() {
        backgroundColor = Appearance.shared.colors.black.withAlphaComponent(0.8)
    }
    
    @objc
    func cancelUploadingAttachment(_ sender: UIButton) {
        delegate?.cancelUploadingAttachmentClicked()
    }
}
