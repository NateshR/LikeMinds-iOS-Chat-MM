//
//  LMImageEditorUIConfiguration+Chaining.swift
//  LMImageEditor
//
//  Created by long on 2022/5/13.
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

public extension LMImageEditorUIConfiguration {
    @discardableResult
    func hudStyle(_ style: LMProgressHUD.HUDStyle) -> LMImageEditorUIConfiguration {
        hudStyle = style
        return self
    }
    
    @discardableResult
    func adjustSliderType(_ type: LMAdjustSliderType) -> LMImageEditorUIConfiguration {
        adjustSliderType = type
        return self
    }
    
    @discardableResult
    func customImageNames(_ names: [String]) -> LMImageEditorUIConfiguration {
        customImageNames = names
        return self
    }
    
    @discardableResult
    func customImageForKey(_ map: [String: UIImage?]) -> LMImageEditorUIConfiguration {
        customImageForKey = map
        return self
    }
    
    @discardableResult
    func adjustSliderNormalColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        adjustSliderNormalColor = color
        return self
    }
    
    @discardableResult
    func adjustSliderTintColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        adjustSliderTintColor = color
        return self
    }
    
    @discardableResult
    func editDoneBtnBgColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        editDoneBtnBgColor = color
        return self
    }
    
    @discardableResult
    func editDoneBtnTitleColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        editDoneBtnTitleColor = color
        return self
    }
    
    @discardableResult
    func ashbinNormalBgColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        ashbinNormalBgColor = color
        return self
    }
    
    @discardableResult
    func ashbinTintBgColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        ashbinTintBgColor = color
        return self
    }
    
    @discardableResult
    func toolTitleNormalColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        toolTitleNormalColor = color
        return self
    }
    
    @discardableResult
    func toolTitleTintColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        toolTitleTintColor = color
        return self
    }

    @discardableResult
    func toolIconHighlightedColor(_ color: UIColor) -> LMImageEditorUIConfiguration {
        toolIconHighlightedColor = color
        return self
    }
}
