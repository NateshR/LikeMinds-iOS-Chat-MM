//
//  LMChatMediaVideoPreview.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 20/04/24.
//

import LMChatUI_iOS
import UIKit

open class LMChatMediaVideoPreview: LMCollectionViewCell {
    open private(set) lazy var videoPlayer: LMChatVideoPlayer = {
        let player = LMChatVideoPlayer()
        player.translatesAutoresizingMaskIntoConstraints = false
        return player
    }()
    
    open override func setupViews() {
        super.setupViews()
        contentView.addSubviewWithDefaultConstraints(videoPlayer)
    }
    
    open func configure(with url: String) {
        videoPlayer.configure(with: url)
    }
    
    open func stopVideo() {
        videoPlayer.stopVideo()
    }
}
