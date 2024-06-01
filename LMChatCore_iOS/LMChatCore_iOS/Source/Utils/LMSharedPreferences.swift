//
//  LMSharedPreferences.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 09/05/24.
//

import Foundation

enum LMSharedPreferencesKeys: String {
    case tempDeeplinkUrl = "$_deeplink_url"
}

class LMSharedPreferences {
    
    private static let shared = UserDefaults.standard
    
    private init() {}
    
    static func setString(_ value: String, forKey key: LMSharedPreferencesKeys) {
        shared.set(value, forKey: key.rawValue)
        shared.synchronize()
    }
    
    static func getString(forKey key: LMSharedPreferencesKeys) -> String? {
        shared.value(forKey: key.rawValue) as? String
    }
    
    static func removeValue(forKey key: LMSharedPreferencesKeys) {
        shared.removeObject(forKey: key.rawValue)
        shared.synchronize()
    }
    
}
