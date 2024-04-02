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
        LMView()
            .translatesAutoresizingMaskIntoConstraints(),
        LMView()
            .translatesAutoresizingMaskIntoConstraints(),
        LMView()
            .translatesAutoresizingMaskIntoConstraints(),
        LMView()
            .translatesAutoresizingMaskIntoConstraints()
    ]
    
    /// Overlay to be displayed when `content` contains more items than the gallery can display.
    public private(set) lazy var moreItemsOverlay = LMLabel()
        .translatesAutoresizingMaskIntoConstraints()
    
    /// Container holding all previews.
    public private(set) lazy var previewsContainerView = LMStackView()
        .translatesAutoresizingMaskIntoConstraints()
    
    /// Left container for previews.
    public private(set) lazy var leftPreviewsContainerView = LMStackView()
        .translatesAutoresizingMaskIntoConstraints()
    
    /// Right container for previews.
    public private(set) lazy var rightPreviewsContainerView = LMStackView()
        .translatesAutoresizingMaskIntoConstraints()
    
    // MARK: - Overrides
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        previewsContainerView.axis = .horizontal
        previewsContainerView.distribution = .equalCentering
        previewsContainerView.alignment = .fill
        previewsContainerView.spacing = 2
        previewsContainerView.isLayoutMarginsRelativeArrangement = true
        previewsContainerView.directionalLayoutMargins = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        pinSubView(subView:previewsContainerView)
        
        leftPreviewsContainerView.spacing = 2
        leftPreviewsContainerView.axis = .vertical
        leftPreviewsContainerView.distribution = .equalCentering
        leftPreviewsContainerView.alignment = .fill
        previewsContainerView.addArrangedSubview(leftPreviewsContainerView)
        
        leftPreviewsContainerView.addArrangedSubview(itemSpots[0])
        leftPreviewsContainerView.addArrangedSubview(itemSpots[2])
        
        rightPreviewsContainerView.spacing = 2
        rightPreviewsContainerView.axis = .vertical
        rightPreviewsContainerView.distribution = .equalCentering
        rightPreviewsContainerView.alignment = .fill
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
    }
        
    override open func setupAppearance() {
        super.setupAppearance()
        
//        moreItemsOverlay.font = appearance.fonts.title
//        moreItemsOverlay.adjustsFontForContentSizeCategory = true
//        moreItemsOverlay.textAlignment = .center
//        moreItemsOverlay.textColor = appearance.colorPalette.staticColorText
//        moreItemsOverlay.backgroundColor = appearance.colorPalette.background5
    }
    
}
