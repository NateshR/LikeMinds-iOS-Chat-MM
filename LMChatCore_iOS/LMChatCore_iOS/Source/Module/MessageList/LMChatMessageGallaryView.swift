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
        public let fileSize: Int64?
        public let duration: Int?
        public let fileType: String?
        public let fileName: String?
    }
    
    /// Content the gallery should display.
    public var content: [UIView] = []
    
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
    
    open private(set) lazy var itemSpot0: ImagePreview = {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.cornerRadius(with: 12)
        return imagePreview
    }()
    
    open private(set) lazy var itemSpot1: ImagePreview = {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.cornerRadius(with: 12)
        return imagePreview
    }()
    
    open private(set) lazy var itemSpot2: ImagePreview = {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.cornerRadius(with: 12)
        return imagePreview
    }()
    
    open private(set) lazy var itemSpot3: ImagePreview = {
        let imagePreview = ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
        imagePreview.backgroundColor = .black
        imagePreview.addSubviewWithDefaultConstraints(moreItemsOverlay)
        imagePreview.cornerRadius(with: 12)
        return imagePreview
    }()
    
    /// Overlay to be displayed when `content` contains more items than the gallery can display.
    public private(set) lazy var moreItemsOverlay: LMLabel = {
        let label = LMLabel()
            .translatesAutoresizingMaskIntoConstraints()
        label.textColor = Appearance.shared.colors.white
        label.textAlignment = .center
        label.backgroundColor = .gray.withAlphaComponent(0.6)
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
    
    // MARK: - Overrides
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        pinSubView(subView:previewsContainerView)
        
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(previewsContainerView)
        
        previewsContainerView.addArrangedSubview(topPreviewsContainerView)
        
        topPreviewsContainerView.addArrangedSubview(itemSpots[0])
        topPreviewsContainerView.addArrangedSubview(itemSpots[1])
        
        previewsContainerView.addArrangedSubview(bottomPreviewsContainerView)
        
        bottomPreviewsContainerView.addArrangedSubview(itemSpots[2])
        bottomPreviewsContainerView.addArrangedSubview(itemSpots[3])
    }
        
    override open func setupAppearance() {
        super.setupAppearance()
        
//        moreItemsOverlay.font = appearance.fonts.title
//        moreItemsOverlay.adjustsFontForContentSizeCategory = true
//        moreItemsOverlay.textAlignment = .center
//        moreItemsOverlay.textColor = appearance.colorPalette.staticColorText
//        moreItemsOverlay.backgroundColor = appearance.colorPalette.background5
    }
    func setData(_ data: [ContentModel]) {
        itemSpots.forEach({$0.isHidden = true})
        bottomPreviewsContainerView.isHidden = data.count < 2
        for (index, item) in data.enumerated() {
            if index > 3 { break }
            guard let imageUrl = item.thumbnailUrl ?? item.fileUrl else {
                return
            }
            itemSpots[index].isHidden = false
            itemSpots[index].setData(imageUrl)
        }
    }
    
}

extension LMChatMessageGallaryView {
    
    open class ImagePreview: LMView {
        
        // MARK: - Subviews
        
        public private(set) lazy var imageView: LMImageView = {
            let imageView = LMImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            imageView.image = UIImage(systemName: "photo")
            imageView.backgroundColor = .black
            return imageView
                .translatesAutoresizingMaskIntoConstraints()
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
        }
        
        func setData(_ url: String) {
            imageView.kf.setImage(with: URL(string: url), placeholder: Constants.shared.images.placeholderImage)
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
