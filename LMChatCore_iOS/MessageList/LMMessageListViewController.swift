//
//  LMMessageListViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 18/03/24.
//

import Foundation
import LMChatUI_iOS

protocol LMMessageListControllerDelegate: AnyObject {
    func postMessage(message: String)
    func postMessageWithAttachment()
    func postMessageWithGifAttachment()
    func postMessageWithAudioAttachment()
}

open class LMMessageListViewController: LMViewController {
    
    open private(set) lazy var bottomMessageBoxView: LMBottomMessageComposerView = {
        let view = LMBottomMessageComposerView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .cyan
        view.delegate = self
        return view
    }()
    
    open private(set) lazy var messageListView: LMMessageListView = {
        let view = LMMessageListView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    public var viewModel: LMMessageListViewModel?
    weak var delegate: LMMessageListControllerDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        
        viewModel?.getConversations()
        viewModel?.syncConversation()
        
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        self.view.addSubview(messageListView)
        self.view.addSubview(bottomMessageBoxView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            messageListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageListView.bottomAnchor.constraint(equalTo: bottomMessageBoxView.bottomAnchor),
            messageListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            bottomMessageBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMessageBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
//            bottomMessageBoxView.heightAnchor.constraint(equalToConstant: 44),
            bottomMessageBoxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
}

extension LMMessageListViewController: LMMessageListViewModelProtocol {
    public func reloadChatMessageList() {
        messageListView.tableSections = viewModel?.messagesList ?? []
        messageListView.reloadData()
    }
}

extension LMMessageListViewController: LMMessageListViewDelegate {
    
    public func didTapOnCell(indexPath: IndexPath) {
    }
    
    public func fetchMoreData() {
        
    }
}

extension LMMessageListViewController: LMBottomMessageComposerDelegate {
    
    public func composeMessage(message: String) {
        print("\(message)")
        delegate?.postMessage(message: message)
    }
    
    public func composeAttachment() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.view.tintColor = BrandingColor.shared.buttonColor
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (UIAlertAction) in
//            self.presenter?.openMediaPicker(mediaType: "camera")
        }
        let cameraImage = Constants.shared.images.cameraIcon
        camera.setValue(cameraImage, forKey: "image")
        
        let photo = UIAlertAction(title: "Photo & Video", style: UIAlertAction.Style.default) { (UIAlertAction) in
//            self.presenter?.openMediaPicker(mediaType: "gallery")
        }
        
        let photoImage = Constants.shared.images.galleryIcon
        photo.setValue(photoImage, forKey: "image")
        
        let audio = UIAlertAction(title: "Audio", style: UIAlertAction.Style.default) { (UIAlertAction) in
//            self.presenter?.openMediaPicker(mediaType: "audio")
        }
        
        let audioImage = Constants.shared.images.micIcon
        audio.setValue(audioImage, forKey: "image")
        
        let document = UIAlertAction(title: "Document", style: UIAlertAction.Style.default) { (UIAlertAction) in
//            self.presenter?.openMediaPicker(mediaType: "doc")
        }
        
        let documentImage = Constants.shared.images.documentsIcon
        document.setValue(documentImage, forKey: "image")
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(camera)
        alert.addAction(photo)
        alert.addAction(audio)
        alert.addAction(document)
        /*
        if let provider = dataProvider,
           provider.checkMemberRight(with: .createPolls),
           provider.currentChatRoom?.type != .directMessage {
            let microPollAction = UIAlertAction(title: "Poll", style: .default) { UIAlertAction in
                self.presenter?.openMediaPicker(mediaType: "poll")
            }
            let pollImage = UIImage(named: "microPoll")
            microPollAction.setValue(pollImage, forKey: "image")
            alert.addAction(microPollAction)
        }
        */
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    public func composeAudio() {
        delegate?.postMessageWithAudioAttachment()
    }
    
    public func composeGif() {
        delegate?.postMessageWithGifAttachment()
    }
}
