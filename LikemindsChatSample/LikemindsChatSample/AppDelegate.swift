//
//  AppDelegate.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 13/12/23.
//

import UIKit
import LMChatCore_iOS

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LMChatMain.shared.configure(apiKey: "5f567ca1-9d74-4a1b-be8b-a7a81fef796f")
//            .uuid("53b0176d-246f-4954-a746-9de96a572cc6")
//            .userName("DEFCON")
//            .isGuest(false)
//            .deviceId(UIDevice.current.identifierForVendor?.uuidString ?? "")
        LMCoreComponents.shared.homeFeedChatroomView = CustomChatroomView.self
        try? LMChatMain.shared.initiateUser(username: "DEFCON", userId: "53b0176d-246f-4954-a746-9de96a572cc6", deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "")
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

