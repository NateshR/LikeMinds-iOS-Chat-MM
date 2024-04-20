//
//  LMChatVideoPlayer.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 20/04/24.
//

import AVFoundation
import LMChatUI_iOS
import AVKit

public final class LMChatVideoPlayer: LMView {
    let playerViewController = AVPlayerViewController()
    
    func configure(with videoURL: String) {
        guard let url = URL(string: videoURL) else { return }
        let player = AVPlayer(url: url)
        
        
        playerViewController.player = player
        playerViewController.allowsPictureInPicturePlayback = false
        playerViewController.entersFullScreenWhenPlaybackBegins = false
        playerViewController.showsPlaybackControls = true
        
        playerViewController.view.frame.size.height = frame.size.height
        playerViewController.view.frame.size.width = frame.size.width
        addSubview(playerViewController.view)
    }
    
    func stopVideo() {
        playerViewController.player?.pause()
    }
    
    func playVideo() {
        playerViewController.player?.play()
    }
}
