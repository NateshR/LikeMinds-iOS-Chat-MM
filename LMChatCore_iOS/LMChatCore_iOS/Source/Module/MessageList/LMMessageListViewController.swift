//
//  LMMessageListViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 18/03/24.
//

import Foundation
import LMChatUI_iOS

protocol LMMessageListControllerDelegate: AnyObject {
    func postMessage(message: String?,
                     filesUrls: [AttachmentMediaData]?,
                     shareLink: String?,
                     replyConversationId: String?,
                     replyChatRoomId: String?)
    func postMessageWithAttachment()
    func postMessageWithGifAttachment()
    func postMessageWithAudioAttachment()
}

open class LMMessageListViewController: LMViewController {
    
    open private(set) lazy var bottomMessageBoxView: LMBottomMessageComposerView = {
        let view = LMBottomMessageComposerView().translatesAutoresizingMaskIntoConstraints()
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
    
    var bottomTextViewContainerBottomConstraints: NSLayoutConstraint?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        self.setNavigationTitleAndSubtitle(with: "Chatroom", subtitle: nil, alignment: .center)

//        setBackButtonWithAction()
        setupNavigationBar()
        
//        viewModel?.fetchBottomConversations()
        viewModel?.getInitialData()
        viewModel?.syncConversation()
        setRightNavigationWithAction(title: nil, image: Constants.shared.images.ellipsisCircleIcon, style: .plain, target: self, action: #selector(chatroomActions))
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        bottomTextViewContainerBottomConstraints = bottomMessageBoxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomTextViewContainerBottomConstraints?.isActive = true
        NSLayoutConstraint.activate([
            messageListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageListView.bottomAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor),
            messageListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            bottomMessageBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMessageBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomMessageBoxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
    }
    
    @objc
    open override func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.bottomTextViewContainerBottomConstraints?.isActive = false
        self.bottomTextViewContainerBottomConstraints?.constant = -((frame.size.height - self.view.safeAreaInsets.bottom))
        self.bottomTextViewContainerBottomConstraints?.isActive = true
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    open override func keyboardWillHide(_ sender: Notification) {
        self.bottomTextViewContainerBottomConstraints?.isActive = false
        self.bottomTextViewContainerBottomConstraints?.constant = 0
        self.bottomTextViewContainerBottomConstraints?.isActive = true
        self.view.layoutIfNeeded()
    }
    
    @objc
    open func chatroomActions() {
        guard let actions = viewModel?.chatroomActionData?.chatroomActions else { return }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for item in actions {
            let actionItem = UIAlertAction(title: item.title, style: UIAlertAction.Style.default) {[weak self] (UIAlertAction) in
                self?.viewModel?.performChatroomActions(action: item)
            }
            alert.addAction(actionItem)
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension LMMessageListViewController: LMMessageListViewModelProtocol {
    public func reloadChatMessageList() {
        setNavigationTitleAndSubtitle(with: viewModel?.chatroomViewData?.header, subtitle: "\(viewModel?.chatroomViewData?.participantsCount ?? 0) participants")
        messageListView.tableSections = viewModel?.messagesList ?? []
        messageListView.reloadData()
        
    }
}

extension LMMessageListViewController: LMMessageListViewDelegate {
    
    public func didTappedOnReaction(reaction: String, indexPath: IndexPath) {
        guard let message = viewModel?.messagesList[indexPath.section].data[indexPath.row],
        let conversation = viewModel?.chatMessages.first(where: {$0.id == message.messageId}),
        let reactions = conversation.reactions else { return }
        NavigationScreen.shared.perform(.reactionSheet(reactions: reactions), from: self, params: nil)
    }
    
    
    public func fetchDataOnScroll(indexPath: IndexPath, direction: ScrollDirection) {
        viewModel?.getMoreConversations(indexPath: indexPath, direction: direction)
    }
    
    
    public func didTapOnCell(indexPath: IndexPath) {
        
    }

}

extension LMMessageListViewController: LMBottomMessageComposerDelegate {
    
    public func composeMessage(message: String) {
        print("\(message)")
        delegate?.postMessage(message: message, filesUrls: nil, shareLink: nil, replyConversationId: nil, replyChatRoomId: nil)
    }
    
    public func composeAttachment() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.view.tintColor = BrandingColor.shared.buttonColor
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (UIAlertAction) in
//            self.presenter?.openMediaPicker(mediaType: "camera")
        }
        let cameraImage = Constants.shared.images.cameraIcon
        camera.setValue(cameraImage, forKey: "image")
        
        let photo = UIAlertAction(title: "Photo & Video", style: UIAlertAction.Style.default) { [weak self] (UIAlertAction) in
           guard let viewController =  try? LMChatAttachmentViewModel.createModule(delegate: self) else { return }
            self?.present(viewController, animated: true)
        }
        
        let photoImage = Constants.shared.images.galleryIcon
        photo.setValue(photoImage, forKey: "image")
        
        let audio = UIAlertAction(title: "Audio", style: UIAlertAction.Style.default) { (UIAlertAction) in
            MediaPickerManager.shared.presentAudioAndDocumentPicker(viewController: self, delegate: self, fileType: .audio)
        }
        
        let audioImage = Constants.shared.images.micIcon
        audio.setValue(audioImage, forKey: "image")
        
        let document = UIAlertAction(title: "Document", style: UIAlertAction.Style.default) { (UIAlertAction) in
            MediaPickerManager.shared.presentAudioAndDocumentPicker(viewController: self, delegate: self, fileType: .audio)
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
    
    public func linkDetected(_ link: String) {
        viewModel?.decodeUrl(url: link)
    }
}

extension LMMessageListViewController: MediaPickerDelegate {
    
    func filePicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel], fileType: MediaType) {
        
    }
}

extension LMMessageListViewController: LMChatAttachmentViewDelegate {
    
    public func postConversationWithAttchments(message: String?, attachments: [MediaPickerModel]) {
        let attachmentMedia: [AttachmentMediaData] = attachments.compactMap { media in
            var mediaData = AttachmentMediaData.builder()
                .url(media.url)
                .fileType(media.mediaType)
                .mediaName(media.url?.lastPathComponent)
                .format(media.mediaType.rawValue)
                .image(media.photo)
        
            switch media.mediaType {
            case .video, .audio:
                if let url = media.url, let videoDeatil = FileUtils.getDetail(forVideoUrl: url) {
                    mediaData = mediaData.duration(videoDeatil.duration)
                        .size(Int64(videoDeatil.fileSize ?? 0))
                        .thumbnailurl(videoDeatil.thumbnailUrl)
                }
            case .pdf:
                if let url = media.url, let pdfDetail = FileUtils.getDetail(forPDFUrl: url) {
                    mediaData = mediaData.pdfPageCount(pdfDetail.pageCount)
                        .size(Int64(pdfDetail.fileSize ?? 0))
                        .thumbnailurl(pdfDetail.thumbnailUrl)
                }
            case .image, .gif:
                if let url = media.url {
                    let dimension = FileUtils.imageDimensions(with: url)
                    mediaData = mediaData.size(Int64(FileUtils.fileSizeInByte(url: media.url) ?? 0))
                        .width(dimension?.width)
                        .height(dimension?.height)
                }
            default:
                break
            }
            return mediaData.build()
        }
        
        viewModel?.postMessage(message: message, filesUrls: attachmentMedia, shareLink: nil, replyConversationId: nil, replyChatRoomId: nil)
    }
}
