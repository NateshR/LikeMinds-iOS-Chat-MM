//
//  Routes.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 14/03/24.
//
import Foundation
import UIKit

struct RouteTriggerProperties {
    var triggerSource:String
    var fromDeepLink: Bool
    var fromNotification: Bool
    var fromShareThirdParty:Bool = false
}

@objcMembers class Routes: NSObject {

    static let sharedInstance = Routes(route: "")
    
    enum RouteHostURL: String {
        case ROUTE_COLLABCARD = "collabcard"
        case ROUTE_TO_DIRECT_CHATROOM = "direct_messages"
        case ROUTE_CHATROOM_DETAIL = "chatroom_detail"
        case ROUTE_TO_POLL = "poll_chatroom"
    }
    
    
    private var route: String?
    private var fromNotification: Bool
    private var fromDeeplink: Bool
    private var triggerSource: String

    init(route: String?, fromNotification: Bool = false, fromDeeplink: Bool = false, source: String = "") {
        self.route = route
        self.fromNotification = fromNotification
        self.fromDeeplink = fromDeeplink
        self.triggerSource = source
        super.init()
    }
    
    func fetchRouteHostURL() -> RouteHostURL? {
        guard let routeURL = URL(string: route?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
              let host = routeURL.host,
              let routeHostURL = RouteHostURL(rawValue: host) else { return nil }
        return routeHostURL
    }
    
    func implementedRoutes() -> Bool {
        guard let rt = route else {return false}
        route = rt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let routeUrl = URL(string: route ?? ""),
              let host = routeUrl.host,
              let routeHostURL = RouteHostURL(rawValue: host) else {return false}
        
        switch routeHostURL {
        case .ROUTE_COLLABCARD,
                .ROUTE_TO_DIRECT_CHATROOM,
                .ROUTE_CHATROOM_DETAIL,
                .ROUTE_TO_POLL:
            return true
        default:
            return false
        }
    }
    func fetchRoute(withCompletion completion: @escaping (UIViewController?) -> Void) {
        if route == nil {
            completion(nil)
            return
        }
        
        if let rt = route {
            route = rt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }

        guard let routeUrl = URL(string: route ?? ""),
              let host = routeUrl.host,
              let routeHostURL = RouteHostURL(rawValue: host) else {
            completion(nil)
            return
        }

        switch routeHostURL {
            
        case .ROUTE_COLLABCARD:
            getRouteToCollabcardConversation(withCompletion: completion)
            
        case .ROUTE_TO_DIRECT_CHATROOM,
             .ROUTE_CHATROOM_DETAIL,
             .ROUTE_TO_POLL:
            getRouteToChatroom(withCompletion: completion)
        default:
            completion(nil)
        }
    }
    
    func getRouteToChatroom(withCompletion completion: @escaping (UIViewController?) -> Void) {
        let params = getParams()
    
        guard let chatRoomID = params["chatroom_id"] else {
            completion(nil)
            return
        }
        guard let chatroomDetails = try? LMChatMessageListViewModel.createModule(withChatroomId: chatRoomID, conversationId: nil) else {
            completion(nil)
            return
        }
        completion(chatroomDetails)
    }

    func getRouteToCollabcardConversation(withCompletion completion: @escaping (UIViewController?) -> Void) {
        let params = getParams()
        
        guard let chatRoomID = params["collabcard_id"]  else {
            completion(nil)
            return
        }
        
        guard let chatroomDetails = try? LMChatMessageListViewModel.createModule(withChatroomId: chatRoomID, conversationId: nil) else {
            completion(nil)
            return
        }
        completion(chatroomDetails)
    }
    
    
    func getParams() -> [String : String] {
        let urlComponents = NSURLComponents(string: self.route ?? "")
        let queryItems = urlComponents?.queryItems
        var dictionary: [String : String] = [:]
        for item in queryItems ?? [] {
            dictionary[item.name] = (item.value ?? "").replacingOccurrences(of: "%20", with: " ")
        }
        return dictionary
    }
}
