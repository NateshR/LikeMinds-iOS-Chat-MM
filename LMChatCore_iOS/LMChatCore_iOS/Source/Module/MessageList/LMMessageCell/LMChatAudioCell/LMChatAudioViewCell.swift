//
//  LMChatAudioViewCell.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS
import LikeMindsChat

@IBDesignable
open class LMChatAudioViewCell: LMChatMessageCell {
    
    open private(set) lazy var audioMessageView: LMChatAudioContentView = {
        let view = LMChatAudioContentView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: setupViews
    open override func setupViews() {
        chatMessageView = audioMessageView
        super.setupViews()
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
    }
    
    
    // MARK: configure
    open override func setData(with data: ContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        super.setData(with: data, delegate: delegate, index: index)
        audioMessageView.layoutIfNeeded()
    }
    
    open func resetAudio() {
        audioMessageView.resetAudio()
    }
    
    open func seekSlider(to position: Float, url: String) {
        audioMessageView.seekSlider(to: position, url: url)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

