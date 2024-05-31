//
//  LMImageEditorConfiguration.swift
//  LMImageEditor
//
//  Created by long on 2020/11/23.
//
//  Copyright (c) 2020 Long Zhang <495181165@qq.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

public class LMImageEditorConfiguration: NSObject {
    private static var single = LMImageEditorConfiguration()
    
    private static let defaultColors: [UIColor] = [
        .white,
        .black,
        .lm.rgba(249, 80, 81),
        .lm.rgba(248, 156, 59),
        .lm.rgba(255, 195, 0),
        .lm.rgba(145, 211, 0),
        .lm.rgba(0, 193, 94),
        .lm.rgba(16, 173, 254),
        .lm.rgba(16, 132, 236),
        .lm.rgba(99, 103, 240),
        .lm.rgba(127, 127, 127)
    ]
    
    @objc public class func `default`() -> LMImageEditorConfiguration {
        return LMImageEditorConfiguration.single
    }
    
    @objc public class func resetConfiguration() {
        LMImageEditorConfiguration.single = LMImageEditorConfiguration()
    }
    
    private var pri_tools: [LMImageEditorConfiguration.EditTool] = [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust]
    /// Edit image tools. (Default order is draw, clip, imageSticker, textSticker, mosaic, filtter)
    /// Because Objective-C Array can't contain Enum styles, so this property is not available in Objective-C.
    /// - warning: If you want to use the image sticker feature, you must provide a view that implements LMImageStickerContainerDelegate.
    public var tools: [LMImageEditorConfiguration.EditTool] {
        get {
            if pri_tools.isEmpty {
                return [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust]
            } else {
                return pri_tools
            }
        }
        set {
            pri_tools = newValue
        }
    }
    
    private var pri_drawColors = LMImageEditorConfiguration.defaultColors
    /// Draw colors for image editor.
    @objc public var drawColors: [UIColor] {
        get {
            if pri_drawColors.isEmpty {
                return LMImageEditorConfiguration.defaultColors
            } else {
                return pri_drawColors
            }
        }
        set {
            pri_drawColors = newValue
        }
    }
    
    /// The default draw color. If this color not in editImageDrawColors, will pick the first color in editImageDrawColors as the default.
    @objc public var defaultDrawColor: UIColor = .lm.rgba(249, 80, 81)
    
    private var pri_clipRatios: [LMImageClipRatio] = [.custom]
    /// Edit ratios for image editor.
    @objc public var clipRatios: [LMImageClipRatio] {
        get {
            if pri_clipRatios.isEmpty {
                return [.custom]
            } else {
                return pri_clipRatios
            }
        }
        set {
            pri_clipRatios = newValue
        }
    }
    
    private var pri_textStickerTextColors = LMImageEditorConfiguration.defaultColors
    /// Text sticker colors for image editor.
    @objc public var textStickerTextColors: [UIColor] {
        get {
            if pri_textStickerTextColors.isEmpty {
                return LMImageEditorConfiguration.defaultColors
            } else {
                return pri_textStickerTextColors
            }
        }
        set {
            pri_textStickerTextColors = newValue
        }
    }
    
    /// The default text sticker color. If this color not in textStickerTextColors, will pick the first color in textStickerTextColors as the default.
    @objc public var textStickerDefaultTextColor = UIColor.white
    
    /// The default font of text sticker.
    /// - Note: This property is ignored when using fontChooserContainerView.
    @objc public var textStickerDefaultFont: UIFont?
    
    /// Whether text sticker allows line break.
    @objc public var textStickerCanLineBreak = false
    
    private var pri_filters: [LMFilter] = LMFilter.all
    /// Filters for image editor.
    @objc public var filters: [LMFilter] {
        get {
            if pri_filters.isEmpty {
                return LMFilter.all
            } else {
                return pri_filters
            }
        }
        set {
            pri_filters = newValue
        }
    }
    
    @objc public var imageStickerContainerView: (UIView & LMImageStickerContainerDelegate)?

    @objc public var fontChooserContainerView: (UIView & LMTextFontChooserDelegate)?

    private var pri_adjustTools: [LMImageEditorConfiguration.AdjustTool] = [.brightness, .contrast, .saturation]
    /// Adjust image tools. (Default order is brightness, contrast, saturation)
    /// Valid when the tools contain EditTool.adjust
    /// Because Objective-C Array can't contain Enum styles, so this property is invalid in Objective-C.
    public var adjustTools: [LMImageEditorConfiguration.AdjustTool] {
        get {
            if pri_adjustTools.isEmpty {
                return [.brightness, .contrast, .saturation]
            } else {
                return pri_adjustTools
            }
        }
        set {
            pri_adjustTools = newValue
        }
    }
    
    private var pri_impactFeedbackWhenAdjustSliderValueIsZero = true
    /// Give an impact feedback when the adjust slider value is zero. Defaults to true.
    @available(iOS 10.0, *)
    @objc public var impactFeedbackWhenAdjustSliderValueIsZero: Bool {
        get {
            return pri_impactFeedbackWhenAdjustSliderValueIsZero
        }
        set {
            pri_impactFeedbackWhenAdjustSliderValueIsZero = newValue
        }
    }
    
    private var pri_impactFeedbackStyle: LMImageEditorConfiguration.FeedbackStyle = .medium
    /// Impact feedback style. Defaults to .medium
    @available(iOS 10.0, *)
    @objc public var impactFeedbackStyle: LMImageEditorConfiguration.FeedbackStyle {
        get {
            return pri_impactFeedbackStyle
        }
        set {
            pri_impactFeedbackStyle = .medium
        }
    }
    
    /// If image edit tools only has clip and this property is true. When you click edit, the cropping interface (i.e. LMClipImageViewController) will be displayed. Defaults to false
    @objc public var showClipDirectlyIfOnlyHasClipTool = false
}

public extension LMImageEditorConfiguration {
    @objc enum EditTool: Int {
        case draw
        case clip
        case imageSticker
        case textSticker
        case mosaic
        case filter
        case adjust
    }
    
    @objc enum AdjustTool: Int {
        case brightness
        case contrast
        case saturation
        
        var key: String {
            switch self {
            case .brightness:
                return kCIInputBrightnessKey
            case .contrast:
                return kCIInputContrastKey
            case .saturation:
                return kCIInputSaturationKey
            }
        }
        
        func filterValue(_ value: Float) -> Float {
            switch self {
            case .brightness:
                // 亮度范围-1---1，默认0，这里除以3，取 -0.33---0.33
                return value / 3
            case .contrast:
                // 对比度范围0---4，默认1，这里计算下取0.5---2.5
                let v: Float
                if value < 0 {
                    v = 1 + value * (1 / 2)
                } else {
                    v = 1 + value * (3 / 2)
                }
                return v
            case .saturation:
                // 饱和度范围0---2，默认1
                return value + 1
            }
        }
    }
    
    @objc enum FeedbackStyle: Int {
        case light
        case medium
        case heavy
        
        @available(iOS 10.0, *)
        var uiFeedback: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light:
                return .light
            case .medium:
                return .medium
            case .heavy:
                return .heavy
            }
        }
    }
}

// MARK: Clip ratio.

public class LMImageClipRatio: NSObject {
    @objc public var title: String
    
    @objc public let whRatio: CGFloat
    
    @objc public let isCircle: Bool
    
    @objc public init(title: String, whRatio: CGFloat, isCircle: Bool = false) {
        self.title = title
        self.whRatio = isCircle ? 1 : whRatio
        self.isCircle = isCircle
        super.init()
    }
}

extension LMImageClipRatio {
    static func == (lhs: LMImageClipRatio, rhs: LMImageClipRatio) -> Bool {
        return lhs.whRatio == rhs.whRatio
    }
}

public extension LMImageClipRatio {
    @objc static let custom = LMImageClipRatio(title: "custom", whRatio: 0)
    
    @objc static let circle = LMImageClipRatio(title: "circle", whRatio: 1, isCircle: true)
    
    @objc static let wh1x1 = LMImageClipRatio(title: "1 : 1", whRatio: 1)
    
    @objc static let wh3x4 = LMImageClipRatio(title: "3 : 4", whRatio: 3.0 / 4.0)
    
    @objc static let wh4x3 = LMImageClipRatio(title: "4 : 3", whRatio: 4.0 / 3.0)
    
    @objc static let wh2x3 = LMImageClipRatio(title: "2 : 3", whRatio: 2.0 / 3.0)
    
    @objc static let wh3x2 = LMImageClipRatio(title: "3 : 2", whRatio: 3.0 / 2.0)
    
    @objc static let wh9x16 = LMImageClipRatio(title: "9 : 16", whRatio: 9.0 / 16.0)
    
    @objc static let wh16x9 = LMImageClipRatio(title: "16 : 9", whRatio: 16.0 / 9.0)
}

/// Provide an image sticker container view that conform to this protocol must be a subclass of UIView
@objc public protocol LMImageStickerContainerDelegate {
    @objc var selectImageBlock: ((UIImage) -> Void)? { get set }
    
    @objc var hideBlock: (() -> Void)? { get set }
    
    @objc func show(in view: UIView)
}

/// Provide an text font choose view that conform to this protocol must be a subclass of UIView
@objc public protocol LMTextFontChooserDelegate {
    @objc var selectFontBlock: ((UIFont) -> Void)? { get set }

    @objc var hideBlock: (() -> Void)? { get set }

    @objc func show(in view: UIView)
}
