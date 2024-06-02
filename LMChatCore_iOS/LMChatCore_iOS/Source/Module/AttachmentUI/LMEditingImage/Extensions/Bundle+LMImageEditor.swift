//
//  Bundle+LMImageEditor.swift
//  LMImageEditor
//
//  Created by long on 2020/8/12.
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

private class BundleFinder { }

extension Bundle {
    private static var bundle: Bundle?
    
    static var normal_module: Bundle? = {
        Bundle(for: BundleFinder.self)
    }()
    
    static var spm_module: Bundle? = {
        return Bundle(for: LMEditorManager.self)
    }()
    
    static var lmBundle: Bundle? = {
        Bundle(for: LMEditorManager.self)
            .url(forResource: "LikeMindsChatCore", withExtension: "bundle")
            .flatMap(Bundle.init(url:)) ?? Bundle(for: LMEditorManager.self)
    }()
    
    static var LMImageEditorBundle: Bundle? {
        return lmBundle ?? (normal_module ?? spm_module)
    }

}
