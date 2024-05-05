//
//  RouteBuilderManager.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 14/03/24.
//

import Foundation

class RouteBuilderManager {
 
    static let domainName = "likeminds.community"
    
    class func buildRouteForCollabcard(withDict dict: [AnyHashable : Any]?) -> String? {

        let collabcardId = dict?["collabcard_id"] as? String
        let refId = dict?["ref_id"] != nil ? (dict?["ref_id"] as? String) : ""
        let aj = dict?["aj"] != nil ? (dict?["aj"] as? String) : ""
        let sourceId = dict?["source_id"] != nil ? (dict?["source_id"] as? String) : ""
        let source = dict?["source"] != nil ? (dict?["source"] as? String) : ""

        let route = "route://collabcard?collabcard_id=\(collabcardId ?? "")&ref_id=\(refId ?? "")&aj=\(aj ?? "")&source_id=\(sourceId ?? "")&source=\(source ?? "")"
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
