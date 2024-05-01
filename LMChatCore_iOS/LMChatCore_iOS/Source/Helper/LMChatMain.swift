//
//  LMChatMain.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 17/02/24.
//

import Foundation
import LikeMindsChat

public class LMChatMain {
    
    private init() {}
    
    public static var shared: LMChatMain = .init()
//    static var analytics: LMFeedAnalyticsProtocol = LMFeedAnalyticsTracker()
    static private(set) var isInitialized: Bool = false
    var apiKey: String = ""
    public func configure(apiKey: String) {
        self.apiKey = apiKey
        LMAWSManager.shared.initialize()
        GiphyAPIConfiguration.configure()
    }
    
    public func initiateUser(username: String, userId: String, deviceId: String) throws {
        let request = InitiateUserRequest.builder()
            .userName(username)
            .uuid(userId)
            .deviceId(deviceId)
            .isGuest(false)
            .apiKey(apiKey)
            .build()
        LMChatClient.shared.initiateUser(request: request) { response in
            guard response.success, response.data?.appAccess == true else {
                return
            }
            Self.isInitialized = true
        }
        
        print("test ")
    }
    
    func logout() {
        
    }
    
}

// MARK: LMFeedAnalyticsProtocol
public protocol LMChatAnalyticsProtocol {
    func trackEvent(for eventName: LMChatAnalyticsEventName, eventProperties: [String: AnyHashable])
}

final class LMChatAnalyticsTracker: LMChatAnalyticsProtocol {
    public func trackEvent(for eventName: LMChatAnalyticsEventName, eventProperties: [String : AnyHashable]) {
        let track = """
            ========Event Tracker========
        Event Name: \(eventName)
        Event Properties: \(eventProperties)
            =============================
        """
        print(track)
    }
}

public struct LMChatAnalyticsEventName {
    
}
