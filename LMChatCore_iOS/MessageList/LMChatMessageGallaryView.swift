//
//  LMChatMessageGallaryView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 02/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMChatMessageGallaryView: LMView {
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
    
    open private(set) lazy var itemSpot0: LMView = {
        let view = LMView()
            .translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 12)
        return view
    }()
    
    open private(set) lazy var itemSpot1: LMView = {
        let view = LMView()
            .translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 12)
        return view
    }()
    
    open private(set) lazy var itemSpot2: LMView = {
        let view = LMView()
            .translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 12)
        return view
    }()
    
    open private(set) lazy var itemSpot3: LMView = {
        let view = LMView()
            .translatesAutoresizingMaskIntoConstraints()
        view.cornerRadius(with: 12)
        return view
    }()
    
    /// Overlay to be displayed when `content` contains more items than the gallery can display.
    public private(set) lazy var moreItemsOverlay = LMLabel()
        .translatesAutoresizingMaskIntoConstraints()
    
    /// Container holding all previews.
    open private(set) lazy var previewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.alignment = .fill
        view.spacing = 2
        view.isLayoutMarginsRelativeArrangement = true
//        view.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        return view
    }()
    
    /// Left container for previews.
    public private(set) lazy var leftPreviewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.spacing = 1
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    /// Right container for previews.
    public private(set) lazy var rightPreviewsContainerView: LMStackView = {
        let view = LMStackView().translatesAutoresizingMaskIntoConstraints()
        view.spacing = 1
        view.axis = .vertical
        view.distribution = .fillEqually
        view.alignment = .fill
        return view
    }()
    
    // MARK: - Overrides
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        pinSubView(subView:previewsContainerView)
        previewsContainerView.addArrangedSubview(leftPreviewsContainerView)
        
        leftPreviewsContainerView.addArrangedSubview(itemSpots[0])
        leftPreviewsContainerView.addArrangedSubview(itemSpots[2])
        
        previewsContainerView.addArrangedSubview(rightPreviewsContainerView)
        
        rightPreviewsContainerView.addArrangedSubview(itemSpots[1])
        rightPreviewsContainerView.addArrangedSubview(itemSpots[3])
        
        addSubview(moreItemsOverlay)
        moreItemsOverlay.pinSubView(subView: itemSpots[3])
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(previewsContainerView)
        itemSpots[0].addSubviewWithDefaultConstraints(createImagePreview())
        itemSpots[1].addSubviewWithDefaultConstraints(createImagePreview())
        itemSpots[2].addSubviewWithDefaultConstraints(createImagePreview())
        itemSpots[3].addSubviewWithDefaultConstraints(createImagePreview())
//        itemSpots[3].isHidden = true
//        itemSpots[2].isHidden = true
//        rightPreviewsContainerView.isHidden = true
    }
        
    override open func setupAppearance() {
        super.setupAppearance()
        
//        moreItemsOverlay.font = appearance.fonts.title
//        moreItemsOverlay.adjustsFontForContentSizeCategory = true
//        moreItemsOverlay.textAlignment = .center
//        moreItemsOverlay.textColor = appearance.colorPalette.staticColorText
//        moreItemsOverlay.backgroundColor = appearance.colorPalette.background5
    }
    
    func createImagePreview() -> ImagePreview {
        let imagePreview =  ImagePreview()
            .translatesAutoresizingMaskIntoConstraints()
//        imagePreview.backgroundColor = .green
        return imagePreview
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
