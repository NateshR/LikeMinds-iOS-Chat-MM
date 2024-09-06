//
//  ShareContentUtil.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 09/05/24.
//

import Foundation
import UIKit

public class LMChatShareContentUtil {
    
    static var domainUrl = "lmchat://www.chatsampleapp.com"
    
    static func shareChatroom(viewController: UIViewController, domainUrl: String = domainUrl, chatroomId: String, description: String = "") {
        let shareUrl = "\(domainUrl)/chatroom_detail?chatroom_id=\(chatroomId)"
        Self.share(viewController: viewController, firstActivityItem: description, secondActivityItem: shareUrl)
    }
    
    public static func setDomainUrl(_ url: String) {
        Self.domainUrl = url
    }
    
    private static func share(viewController: UIViewController, firstActivityItem description: String = "", secondActivityItem url: String, image: UIImage? = nil) {
        guard let url = URL(string: url) else { return }
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [description, url], applicationActivities: nil)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList
        ]
        
        activityViewController.isModalInPresentation = true
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
}
