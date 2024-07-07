//
//  LMChatAttachmentViewController.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 13/03/24.
//

import Foundation
import LikeMindsChatUI
import AVFoundation
import AVKit
import CoreServices

public protocol LMChatAttachmentViewDelegate: AnyObject {
    func postConversationWithAttchments(message: String?, attachments: [MediaPickerModel])
}

open class LMChatAttachmentViewController: LMViewController {
    
    let backgroundColor: UIColor = .black
    weak var delegate: LMChatAttachmentViewDelegate?
    
    open private(set) lazy var bottomMessageBoxView: LMChatAttachmentBottomMessageView = {
        let view = LMChatAttachmentBottomMessageView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.black.withAlphaComponent(0.7)
        view.delegate = self
        return view
    }()
    
    open private(set) lazy var imageViewCarouselContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = Appearance.shared.colors.black.withAlphaComponent(0.7)
        return view
    }()
    
    open private(set) lazy var imageActionsContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = backgroundColor
        return view
    }()
    
    open private(set) lazy var zoomableImageViewContainer: LMChatZoomImageViewContainer = {
        let view = LMChatZoomImageViewContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        return view
    }()
    
    open private(set) lazy var videoImageViewContainer: LMChatMediaVideoPreview = {
        let view = LMChatMediaVideoPreview()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
        view.isHidden = true
        return view
    }()
    
    open private(set) lazy var audioPlayer: LMChatAudioPlayerView = {
        let view = LMChatAudioPlayerView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = backgroundColor
        view.isHidden = true
        return view
    }()
    
    open private(set) lazy var editButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.pencilIcon.withSystemImageConfig(pointSize: 22, weight: .bold), for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.addTarget(self, action: #selector(editingImage), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var deleteButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.deleteIcon.withSystemImageConfig(pointSize: 22, weight: .bold), for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.addTarget(self, action: #selector(deleteMediaData), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var cancelButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.xmarkIcon.withSystemImageConfig(pointSize: 20, weight: .bold), for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.addTarget(self, action: #selector(cancelEditing), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var rightContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        view.addArrangedSubview(editButton)
        view.addArrangedSubview(deleteButton)
        return view
    }()
    
    open private(set) lazy var mediaCollectionView: LMCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1
        let collection = LMCollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.registerCell(type: LMChatMediaCarouselCell.self)
        collection.registerCell(type: LMChatAudioCarouselCell.self)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    open private(set) lazy var mediaDetailLabelContainerStackView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.alignment = .center
        view.addArrangedSubview(fileNameLabel)
        view.addArrangedSubview(fileDetailLabel)
        view.backgroundColor = Appearance.shared.colors.black.withAlphaComponent(0.8)
        return view
    }()
    
    open private(set) lazy var fileNameLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.font = Appearance.shared.fonts.headingFont1
        label.textColor = Appearance.shared.colors.white
        label.numberOfLines = 1
        label.paddingTop = 8
        label.paddingRight = 16
        label.paddingLeft = 16
        label.paddingBottom = 4
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    open private(set) lazy var fileDetailLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = nil
        label.font = Appearance.shared.fonts.headingFont3
        label.textColor = Appearance.shared.colors.white
        label.numberOfLines = 1
        label.paddingTop = 4
        label.paddingRight = 16
        label.paddingLeft = 16
        label.paddingBottom = 8
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    public var viewModel: LMChatAttachmentViewModel?
    var bottomTextViewContainerBottomConstraints: NSLayoutConstraint?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
        setupAppearance()
        openPicker()
        bottomMessageBoxView.inputTextView.chatroomId = viewModel?.chatroomId ?? ""
        viewModel?.fetchChatroom()
        initializeHideKeyboard(zoomableImageViewContainer)
        initializeHideKeyboard(videoImageViewContainer)
        initializeHideKeyboard(audioPlayer)
        let attText = GetAttributedTextWithRoutes.getAttributedText(from: LMSharedPreferences.getString(forKey: viewModel?.chatroomId ?? "NA") ?? "")
        if !attText.string.isEmpty {
            bottomMessageBoxView.inputTextView.attributedText = attText
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {[weak self] in
                self?.bottomMessageBoxView.inputTextView.becomeFirstResponder()
            }
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bottomMessageBoxView.inputTextView.mentionDelegate?.contentHeightChanged()
        bottomMessageBoxView.isTaggingEnable = (viewModel?.chatroomData?.type != .directMessage)
    }
    
    func openPicker() {
        if let cellData = viewModel?.mediaCellData, !cellData.isEmpty {
            mediaCollectionView.reloadData()
            editButton.isHidden = true
            bottomMessageBoxView.attachmentButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.zoomableImageViewContainer.imageView.image == nil, let firstData = cellData.first {
                    self.setDataToView(firstData)
                }
            }
        } else {
            switch viewModel?.sourceType {
            case .photoLibrary:
                addMoreAttachment()
            case .camera:
                presentCamera()
            default:
                break
            }
        }
    }
    
    func presentCamera() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            MediaPickerManager.shared.presentCamera(viewController: self, delegate: self)
        }
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        self.view.addSubview(imageActionsContainer)
        self.view.addSubview(zoomableImageViewContainer)
        self.view.addSubview(videoImageViewContainer)
        self.view.addSubview(audioPlayer)
        self.view.addSubview(mediaDetailLabelContainerStackView)
        self.view.addSubview(bottomMessageBoxView)
        self.view.addSubview(imageViewCarouselContainer)
        imageViewCarouselContainer.addSubview(mediaCollectionView)
        imageActionsContainer.addSubview(cancelButton)
        imageActionsContainer.addSubview(rightContainerStackView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        bottomTextViewContainerBottomConstraints = bottomMessageBoxView.bottomAnchor.constraint(equalTo: imageViewCarouselContainer.topAnchor)
        bottomTextViewContainerBottomConstraints?.isActive = true
        NSLayoutConstraint.activate([
            imageActionsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageActionsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageActionsContainer.heightAnchor.constraint(equalToConstant: 74),
            imageActionsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rightContainerStackView.centerYAnchor.constraint(equalTo: imageActionsContainer.centerYAnchor),
            rightContainerStackView.trailingAnchor.constraint(equalTo: imageActionsContainer.trailingAnchor, constant: -12),
            cancelButton.centerYAnchor.constraint(equalTo: imageActionsContainer.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: imageActionsContainer.leadingAnchor, constant: 12),
            zoomableImageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zoomableImageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zoomableImageViewContainer.topAnchor.constraint(equalTo: imageActionsContainer.bottomAnchor),
            zoomableImageViewContainer.bottomAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor),
            
            videoImageViewContainer.leadingAnchor.constraint(equalTo: zoomableImageViewContainer.leadingAnchor),
            videoImageViewContainer.trailingAnchor.constraint(equalTo: zoomableImageViewContainer.trailingAnchor),
            videoImageViewContainer.topAnchor.constraint(equalTo: imageActionsContainer.bottomAnchor),
            videoImageViewContainer.bottomAnchor.constraint(equalTo: zoomableImageViewContainer.bottomAnchor),
            
            audioPlayer.leadingAnchor.constraint(equalTo: zoomableImageViewContainer.leadingAnchor),
            audioPlayer.trailingAnchor.constraint(equalTo: zoomableImageViewContainer.trailingAnchor),
            audioPlayer.topAnchor.constraint(equalTo: imageActionsContainer.bottomAnchor),
            audioPlayer.bottomAnchor.constraint(equalTo: zoomableImageViewContainer.bottomAnchor),
            
            mediaDetailLabelContainerStackView.leadingAnchor.constraint(equalTo: zoomableImageViewContainer.leadingAnchor),
            mediaDetailLabelContainerStackView.trailingAnchor.constraint(equalTo: zoomableImageViewContainer.trailingAnchor),
            mediaDetailLabelContainerStackView.bottomAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor),
            
            imageViewCarouselContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageViewCarouselContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageViewCarouselContainer.heightAnchor.constraint(equalToConstant: 70),
            imageViewCarouselContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomMessageBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMessageBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        imageViewCarouselContainer.pinSubView(subView: mediaCollectionView, padding: .init(top: 0, left: 6, bottom: 0, right: -6))
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        view.backgroundColor = backgroundColor
    }
    
    @objc
    open override func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.bottomTextViewContainerBottomConstraints?.isActive = false
        self.bottomTextViewContainerBottomConstraints?.constant = -((frame.size.height - self.view.safeAreaInsets.bottom) - 70)
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
    
    @objc open func editingImage(_ sender: UIButton?) {
        guard let currentImage = viewModel?.selectedMedia?.photo else { return }
        editImage(currentImage, editModel: nil)
    }
    
    @objc open func deleteMediaData(_ sender: UIButton?) {
        guard let index = viewModel?.mediaCellData.firstIndex(where: {$0.localPath == self.viewModel?.selectedMedia?.localPath}) else { return }
        deleteMedia(atIndex: index)
        let afterDeleteIndex = index - 1
        if let cellData = viewModel?.mediaCellData, !cellData.isEmpty, cellData.count > afterDeleteIndex {
            let currentIndex = afterDeleteIndex < 0 ? 0 : afterDeleteIndex
            setDataToView(cellData[currentIndex])
        } else {
            cancelEditing(nil)
        }
    }
    
    func deleteMedia(atIndex index: Int) {
        guard (viewModel?.mediaCellData.count ?? 0) > index else { return }
        let attachment = viewModel?.mediaCellData.remove(at: index)
        do {
            if let localFilePath = attachment?.localPath {
                try FileManager.default.removeItem(at: localFilePath)
            }
        } catch {
            print("Error deleting file: \(error)")
        }
    }
    
    @objc open func cancelEditing(_ sender: UIButton?) {
        if let media = viewModel?.mediaCellData {
            for index in 0..<media.count {
                deleteMedia(atIndex: index)
            }
        }
        guard let _ = self.navigationController?.popViewController(animated: true) else {
            self.dismiss(animated: true)
            return
        }
    }
    
    func editImage(_ image: UIImage, editModel: LMEditImageModel?) {
        LMEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: editModel) { [weak self] resImage, editModel in
            self?.zoomableImageViewContainer.configure(with: resImage)
            self?.viewModel?.selectedMedia?.photo = resImage
            self?.mediaCollectionView.reloadData()
        }
    }
}

// MARK: UICollectionView
extension LMChatAttachmentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel?.mediaCellData.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let data = viewModel?.mediaCellData[indexPath.row] {
            switch data.mediaType {
            case .audio:
                if let cell = collectionView.dequeueReusableCell(with: LMChatAudioCarouselCell.self, for: indexPath) {
                    cell.setData(with: .init(image: data.photo, fileUrl: data.localPath, fileType: data.mediaType.rawValue, thumbnailUrl: data.thumnbailLocalPath, isSelected: true, duration: data.duration))
                    return cell
                }
            default:
                if let cell = collectionView.dequeueReusableCell(with: LMChatMediaCarouselCell.self, for: indexPath) {
                    cell.setData(with: .init(image: data.photo, fileUrl: data.localPath, fileType: data.mediaType.rawValue, thumbnailUrl: data.thumnbailLocalPath, isSelected: true))
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 64, height: 64)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let data = viewModel?.mediaCellData[indexPath.row],
           let cell = collectionView.dequeueReusableCell(with: LMChatMediaCarouselCell.self, for: indexPath) {
            setDataToView(data)
        }
    }
    
    func setDataToView(_ data: MediaPickerModel) {
        viewModel?.selectedMedia = data
        videoImageViewContainer.isHidden = true
        zoomableImageViewContainer.isHidden = true
        editButton.isHidden = true
        audioPlayer.isHidden = true
        switch data.mediaType {
        case .image, .gif:
            bottomMessageBoxView.attachmentButton.isHidden = data.mediaType == .gif
            editButton.isHidden = data.mediaType == .gif
            zoomableImageViewContainer.isHidden = false
            self.zoomableImageViewContainer.zoomScale = 1
            if data.mediaType == .gif {
                self.zoomableImageViewContainer.configure(with: data.url)
            } else {
                self.zoomableImageViewContainer.configure(with: data.photo)
            }
        case .video:
            bottomMessageBoxView.attachmentButton.isHidden = false
            videoImageViewContainer.isHidden = false
            videoImageViewContainer.configure(with: .init(mediaURL: data.url?.absoluteString ?? "", thumbnailURL: data.thumnbailLocalPath?.absoluteString ?? "", isVideo: true)) { [weak self] in
                self?.navigateToVideoPlayer(with: data.url?.absoluteString ?? "")
            }
        case .pdf:
            zoomableImageViewContainer.isHidden = false
            self.zoomableImageViewContainer.zoomScale = 1
            self.zoomableImageViewContainer.zoomFeatureEnable = false
            self.zoomableImageViewContainer.configure(with: data.thumnbailLocalPath)
            self.bottomMessageBoxView.attachmentButton.isHidden = false
            self.bottomMessageBoxView.attachmentButton.setImage(Constants.shared.images.docPlusIcon.withSystemImageConfig(pointSize: 25), for: .normal)
            self.fileNameLabel.text = data.name
            self.fileDetailLabel.text = "\(data.numberOfPages ?? 0) pages \(Constants.shared.strings.dot) \(FileUtils.fileSizeInMBOrKB(size: data.fileSize) ?? "") \(Constants.shared.strings.dot) \(data.mediaType.rawValue)"
        case .audio:
            audioPlayer.isHidden = false
            self.bottomMessageBoxView.attachmentButton.isHidden = false
            self.bottomMessageBoxView.attachmentButton.setImage(Constants.shared.images.audioIcon.withSystemImageConfig(pointSize: 25), for: .normal)
            audioPlayer.url = data.url?.absoluteString ?? ""
        default:
            editButton.isHidden = true
        }
        mediaCollectionView.reloadData()
    }
    
    func navigateToVideoPlayer(with url: String) {
        guard let videoURL = URL(string: url) else {
            showErrorAlert(message: "Unable to play video")
            return
        }
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.allowsPictureInPicturePlayback = false
        playerViewController.showsPlaybackControls = true
        present(playerViewController, animated: false) {
            player.play()
        }
    }
}

extension LMChatAttachmentViewController: LMChatAttachmentViewModelProtocol {
    
}

extension LMChatAttachmentViewController: LMAttachmentBottomMessageDelegate {
    
    public func addMoreAttachment() {
        switch self.viewModel?.mediaType {
        case .pdf:
            MediaPickerManager.shared.presentAudioAndDocumentPicker(viewController: self, delegate: self, fileType: .pdf)
        case .audio:
            MediaPickerManager.shared.presentAudioAndDocumentPicker(viewController: self, delegate: self, fileType: .audio)
        default:
            MediaPickerManager.shared.presentPicker(viewController: self, delegate: self)
        }
    }
    
    public func addGifAttachment() {
//        MediaPickerManager.shared.presentGifPicker(viewController: self, delegate: self, fileType: .gif)
    }
    
    public func sendAttachment(message: String?) {
        if viewModel?.mediaType == .audio {
            audioPlayer.stopPlaying()
        }
        delegate?.postConversationWithAttchments(message: message, attachments: viewModel?.mediaCellData ?? [])
        self.dismissViewController()
    }
}

extension LMChatAttachmentViewController: MediaPickerDelegate {
    
    func mediaPicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty || !(viewModel?.mediaCellData ?? []).isEmpty else {
            cancelEditing(nil)
            return
        }
        viewModel?.mediaCellData.append(contentsOf: results)
        viewModel?.mediaCellData = (viewModel?.mediaCellData ?? []).unique(map: {$0.localPath})
        
        mediaCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.zoomableImageViewContainer.imageView.image == nil, let item = results.first {
                self.viewModel?.selectedMedia = item
                self.setDataToView(item)
            }
        }
    }
}

extension LMChatAttachmentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[.mediaURL] as? URL, let localPath = MediaPickerManager.shared.createLocalURLfromPickedAssetsUrl(url: videoURL) {
            viewModel?.mediaCellData.append(.init(with: localPath, type: .video))
        } else if let imageUrl = info[.imageURL] as? URL, let localPath = MediaPickerManager.shared.createLocalURLfromPickedAssetsUrl(url: imageUrl) {
            viewModel?.mediaCellData.append(.init(with: localPath, type: .image))
        } else if let capturedImage = info[.originalImage] as? UIImage, let localPath = MediaPickerManager.shared.saveImageIntoDirecotry(image: capturedImage) {
            viewModel?.mediaCellData.append(.init(with: localPath, type: .image))
        }
        mediaPicker(picker, didFinishPicking: viewModel?.mediaCellData ?? [])
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension LMChatAttachmentViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        var results: [MediaPickerModel] = []
        for item in urls {
            guard let localPath = MediaPickerManager.shared.createLocalURLfromPickedAssetsUrl(url: item) else { continue }
            switch MediaPickerManager.shared.fileTypeForDocument {
            case .audio:
                if let mediaDeatil = FileUtils.getDetail(forVideoUrl: localPath) {
                    let mediaModel = MediaPickerModel(with: localPath, type: .audio, thumbnailPath: mediaDeatil.thumbnailUrl)
                    mediaModel.duration = mediaDeatil.duration
                    mediaModel.fileSize = Int(mediaDeatil.fileSize ?? 0)
                    results.append(mediaModel)
                }
            case .pdf:
                if let pdfDetail = FileUtils.getDetail(forPDFUrl: localPath) {
                    let mediaModel = MediaPickerModel(with: localPath, type: .pdf, thumbnailPath: pdfDetail.thumbnailUrl)
                    mediaModel.numberOfPages = pdfDetail.pageCount
                    mediaModel.fileSize = Int(pdfDetail.fileSize ?? 0)
                    results.append(mediaModel)
                }
            default:
                continue
            }
        }
        
        guard !results.isEmpty || !(viewModel?.mediaCellData ?? []).isEmpty else {
            cancelEditing(nil)
            return
        }
        viewModel?.mediaCellData.append(contentsOf: results)
        viewModel?.mediaCellData = (viewModel?.mediaCellData ?? []).unique(map: {$0.localPath})
        
        mediaCollectionView.reloadData()
    }
}
