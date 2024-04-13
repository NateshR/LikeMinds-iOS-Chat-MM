//
//  TimeUtils.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/04/24.
//

import Foundation

class TimeUtils {
    
    static func generateCreateAtDate(miliseconds: Double, format: String = "dd MMM yyyy") -> String {
        return Date(milliseconds: miliseconds).getDateString(withFormat: format)
    }
    
}
