//
//  LMLoaderView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 04/05/24.
//

import Foundation
import LMChatUI_iOS

open class LMLoaderView: LMView {
    
    open private(set) lazy var loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.color = Appearance.shared.colors.white
        loader.startAnimating()
        return loader
    }()
    
    open override func setupViews() {
        super.setupViews()
        addSubview(loaderView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        pinSubView(subView: loaderView, padding: .init(top: 4, left: 4, bottom: -4, right: -4))
    }
    
    open override func setupAppearance() {
        backgroundColor = Appearance.shared.colors.black.withAlphaComponent(0.8)
        cornerRadius(with: 8)
    }
}
