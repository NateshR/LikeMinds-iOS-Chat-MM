//
//  LMChatAttachmentViewModel.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 13/03/24.
//

import Foundation
import LMChatUI_iOS
import LikeMindsChat

public protocol LMChatAttachmentViewModelProtocol: LMBaseViewControllerProtocol {
}

//public typealias ReportContentID = (chatroomId: String?, messageId: String?, memberId: String?)

public final class LMChatAttachmentViewModel {
    
    weak var delegate: LMChatAttachmentViewModelProtocol?
    
    init(delegate: LMChatAttachmentViewModelProtocol?) {
        self.delegate = delegate
    }
    
    public static func createModule(delegate: LMChatAttachmentViewDelegate?) throws -> LMChatAttachmentViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewcontroller = LMCoreComponents.shared.attachmentMessageScreen.init()
        viewcontroller.delegate = delegate
        let viewmodel = Self.init(delegate: viewcontroller)
        
        viewcontroller.viewmodel = viewmodel
        return viewcontroller
    }
    
}
