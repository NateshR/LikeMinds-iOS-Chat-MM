//
//  LMAudioPlayerView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/05/24.
//

import UIKit
import AVFoundation
import LMChatUI_iOS

open class LMAudioPlayerView: LMView {
    
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    fileprivate let seekDuration: Float64 = 10
    var playIcon: UIImage? = Constants.shared.images.playIcon.withSystemImageConfig(pointSize: 65, weight: .light)
    var pauseIcon: UIImage? = Constants.shared.images.pauseCircleIcon.withSystemImageConfig(pointSize: 65, weight: .light)
    
//    var loadingView: UIActivityIndicatorView!
    var viewTintColor: UIColor = .systemYellow
    
    open private(set) lazy var playbackSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(playbackSliderValueChanged(_:)), for: .valueChanged)
        slider.minimumValue = 0
        slider.tintColor = viewTintColor
        return slider
    }()
    
    open private(set) lazy var ButtonPlay: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(playIcon, for: .normal)
        button.tintColor = viewTintColor
        button.widthAnchor.constraint(equalToConstant: 75.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 75.0).isActive = true
        button.addTarget(self, action: #selector(buttonPlay(_:)), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var back10SecsPlay: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.goBackwardIcon.withSystemImageConfig(pointSize: 22, weight: .light), for: .normal)
        button.tintColor = viewTintColor
        button.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        button.addTarget(self, action: #selector(buttonGoToBackSec(_:)), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var forward10SecsPlay: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.goForwardIcon.withSystemImageConfig(pointSize: 22, weight: .light), for: .normal)
        button.tintColor = viewTintColor
        button.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        button.addTarget(self, action: #selector(buttonForwardSec(_:)), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var audioActionsContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 20
        view.addArrangedSubview(back10SecsPlay)
        view.addArrangedSubview(ButtonPlay)
        view.addArrangedSubview(forward10SecsPlay)
        return view
    }()
    
    open private(set) lazy var playerContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .fill
        view.spacing = 40
        view.addArrangedSubview(fileNameLable)
        view.addArrangedSubview(durationContainerStackView)
        view.addArrangedSubview(playbackSlider)
        view.addArrangedSubview(audioActionsContainerStackView)
        return view
    }()
    
    open private(set) lazy var durationContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .fill
        view.spacing = 20
        view.addArrangedSubview(lblcurrentText)
        view.addArrangedSubview(spacerDurations)
        view.addArrangedSubview(lblOverallDuration)
        return view
    }()
    
    open private(set) lazy var lblOverallDuration: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "00:00"
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.white
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var lblcurrentText: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "00:00"
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.white
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var fileNameLable: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.headingFont
        label.textColor = Appearance.shared.colors.white
        label.numberOfLines = 1
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var spacerDurations: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: 4, relatedBy: .greaterThanOrEqual)
        return view
    }()
    
    open private(set) lazy var playerDurationContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 20
        view.addArrangedSubview(back10SecsPlay)
        view.addArrangedSubview(ButtonPlay)
        view.addArrangedSubview(forward10SecsPlay)
        return view
    }()
    
    var url: String = "" {
        didSet {
            setupPlayer(url)
        }
    }

    open override func setupViews() {
        super.setupViews()
        addSubview(playerContainerStackView)
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = .black
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        playerContainerStackView.addConstraint(leading: (leadingAnchor, 16), trailing: (trailingAnchor, -16), centerY: (centerYAnchor, 0))
    }
    
    func setupPlayer(_ urlString: String) {
//        "https://s3.amazonaws.com/kargopolov/kukushka.mp3"
        ButtonPlay.setImage(playIcon, for: .normal)
        guard let url = URL(string: urlString) else { return }
        fileNameLable.text = url.lastPathComponent
        let playerItem:AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlaying(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        
        let duration : CMTime = playerItem.asset.duration
        let seconds : Float64 = CMTimeGetSeconds(duration)
        lblOverallDuration.text = self.stringFromTimeInterval(interval: seconds)
        
        let duration1 : CMTime = playerItem.currentTime()
        let seconds1 : Float64 = CMTimeGetSeconds(duration1)
        lblcurrentText.text = self.stringFromTimeInterval(interval: seconds1)
        
        playbackSlider.maximumValue = Float(seconds)
        playbackSlider.isContinuous = true
        playbackSlider.tintColor = viewTintColor
        
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.player!.currentItem?.status == .readyToPlay {
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                self.playbackSlider.value = Float ( time );
                
                self.lblcurrentText.text = self.stringFromTimeInterval(interval: time)
            }
            
            let playbackLikelyToKeepUp = self.player?.currentItem?.isPlaybackLikelyToKeepUp
            if playbackLikelyToKeepUp == false{
                print("IsBuffering")
//                self.ButtonPlay.isHidden = true
                //                self.loadingView.isHidden = false
            } else {
                //stop the activity indicator
                print("Buffering completed")
                self.ButtonPlay.isHidden = false
                //                self.loadingView.isHidden = true
            }
            
        }
    }
    
    @objc
    func ButtonGoToBack(_ sender: UIButton) {
        
    }
    
    @objc
    func buttonGoToBackSec(_ sender: UIButton) {
        if player == nil { return }
        let playerCurrenTime = CMTimeGetSeconds(player!.currentTime())
        var newTime = playerCurrenTime - seekDuration
        if newTime < 0 { newTime = 0 }
        player?.pause()
        let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
        player?.seek(to: selectedTime)
        player?.play()
    }
    
    @objc
    func buttonPlay(_ sender: UIButton) {
        print("play Button")
        if player?.rate == 0
        {
            player!.play()
//            self.ButtonPlay.isHidden = true
//            self.loadingView.isHidden = false
            ButtonPlay.setImage(pauseIcon, for: .normal)
        } else {
            player!.pause()
            ButtonPlay.setImage(playIcon, for: .normal)
        }
    }
    
    @objc
    func buttonForwardSec(_ sender: UIButton) {
        if player == nil { return }
        if let duration  = player!.currentItem?.duration {
            let playerCurrentTime = CMTimeGetSeconds(player!.currentTime())
            let newTime = playerCurrentTime + seekDuration
            if newTime < CMTimeGetSeconds(duration)
            {
                let selectedTime: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
                player!.seek(to: selectedTime)
            }
            player?.pause()
            player?.play()
        }
    }
    
    @objc
    func ButtonGoToNext(_ sender: UIButton) {
    }
    
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        player!.seek(to: targetTime)
        
        if player!.rate == 0
        {
            player?.play()
        }
    }
    
    @objc func finishedPlaying( _ myNotification:NSNotification) {
        ButtonPlay.setImage(playIcon, for: UIControl.State.normal)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return  hours > 0 ? String(format: "%02d:%02d:%02d", hours, minutes, seconds) : String(format: "%02d:%02d", minutes, seconds)
    }
    
}
