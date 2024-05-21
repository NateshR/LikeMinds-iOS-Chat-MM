//
//  Bundle+Extension.swift
//  LMFramework
//
//  Created by Devansh Mohata on 13/12/23.
//

import Foundation

private class LMChatBundleClass { }

extension Bundle {
    static var LMBundleIdentifier: Bundle {
        return Bundle(for: LMChatBundleClass.self)
            .url(forResource: "LMChatUI_iOS", withExtension: "bundle")
            .flatMap(Bundle.init(url:)) ?? Bundle(for: LMChatBundleClass.self)
    }
}
