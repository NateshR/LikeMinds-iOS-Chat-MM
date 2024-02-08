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
    public var route: String
    public var userId: String
    
    static func getUsers(search: String) -> [TagUser] {
        
        return [
            TagUser(name: "Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Push Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Less Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Cop Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Top Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Chop Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Nop Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Dope Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Lop Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Sop Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Dop Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Pushpendra Singh", route: "route://singh/20848", userId: "20848"),
            TagUser(name: "Nil Singh", route: "route://singh/20848", userId: "20848")
        ]
    }
}
