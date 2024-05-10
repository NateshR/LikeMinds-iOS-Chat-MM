//
//  LMChatMessageGallaryView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 02/04/24.
//

import Foundation
import Kingfisher
import LMChatUI_iOS

public protocol ChatMessageAttachment {}

open class LMChatMessageGallaryView: LMView {
    
    struct ContentModel {
        public let fileUrl: String?
        public let thumbnailUrl: String?
        public let fileSize: Int?
        public let duration: Int?
        public let fileType: String?
        public let fileName: String?
    }
    
    /// Content the gallery should display.
    public var content: [UIView] = []
    
    let heightViewSize = UIScreen.main.bounds.width * 0.6
    let widthViewSize = UIScreen.main.bounds.width * 0.7
    
    // Previews indices locations:
    // When one item available:
    // -------
    // |     |
    // |  0  |
    // |     |
    // -------
    // When two items available:
    // -------------
    // |     |     |
    // |  0  |  1  |
    // |     |     |
    // -------------
    // When three items available:
    // -------------
    // |     |     |
    // |  0  |     |
    // |     |     |
    // ------|  1  |
    // |     |     |
    // |  2  |     |
    // |     |     |
    // -------------
    // When four and more items available:
    // -------------
    // |     |     |
    // |  0  |  1  |
    // |     |     |
    // -------------
    // |     |     |
    // |  2  |  3  |
    // |     |     |
    // -------------
    /// The spots gallery items takes.
    public private(set) lazy var itemSpots = [
        itemSpot0,
        itemSpot1,
        itemSpot2,
        itemSpot3
    ]
    
    open private(set) lazy var singleImage: ImagePreview = {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.cornerRadius(with: 12)
        imagePreview.tag = 0
        imagePreview.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onAttachmentClicked))
        tapGuesture.numberOfTapsRequired = 1
        imagePreview.addGestureRecognizer(tapGuesture)
        imagePreview.widthAnchor.constraint(equalToConstant: widthViewSize).isActive = true
        let aspectRatioConstraints = NSLayoutConstraint(item: imagePreview, attribute: .width, relatedBy: .lessThanOrEqual, toItem: imagePreview, attribute: .height, multiplier: 1.4, constant: 0)
        imagePreview.addConstraint(aspectRatioConstraints)
        imagePreview.heightAnchor.constraint(equalToConstant:  heightViewSize).isActive = true
        return imagePreview
    }()
    
    open private(set) lazy var itemSpot0: ImagePreview = {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.cornerRadius(with: 12)
        imagePreview.tag = 0
        imagePreview.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onAttachmentClicked))
        tapGuesture.numberOfTapsRequired = 1
        imagePreview.addGestureRecognizer(tapGuesture)
        imagePreview.widthAnchor.constraint(equalToConstant: widthViewSize/2).isActive = true
        let aspectRatioConstraints = NSLayoutConstraint(item: imagePreview, attribute: .width, relatedBy: .lessThanOrEqual, toItem: imagePreview, attribute: .height, multiplier: 1.4, constant: 0)
        imagePreview.addConstraint(aspectRatioConstraints)
        imagePreview.heightAnchor.constraint(equalToConstant:  heightViewSize/2).isActive = true
        return imagePreview
    }()
    
    open private(set) lazy var itemSpot1: ImagePreview = {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.cornerRadius(with: 12)
        imagePreview.tag = 1
        imagePreview.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onAttachmentClicked))
        tapGuesture.numberOfTapsRequired = 1
        imagePreview.addGestureRecognizer(tapGuesture)
        imagePreview.widthAnchor.constraint(equalToConstant: widthViewSize/2).isActive = true
        let aspectRatioConstraints = NSLayoutConstraint(item: imagePreview, attribute: .width, relatedBy: .lessThanOrEqual, toItem: imagePreview, attribute: .height, multiplier: 1.4, constant: 0)
        imagePreview.addConstraint(aspectRatioConstraints)
        imagePreview.heightAnchor.constraint(equalToConstant:  heightViewSize/2).isActive = true
        return imagePreview
    }()
    
    open private(set) lazy var itemSpot2: ImagePreview = {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.cornerRadius(with: 12)
        imagePreview.tag = 2
        imagePreview.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onAttachmentClicked))
        tapGuesture.numberOfTapsRequired = 1
        imagePreview.addGestureRecognizer(tapGuesture)
        imagePreview.widthAnchor.constraint(equalToConstant: widthViewSize/2).isActive = true
        let aspectRatioConstraints = NSLayoutConstraint(item: imagePreview, attribute: .width, relatedBy: .lessThanOrEqual, toItem: imagePreview, attribute: .height, multiplier: 1.4, constant: 0)
        imagePreview.addConstraint(aspectRatioConstraints)
        imagePreview.heightAnchor.constraint(equalToConstant:  heightViewSize/2).isActive = true
        return imagePreview
    }()
    
    open private(set) lazy var itemSpot3: ImagePreview = {
        let imagePreview = ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.addSubviewWithDefaultConstraints(moreItemsOverlay)
        imagePreview.cornerRadius(with: 12)
        imagePreview.tag = 3
        imagePreview.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onAttachmentClicked))
        tapGuesture.numberOfTapsRequired = 1
        imagePreview.addGestureRecognizer(tapGuesture)
        imagePreview.widthAnchor.constraint(equalToConstant: widthViewSize/2).isActive = true
        let aspectRatioConstraints = NSLayoutConstraint(item: imagePreview, attribute: .width, relatedBy: .lessThanOrEqual, toItem: imagePreview, attribute: .height, multiplier: 1.4, constant: 0)
        imagePreview.addConstraint(aspectRatioConstraints)
        imagePreview.heightAnchor.constraint(equalToConstant:  heightViewSize/2).isActive = true
        return imagePreview
    }()
    
    /// Overlay to be displayed when `content` contains more items than the gallery can display.
    public private(set) lazy var moreItemsOverlay: LMLabel = {
        let label = LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.textColor = Appearance.shared.colors.white
        label.textAlignment = .center
        label.font = Appearance.shared.fonts.headingFont1
        label.backgroundColor = .gray.withAlphaComponent(0.8)
        label.text = "+2"
        return label
    }()
    
    /// Container holding all previews.
    open private(set) lazy var previewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 4
        view.isLayoutMarginsRelativeArrangement = true
//        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    /// Left container for previews.
    public private(set) lazy var topPreviewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.spacing = 4
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    /// Right container for previews.
    public private(set) lazy var bottomPreviewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.spacing = 4
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    
    open private(set) lazy var loaderView: LMLoaderView = {
        let view = LMLoaderView().translatesAutoresizingMaskIntoConstraints()
        view.isHidden = true
        return view
    }()
    
    
    var viewData: [ContentModel]?
    var onClickAttachment: ((Int) -> Void)?
    
    // MARK: - Overrides
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        pinSubView(subView:previewsContainerView)
        loaderView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loaderView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(previewsContainerView)
        addSubview(loaderView)

        previewsContainerView.addArrangedSubview(topPreviewsContainerView)
        
        topPreviewsContainerView.addArrangedSubview(itemSpots[0])
        topPreviewsContainerView.addArrangedSubview(itemSpots[1])
        
        previewsContainerView.addArrangedSubview(bottomPreviewsContainerView)
        
        bottomPreviewsContainerView.addArrangedSubview(itemSpots[2])
        bottomPreviewsContainerView.addArrangedSubview(itemSpots[3])
        
        previewsContainerView.addArrangedSubview(singleImage)
    }
        
    override open func setupAppearance() {
        super.setupAppearance()
    }
    func setData(_ data: [ContentModel]) {
        viewData = data
        itemSpots.forEach({$0.isHidden = true})
        singleImage.isHidden = true
        if data.count == 1, let item = data.first {
            singleImage.isHidden = false
            topPreviewsContainerView.isHidden = true
            bottomPreviewsContainerView.isHidden = true
            loadImageData(item: item, imagePreview: singleImage)
            return
        } else {
            topPreviewsContainerView.isHidden = false
        }
        bottomPreviewsContainerView.isHidden = data.count < 3
        for (index, item) in data.enumerated() {
            if index > 3 {
                moreItemsOverlay.isHidden = false
                moreItemsOverlay.text =  "+\(data.count - 3)"
                break
            }
            moreItemsOverlay.isHidden = true
           loadImageData(item: item, imagePreview: itemSpots[index])
        }
    }
    
    func loadImageData(item: ContentModel, imagePreview: ImagePreview) {
        guard let imageUrl = item.thumbnailUrl ?? item.fileUrl else {
            return
        }
        
        imagePreview.isHidden = false
        
        if item.fileType == "video" {
            imagePreview.setData(imageUrl, withPlaceholder: nil)
            imagePreview.playIconImage.isHidden = false
        } else {
            imagePreview.setData(imageUrl)
            imagePreview.playIconImage.isHidden = true
        }
        
        
//        itemSpots[index].isHidden = false
//        
//        if item.fileType == "video" {
//            itemSpots[index].setData(imageUrl, withPlaceholder: nil)
//            itemSpots[index].playIconImage.isHidden = false
//        } else {
//            itemSpots[index].setData(imageUrl)
//            itemSpots[index].playIconImage.isHidden = true
//        }
    }
    
    @objc func onAttachmentClicked(_ gesture: UITapGestureRecognizer) {
//        viewData?.first?.fileType?.lowercased() != "gif", 
        guard let tag = gesture.view?.tag else { return }
        onClickAttachment?(tag)
    }
    
}

extension LMChatMessageGallaryView {
    
    open class ImagePreview: LMView {
        
        // MARK: - Subviews
        
        public private(set) lazy var imageView: LMImageView = {
            let imageView = LMImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.image = Constants.shared.images.galleryIcon
            imageView.backgroundColor = Appearance.shared.colors.black
            return imageView
                .translatesAutoresizingMaskIntoConstraints()
        }()
        
        open private(set) lazy var playIconImage: LMImageView = {
            let image = LMImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFill
            image.clipsToBounds = true
            image.backgroundColor = Appearance.shared.colors.white
            image.isUserInteractionEnabled = false
            image.image = Constants.shared.images.playCircleFilled
            image.setWidthConstraint(with: 40)
            image.setHeightConstraint(with: 40)
            image.cornerRadius(with: 20)
            image.tintColor = Appearance.shared.colors.black.withAlphaComponent(0.8)
            return image
        }()
        
//        public private(set) lazy var loadingIndicator = components
//            .loadingIndicator
//            .init()
//            .withoutAutoresizingMaskConstraints
//            .withAccessibilityIdentifier(identifier: "loadingIndicator")
//        
//        public private(set) lazy var uploadingOverlay = components
//            .uploadingOverlayView
//            .init()
//            .withoutAutoresizingMaskConstraints
//            .withAccessibilityIdentifier(identifier: "uploadingOverlay")
        
        // MARK: - Overrides
        
        override open func setupAppearance() {
            super.setupAppearance()
//            imageView.backgroundColor = appearance.colorPalette.background1
        }
        
        override open func setupViews() {
            super.setupViews()
            addSubview(imageView)
            addSubview(playIconImage)
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapOnAttachment(_:)))
//            addGestureRecognizer(tapRecognizer)
//            
//            uploadingOverlay.didTapActionButton = { [weak self] in
//                guard let self = self, let attachment = self.content else { return }
//                
//                self.didTapOnUploadingActionButton?(attachment)
//            }
        }
        
        override open func setupLayouts() {
            super.setupLayouts()
            pinSubView(subView: imageView)
            playIconImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            playIconImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        }
        
        func setData(_ url: String, withPlaceholder placeholder: UIImage? = UIImage(named: "imageplaceholder", in: LMChatCoreBundle, compatibleWith: nil)) {
            imageView.kf.setImage(with: URL(string: url), placeholder: placeholder)
        }
        
//        override open func updateContent() {
//            super.updateContent()
//            
//            let attachment = content
//            
//            loadingIndicator.isVisible = true
//            imageTask = components.imageLoader.loadImage(
//                into: imageView,
//                from: attachment?.payload,
//                maxResolutionInPixels: components.imageAttachmentMaxPixels
//            ) { [weak self] _ in
//                self?.loadingIndicator.isVisible = false
//                self?.imageTask = nil
//            }
//            
//            uploadingOverlay.content = content?.uploadingState
//            uploadingOverlay.isVisible = attachment?.uploadingState != nil
//        }
        
        // MARK: - Actions
        
//        @objc open func didTapOnAttachment(_ recognizer: UITapGestureRecognizer) {
//            guard let attachment = content else { return }
//            didTapOnAttachment?(attachment)
//        }
//        
//        // MARK: - Init & Deinit
//        
//        deinit {
//            imageTask?.cancel()
//        }
    }
}
