//
//  LMChatTagUser.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 31/01/24.
//

import Foundation

public struct LMChatTagUser {
    
    public var image: String?
    public var name: String
    public var routeUrl: String
    public var userId: String
    
    public var route: String {
        return "<<\(name)|route://user_profile/\(userId)>>"
    }
}
