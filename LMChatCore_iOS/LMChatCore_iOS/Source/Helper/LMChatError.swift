//
//  LMChatError.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 06/03/24.
//

import Foundation

public enum LMChatError: Error {
    case apiInitializationFailed(error: String?)
    case appAccessFalse
    case chatNotInitialized
    
    case reportFailed(error: String?)
    
    case routeError(error: String?)
    
    public var localizedDescription: String {
        switch self {
        case .apiInitializationFailed(let error),
                .reportFailed(let error),
                .routeError(let error):
            return error ?? LMStringConstant.shared.genericErrorMessage
        case .appAccessFalse:
            return "User does not have right access for app usage"
        case .chatNotInitialized:
            return "LikeMinds Chat has not been initialized"
        }
    }
}
