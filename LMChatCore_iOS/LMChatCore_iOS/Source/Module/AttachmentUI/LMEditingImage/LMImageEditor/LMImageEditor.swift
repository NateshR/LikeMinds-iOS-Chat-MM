//
//  LMImageEditor.swift
//  LMImageEditor
//
//  Created by long on 2020/9/8.
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

import Foundation
import UIKit

let version = "2.0.1"

public struct LMImageEditorWrapper<Base> {
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol LMImageEditorCompatible: AnyObject { }

public protocol LMImageEditorCompatibleValue { }

extension LMImageEditorCompatible {
    public var lm: LMImageEditorWrapper<Self> {
        get { LMImageEditorWrapper(self) }
        set { }
    }
    
    public static var lm: LMImageEditorWrapper<Self>.Type {
        get { LMImageEditorWrapper<Self>.self }
        set { }
    }
}

extension LMImageEditorCompatibleValue {
    public var lm: LMImageEditorWrapper<Self> {
        get { LMImageEditorWrapper(self) }
        set { }
    }
}

extension UIImage: LMImageEditorCompatible { }
extension CIImage: LMImageEditorCompatible { }
extension UIColor: LMImageEditorCompatible { }
extension UIView: LMImageEditorCompatible { }
extension UIGraphicsImageRenderer: LMImageEditorCompatible { }

extension String: LMImageEditorCompatibleValue { }
extension CGFloat: LMImageEditorCompatibleValue { }
