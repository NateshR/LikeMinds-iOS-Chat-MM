//
//  AppDelegate.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 13/12/23.
//

import UIKit
import LMChatCore_iOS
//import FirebaseMessaging
//import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LMChatMain.shared.configure(apiKey: "17ab90f3-6cba-4dd9-aeea-979a081081b7")
//        LMChatMain.shared.configure(apiKey: "5f567ca1-9d74-4a1b-be8b-a7a81fef796f")
//            .uuid("53b0176d-246f-4954-a746-9de96a572cc6")
//            .userName("DEFCON")
//            .isGuest(false)
//            .deviceId(UIDevice.current.identifierForVendor?.uuidString ?? "")
        LMCoreComponents.shared.homeFeedChatroomView = CustomChatroomView.self
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
        registerForPushNotifications(application: application)

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

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        DeepLinkManager.sharedInstance.didReceivedRemoteNotification(response.notification.request.content.userInfo)
    }
    
    
    private func registerForPushNotifications(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
}

//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("Firebase registration token: \(String(describing: fcmToken))")
//    }
//    
//}
