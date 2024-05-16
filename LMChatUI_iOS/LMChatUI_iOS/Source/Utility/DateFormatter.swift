//
//  DateFormatter.swift
//  LMChatUI_iOS
//
//  Created by Devansh Mohata on 16/05/24.
//

import Foundation

public final class LMChatDateUtility {
    static func formatDate(_ epochTime: Double) -> String {
        // Check if the epoch time is in seconds or milliseconds
        let isMilliseconds = epochTime > 1_000_000_000_000
        let interval: TimeInterval = isMilliseconds ? epochTime / 1000.0 : epochTime
        let date = Date(timeIntervalSince1970: interval)
        
        // Get the current date and calendar components
        let calendar = Calendar.current
        
        // Check if the date is today or yesterday
        if calendar.isDateInToday(date) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "yesterday"
        } else {
            // Format the date as DD/MM/YY
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yy"
            return dateFormatter.string(from: date)
        }
    }
}
