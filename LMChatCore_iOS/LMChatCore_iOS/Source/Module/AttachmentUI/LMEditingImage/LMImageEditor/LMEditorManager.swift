//
//  LMEditorManager.swift
//  LMImageEditor
//
//  Created by long on 2023/10/12.
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

public enum LMEditorAction {
    case draw(LMDrawPath)
    case eraser([LMDrawPath])
    case clip(oldStatus: LMClipStatus, newStatus: LMClipStatus)
    case sticker(oldState: LMBaseStickertState?, newState: LMBaseStickertState?)
    case mosaic(LMMosaicPath)
    case filter(oldFilter: LMFilter?, newFilter: LMFilter?)
    case adjust(oldStatus: LMAdjustStatus, newStatus: LMAdjustStatus)
}

protocol LMEditorManagerDelegate: AnyObject {
    func editorManager(_ manager: LMEditorManager, didUpdateActions actions: [LMEditorAction], redoActions: [LMEditorAction])
    
    func editorManager(_ manager: LMEditorManager, undoAction action: LMEditorAction)
    
    func editorManager(_ manager: LMEditorManager, redoAction action: LMEditorAction)
}

class LMEditorManager {
    private(set) var actions: [LMEditorAction] = []
    private(set) var redoActions: [LMEditorAction] = []
    
    weak var delegate: LMEditorManagerDelegate?
    
    init(actions: [LMEditorAction] = []) {
        self.actions = actions
        self.redoActions = actions
    }
    
    func storeAction(_ action: LMEditorAction) {
        actions.append(action)
        redoActions = actions
        
        deliverUpdate()
    }
    
    func undoAction() {
        guard let preAction = actions.popLast() else { return }
        
        delegate?.editorManager(self, undoAction: preAction)
        deliverUpdate()
    }
    
    func redoAction() {
        guard actions.count < redoActions.count else { return }
        
        let action = redoActions[actions.count]
        actions.append(action)
        
        delegate?.editorManager(self, redoAction: action)
        deliverUpdate()
    }
    
    private func deliverUpdate() {
        delegate?.editorManager(self, didUpdateActions: actions, redoActions: redoActions)
    }
}
