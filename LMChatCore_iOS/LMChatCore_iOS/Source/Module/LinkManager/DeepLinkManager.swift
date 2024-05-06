//
//  DeepLinkManager.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 14/03/24.
//
import Foundation

@objc public class DeepLinkManager: NSObject {
    
    public static let sharedInstance = DeepLinkManager()
 
// MARK: - Variable Access obj-C Classes
    @objc var usingSdkLinks = false
    @objc var isFromUrl = false
    
// MARK: - Global Variable
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    weak var preferences = PreferencesFactory.userPreferences()
    var controller = UIViewController()
    
    private var supportUrlHosts = ["likeminds.community", "www.likeminds.community", "beta.likeminds.community", "www.beta.likeminds.community", "betaweb.likeminds.community", "web.likeminds.community", "*", "collabmates.app.link"]
    private var supportSchemes = ["https", "likeminds", "collabmates"]
    
// MARK: - Private Variable (Internal)
    private var stringCollabcard = "collabcard"
    private var stringCommunityCollabcard = "community_collabcard"
    private var limitAcessCalled = false
 
// MARK: - Func Access obj-C Classes
    
    func params(fromRoute url: String) -> [String : Any] {
        let urlComponents = NSURLComponents(string: url)
        let queryItems = urlComponents?.queryItems
        var dictionary: [String : Any] = [:]
        for item in queryItems ?? [] {
            dictionary[item.name] = (item.value ?? "").replacingOccurrences(of: "%20", with: " ")
        }
        return dictionary
    }

// MARK: - Internal func (Rediection  Flow)
    
// MARK:- Go to external Browser
    
    private func gotoExternalBrowser(_ url: String) {
        guard let url = URL(string: url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

 // MARK: - GoTo Collabcard
    private func gotoCollabcard(withPathComponents pathComponents: [AnyHashable]?, andUrlComponents dict: [AnyHashable : Any]?) {
        var mutableDict: [AnyHashable : Any] = [:]

        if (pathComponents?.count ?? 0) >= 2 {
            mutableDict["collabcard_id"] = pathComponents?[2]
        }
        let routeUrl = RouteBuilderManager.buildRouteForCollabcard(withDict: mutableDict ) ?? ""
        openScreenWithRoute(route: routeUrl)

    }
    
    public func didReceivedRemoteNotification(_ userInfo: [AnyHashable : Any]) {
        if let url = userInfo["route"] as? String {
            print("Notification URL: \(url)")
            let route = Routes(route: url, fromNotification: true)
            route.fetchRoute { viewController in
                guard let viewController, let topMostController = UIViewController.topViewController() else { return
                }
                if let vc = topMostController as? UINavigationController, let homeFeedVC = vc.topViewController as? LMHomeFeedViewController {
                    homeFeedVC.navigationController?.pushViewController(viewController, animated: true)
                } else {
                    let chatMessageViewController = UINavigationController(rootViewController: viewController)
                    topMostController.present(chatMessageViewController, animated: false)
                }
            }
        }
    }

    private func openScreenWithRoute(route: String) {
//        AppDelegate.sharedInstance().initiateAuthApiForRoute(url: route)
    }

}
