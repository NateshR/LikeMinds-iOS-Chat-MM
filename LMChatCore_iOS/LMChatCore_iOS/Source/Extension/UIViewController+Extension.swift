//
//  UIViewController+Extension.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 03/05/24.
//

import Foundation

extension UIViewController {
    
    static func topViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
}
