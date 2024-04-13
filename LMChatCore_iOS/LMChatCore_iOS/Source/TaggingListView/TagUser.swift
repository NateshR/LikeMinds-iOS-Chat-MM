//
//  TagUser.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 31/01/24.
//

import Foundation

public struct TagUser {
    
    public var image: String?
    public var name: String
    public var routeUrl: String
    public var userId: String
    
    public var route: String {
        return "<<\(name)|route://user_profile/\(userId)>>"
    }
    
    
    static func getUsers(search: String) -> [TagUser] {
        
        return [
            TagUser(name: "Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Push Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Less Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Cop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Top Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Chop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Nop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Dope Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Lop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Sop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Dop Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Pushpendra Singh", routeUrl: "route://singh/20848", userId: "20848"),
            TagUser(name: "Nil Singh", routeUrl: "route://singh/20848", userId: "20848")
        ]
    }
}
