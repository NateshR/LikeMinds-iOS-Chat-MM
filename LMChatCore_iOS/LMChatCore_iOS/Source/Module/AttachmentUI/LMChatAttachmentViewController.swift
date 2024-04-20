//
//  LMChatAttachmentViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 13/03/24.
//

import Foundation
import LMChatUI_iOS

open class LMChatAttachmentViewController: LMViewController {
    
    let backgroundColor: UIColor = .black
    
    open private(set) lazy var bottomMessageBoxView: LMAttachmentBottomMessageView = {
        let view = LMAttachmentBottomMessageView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = backgroundColor
        view.delegate = self
        return view
    }()
    
    open private(set) lazy var imageViewCarouselContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = backgroundColor
        return view
    }()
    
    open private(set) lazy var imageActionsContainer: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = backgroundColor
        return view
    }()
    
    open private(set) lazy var zoomableImageViewContainer: ZoomImageViewContainer = {
        let view = ZoomImageViewContainer()
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
    
    open private(set) lazy var cancelButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.xmarkIcon.withSystemImageConfig(pointSize: 20, weight: .bold), for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.addTarget(self, action: #selector(cancelEditing), for: .touchUpInside)
        return button
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
        collection.backgroundColor = backgroundColor
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    public var viewmodel: LMChatAttachmentViewModel?
    public var mediaCellData: [MediaPickerModel] = []
    private var selectedMedia: MediaPickerModel?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        
        addMoreAttachment()
        
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
        imageActionsContainer.addSubview(editButton)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            imageActionsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageActionsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageActionsContainer.heightAnchor.constraint(equalToConstant: 54),
            imageActionsContainer.topAnchor.constraint(equalTo: view.topAnchor),
            editButton.centerYAnchor.constraint(equalTo: imageActionsContainer.centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: imageActionsContainer.trailingAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: imageActionsContainer.centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: imageActionsContainer.leadingAnchor),
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
            bottomMessageBoxView.bottomAnchor.constraint(equalTo: imageViewCarouselContainer.topAnchor),
        ])
        imageViewCarouselContainer.pinSubView(subView: mediaCollectionView)
    }
    
    @objc open func editingImage(_ sender: UIButton?) {
        guard let currentImage = selectedMedia?.photo else { return }
        editImage(currentImage, editModel: nil)
    }
    
    @objc open func cancelEditing(_ sender: UIButton?) {
        guard let _ = self.navigationController?.popViewController(animated: true) else {
            self.dismiss(animated: true)
            return
        }
    }
    
    func editImage(_ image: UIImage, editModel: LMEditImageModel?) {
        LMEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: editModel) { [weak self] resImage, editModel in
            self?.zoomableImageViewContainer.configure(with: resImage)
            self?.selectedMedia?.photo = resImage
        }
    }
}

// MARK: UICollectionView
extension LMChatAttachmentViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { mediaCellData.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = mediaCellData[indexPath.row]
        if let cell = collectionView.dequeueReusableCell(with: LMMediaCarouselCell.self, for: indexPath) {
            cell.setData(with: .init(image: data.photo, fileUrl: data.url))
            cell.onCellClick = { [weak self] in
                collectionView.reloadData()
                cell.imageView.borderColor(withBorderWidth: 2, with: .green)
                self?.zoomableImageViewContainer.zoomScale = 1
                self?.selectedMedia = data
//                self?.zoomableImageViewContainer.image = data.photo
                self?.zoomableImageViewContainer.configure(with: data.url)
            }
            return cell
        }
        return UICollectionViewCell()
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 64, height: 64)
    }
}

extension LMChatAttachmentViewController: LMChatAttachmentViewModelProtocol {
    
}

extension LMChatAttachmentViewController: LMAttachmentBottomMessageDelegate {
    
    public func addMoreAttachment() {
        MediaPickerManager.shared.presentPicker(viewController: self, delegate: self)
    }
    
    public func sendAttachment() {
        
    }
}

extension LMChatAttachmentViewController: MediaPickerDelegate {
    
    func mediaPicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel]) {
        guard !results.isEmpty || !mediaCellData.isEmpty else {
            picker.dismiss(animated: true)
            cancelEditing(nil)
            return
        }
        self.mediaCellData = results
        mediaCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            if self.zoomableImageViewContainer.image == nil {
//                self.zoomableImageViewContainer.image = self.mediaCellData[0].photo
//            }
        }
    }
}
