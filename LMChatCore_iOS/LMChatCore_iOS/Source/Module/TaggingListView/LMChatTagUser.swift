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
    
    
    static func getUsers(search: String) -> [LMChatTagUser] {
        
        return [
            LMChatTagUser(name: "Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Push Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Less Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Cop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Top Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Chop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Nop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Dope Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Lop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Sop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Dop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Pushpendra Singh", routeUrl: "route://singh/20848", userId: "20848"),
            LMChatTagUser(name: "Nil Singh", routeUrl: "route://singh/20848", userId: "20848")
        ]
    }
}
