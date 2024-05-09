//
//  RouteBuilderManager.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 14/03/24.
//

import Foundation

class RouteBuilderManager {
 
    static let domainName = "likeminds.community"
    
    class func buildRouteForChatroom(withDict dict: [AnyHashable : Any]?) -> String? {
        let chatroomId = dict?["chatroom_id"] as? String
        let route = "route://chatroom_detail?chatroom_id=\(chatroomId ?? "")"
        return route
    }

    class func buildRouteFromUrl(routeUrl: String) -> String? {
        if routeUrl == ""{
            return ""
        }
        let url = routeUrl.lowercased()
        let urlComponents = NSURLComponents(string: url)
        let path = urlComponents?.path
        let queryItems = url.components(separatedBy: "?").last ?? ""
        var route = ""
        if url.contains(domainName){
            let pathString = url.components(separatedBy: "likeminds.community").last ?? ""
            let pathId = path?.components(separatedBy: "/").last
            if pathString.contains("collabcard"){
                route = "route://collabcard?collabcard_id=\(pathId ?? "")&\(queryItems)"
            }
        }
        return route
    }
    
}
