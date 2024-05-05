//
//  LMChatAttachmentViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 13/03/24.
//

import Foundation
import LMChatUI_iOS

public protocol LMChatAttachmentViewDelegate: AnyObject {
    func postConversationWithAttchments(message: String?, attachments: [MediaPickerModel])
}

open class LMChatAttachmentViewController: LMViewController {
    
    let backgroundColor: UIColor = .black
    weak var delegate: LMChatAttachmentViewDelegate?
    
    open private(set) lazy var bottomMessageBoxView: LMAttachmentBottomMessageView = {
        let view = LMAttachmentBottomMessageView().translatesAutoresizingMaskIntoConstraints()
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
    
    open private(set) lazy var zoomableImageViewContainer: LMZoomImageViewContainer = {
        let view = LMZoomImageViewContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = backgroundColor
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
        button.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
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
        collection.registerCell(type: LMMediaCarouselCell.self)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    public var viewModel: LMChatAttachmentViewModel?
    var bottomTextViewContainerBottomConstraints: NSLayoutConstraint?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        setupAppearance()
        openPicker()
        bottomMessageBoxView.inputTextView.chatroomId = viewModel?.chatroomId ?? ""
    }
    
    func openPicker() {
        if let cellData = viewModel?.mediaCellData, !cellData.isEmpty {
            mediaCollectionView.reloadData()
            editButton.isHidden = true
            bottomMessageBoxView.attachmentButton.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.zoomableImageViewContainer.imageView.image == nil {
                    self.viewModel?.selectedMedia = cellData[0]
                    self.zoomableImageViewContainer.configure(with: cellData[0].url)
                }
            }
        } else {
            addMoreAttachment()
        }
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        self.view.addSubview(imageActionsContainer)
        self.view.addSubview(zoomableImageViewContainer)
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
            imageActionsContainer.heightAnchor.constraint(equalToConstant: 54),
            imageActionsContainer.topAnchor.constraint(equalTo: view.topAnchor),
            rightContainerStackView.centerYAnchor.constraint(equalTo: imageActionsContainer.centerYAnchor),
            rightContainerStackView.trailingAnchor.constraint(equalTo: imageActionsContainer.trailingAnchor, constant: -12),
            cancelButton.centerYAnchor.constraint(equalTo: imageActionsContainer.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: imageActionsContainer.leadingAnchor, constant: 12),
            zoomableImageViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            zoomableImageViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            zoomableImageViewContainer.topAnchor.constraint(equalTo: imageActionsContainer.bottomAnchor),
            zoomableImageViewContainer.bottomAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor),
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
        view.backgroundColor = .white
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
    
    @objc open func deleteImage(_ sender: UIButton?) {
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
        }
    }
}

// MARK: UICollectionView
extension LMChatAttachmentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel?.mediaCellData.count ?? 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let data = viewModel?.mediaCellData[indexPath.row],
           let cell = collectionView.dequeueReusableCell(with: LMMediaCarouselCell.self, for: indexPath) {
            cell.setData(with: .init(image: data.photo, fileUrl: data.localPath, fileType: data.mediaType.rawValue, thumbnailUrl: data.thumnbailLocalPath, isSelected: true))
            return cell
        }
        return UICollectionViewCell()
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 64, height: 64)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let data = viewModel?.mediaCellData[indexPath.row],
           let cell = collectionView.dequeueReusableCell(with: LMMediaCarouselCell.self, for: indexPath) {
            collectionView.reloadData()
            cell.imageView.borderColor(withBorderWidth: 2, with: .green)
            setDataToView(data)
        }
    }
    
    func setDataToView(_ data: MediaPickerModel) {
        viewModel?.selectedMedia = data
        switch data.mediaType {
        case .image, .gif:
            self.zoomableImageViewContainer.zoomScale = 1
            self.zoomableImageViewContainer.configure(with: data.photo)
        case .video:
            break
        default:
            break
        }
    }
}

extension LMChatAttachmentViewController: LMChatAttachmentViewModelProtocol {
    
}

extension LMChatAttachmentViewController: LMAttachmentBottomMessageDelegate {
    
    public func addMoreAttachment() {
        MediaPickerManager.shared.presentPicker(viewController: self, delegate: self)
    }
    
    public func addGifAttachment() {
        MediaPickerManager.shared.presentGifPicker(viewController: self, delegate: self, fileType: .gif)
    }
    
    public func sendAttachment(message: String?) {
        delegate?.postConversationWithAttchments(message: message, attachments: viewModel?.mediaCellData ?? [])
        self.dismissViewController()
    }
}

extension LMChatAttachmentViewController: MediaPickerDelegate {
    
    func mediaPicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel]) {
        guard !results.isEmpty || !(viewModel?.mediaCellData ?? []).isEmpty else {
            picker.dismiss(animated: true)
            cancelEditing(nil)
            return
        }
        viewModel?.mediaCellData = results
        mediaCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.zoomableImageViewContainer.imageView.image == nil {
                self.viewModel?.selectedMedia = results[0]
                self.zoomableImageViewContainer.configure(with: results[0].photo)
            }
        }
    }
}
