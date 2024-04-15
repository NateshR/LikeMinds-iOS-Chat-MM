//
//  LMStringConstant.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 06/03/24.
//

import Foundation

public struct LMStringConstant {
    private init() { }
    
    public static var shared = Self()
    
    public var appName = "LM Chat"
    public var genericErrorMessage = "Something went wrong!"
    public var maxUploadSizeErrorMessage = "Max Upload Size is %d"
    public var doneText = "Done"
    public var oKText = "OK"
}
