//
//  LMChatAudioPlayManager.swift
//  LikeMindsChatCore
//
//  Created by Devansh Mohata on 17/04/24.
//

import AVFoundation

public final class LMChatAudioPlayManager {
    static let shared = LMChatAudioPlayManager()
    
    private(set) var isSessionActive: Bool = false
    private var player: AVPlayer?
    private var session = AVAudioSession.sharedInstance()
    private var updater: CADisplayLink?
    private var url: URL?
    
    private init() { }
    
    var progressCallback: ((Int) -> Void)?
    
    
    private func activateSession() {
        guard !isSessionActive else { return }
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
            try session.overrideOutputAudioPort(.speaker)
            
            isSessionActive = true
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deactivateSession() {
        guard isSessionActive else { return }
        NotificationCenter.default.removeObserver(self)
        
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
            isSessionActive = false
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startAudio(url: String, progressCallback: ((Int) -> Void)?) {
        guard let url = URL(string: url) else { return }
        
        // Means user continuing with the same audio file
        if self.url == url {
            if player?.rate == 0 {
                play()
            } else {
                pause()
            }
            
            return
        }
        
        self.url = url
        self.progressCallback = progressCallback

        activateSession()
        
        let playerItem = AVPlayerItem(url: url)
        
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioEnded), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
        
        play()
    }
    
    func startAudio(fileURL: String, progressCallback: ((Int) -> Void)?) {
        let url = URL(fileURLWithPath: fileURL)
        
        if self.url == url {
            if player?.rate == 0 {
                play()
            } else {
                pause()
            }
            
            return
        }
        
        self.url = url
        self.progressCallback = progressCallback
        
        activateSession()
        
        let playerItem = AVPlayerItem(url: url)
        
        if let player {
            player.replaceCurrentItem(with: playerItem)
        } else {
            player = AVPlayer(playerItem: playerItem)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioEnded), name: AVPlayerItem.didPlayToEndTimeNotification, object: nil)
        
        play()
    }
    
    func stopAudio(stopCallback: (() -> Void)) {
        pause()
        stopCallback()
    }
    
    func seekAt(_ percentage: Float, url: String) {
        guard self.url == URL(string: url),
        let totalDuration = player?.currentItem?.duration else { return }
        
        pause()
        
        var seconds = totalDuration.seconds * Double(percentage / 100)
        // Case where seconds come out to be NaN or Infinite
        seconds = seconds.isNormal ? seconds : .zero
        let targeTime = CMTimeMake(value: Int64(seconds), timescale: 1)
        
        player?.seek(to: targeTime) { [weak self] status in
            if status {
                self?.play()
            }
        }
    }
    
    private func play() {
        player?.play()
        updater = CADisplayLink(target: self, selector: #selector(trackAudio))
        updater?.add(to: .main, forMode: .default)
    }
    
    private func pause() {
        player?.pause()
        updater?.invalidate()
        updater = nil
    }
    
    public func resetAudioPlayer() {
        pause()
        url = nil
        deactivateSession()
    }
    
    @objc
    private func trackAudio() {
        guard let currenTime = player?.currentTime() else { return }
        progressCallback?(Int(currenTime.seconds))
    }
    
    @objc
    private func audioEnded() {
        // Add Trigger for updating UI
        let audioDuration = Int(player?.currentItem?.duration.seconds ?? .zero)
        NotificationCenter.default.post(name: .LMChatAudioEnded, object: audioDuration)
        resetAudioPlayer()
    }
}
