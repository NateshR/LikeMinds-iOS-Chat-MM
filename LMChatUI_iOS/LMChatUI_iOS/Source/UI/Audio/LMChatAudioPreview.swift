//
//  LMChatAudioPreview.swift
//  LMChatUI_iOS
//
//  Created by Devansh Mohata on 17/04/24.
//

import Kingfisher
import UIKit

open class LMChatAudioPreview: LMView {
    // MARK: UI Elements
    lazy var containerView: LMView = {
        let view = LMView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    lazy var thumbnailImage: LMImageView = {
        let imageView = LMImageView().translatesAutoresizingMaskIntoConstraints()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var headphoneContainerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    lazy var headphoneImage: LMImageView = {
        let imageView = LMImageView().translatesAutoresizingMaskIntoConstraints()
        imageView.image = UIImage(systemName: "headphones")
        imageView.tintColor = .white
        return imageView
    }()
    
    lazy var durationLbl: LMLabel = {
        let label = LMLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    var playPauseButton: LMImageView = {
        let button = LMImageView()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.image = UIImage(systemName: "play.circle.fill")
        button.contentMode = .scaleAspectFill
        button.isUserInteractionEnabled = true
        return button
    }()
    
    var slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        return slider
    }()
    
    lazy var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = "Audio"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    
    var delegate: LMChatAudioProtocol?
    var url: String?
    var duration = 0
    var index: IndexPath?
    var isPlaying: Bool = false
    
    
    // MARK: setupViews
    override open func setupViews() {
        super.setupViews()
        
        addSubview(containerView)
        
        containerView.addSubview(thumbnailImage)
        containerView.addSubview(headphoneContainerView)
        
        headphoneContainerView.addSubview(headphoneImage)
        headphoneContainerView.addSubview(durationLbl)
        
        containerView.addSubview(playPauseButton)
        containerView.addSubview(slider)
        containerView.addSubview(durationLbl)
        containerView.addSubview(titleLabel)
    }
    
    
    // MARK: setupLayouts
    override open func setupLayouts() {
        pinSubView(subView: containerView)
        
        thumbnailImage.addConstraint(top: (containerView.topAnchor, 0),
                                     bottom: (containerView.bottomAnchor, 0),
                                     leading: (containerView.leadingAnchor, 0))
        
        thumbnailImage.pinSubView(subView: headphoneContainerView)
        thumbnailImage.setWidthConstraint(with: thumbnailImage.heightAnchor)
        
        headphoneImage.addConstraint(top: (headphoneContainerView.topAnchor, 4),
                                     leading: (headphoneContainerView.leadingAnchor, 4),
                                     trailing: (headphoneContainerView.trailingAnchor, -4))
        
        durationLbl.topAnchor.constraint(equalTo: headphoneImage.bottomAnchor, constant: 2).isActive = true
        durationLbl.leadingAnchor.constraint(equalTo: headphoneContainerView.leadingAnchor, constant: 4).isActive = true
        durationLbl.trailingAnchor.constraint(equalTo: headphoneContainerView.trailingAnchor, constant: -4).isActive = true
        durationLbl.bottomAnchor.constraint(equalTo: headphoneContainerView.bottomAnchor, constant: -4).isActive = true
        
        titleLabel.addConstraint(bottom: (thumbnailImage.bottomAnchor, 0),
                                 leading: (thumbnailImage.trailingAnchor, 8),
                                 trailing: (containerView.trailingAnchor, -8))
        
        playPauseButton.addConstraint(top: (thumbnailImage.topAnchor, 8),
                                      bottom: (titleLabel.topAnchor, -8),
                                      leading: (thumbnailImage.trailingAnchor, 8))
        playPauseButton.setHeightConstraint(with: 36)
        playPauseButton.setWidthConstraint(with: playPauseButton.heightAnchor)
        
        slider.addConstraint(leading: (playPauseButton.trailingAnchor, 4),
                             trailing: (containerView.trailingAnchor, -4),
                             centerY: (playPauseButton.centerYAnchor, 0))
        slider.setHeightConstraint(with: 10)
    }
    
    
    // MARK: setupActions
    override open func setupActions() {
        playPauseButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPlayPauseButton)))
        slider.addTarget(self, action: #selector(didSeekPlayer), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
    }
    
    
    // MARK: setupAppearance
    override open func setupAppearance() {
        super.setupAppearance()
        containerView.backgroundColor = .gray.withAlphaComponent(0.1)
    }
    
    @objc
    open func didTapPlayPauseButton() {
        guard let url,
        let index else { return }
        
        if isPlaying {
            playPauseButton.image = UIImage(systemName: "play.circle.fill")
            isPlaying.toggle()
        }
        
        delegate?.didTapPlayPauseButton(for: url, index: index)
    }
    
    @objc
    open func didSeekPlayer(slider: UISlider, event: UIEvent) {
        guard let index,
              let url,
              let touchEvent = event.allTouches?.first else { return }
        switch touchEvent.phase {
        case .began:
            delegate?.didTapPlayPauseButton(for: url, index: index)
        case .ended:
            delegate?.didSeekTo(slider.value, url, index: index)
        default:
            break
        }
    }
    
    
    // MARK: configure
    open func configure(with data: LMChatAudioContentModel, delegate: LMChatAudioProtocol, index: IndexPath) {
        titleLabel.text = data.fileName
        titleLabel.isHidden = data.fileName?.isEmpty != false
        url = data.url
        duration = data.duration
        thumbnailImage.kf.setImage(with: URL(string: data.thumbnail ?? ""))
        self.index = index
        durationLbl.text = convertSecondsToFormattedTime(seconds: data.duration)
        self.delegate = delegate
    }
    
    
    // Updates Seeker value when needed! (0 - 100)
    open func updateSeekerValue(with time: Float, for url: String) {
        guard self.url == url else { return }
        isPlaying = true
        let percentage = (time / Float(duration)) * 100
        slider.value = self.url == url ? percentage : .zero
        playPauseButton.image = UIImage(systemName: self.url == url ? "pause.circle.fill" : "play.circle.fill")
        durationLbl.text = convertSecondsToFormattedTime(seconds: Int(time))
    }
    
    open func resetView() {
        playPauseButton.image = UIImage(systemName: "play.circle.fill")
        durationLbl.text = convertSecondsToFormattedTime(seconds: duration)
        isPlaying = false
        slider.value = 0
    }
    
    func convertSecondsToFormattedTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
