//
//  Date+Extension.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/04/24.
//

import Foundation

extension Date {
    
    var millisecondsSince1970: Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
    init(milliseconds: Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds)/1000.0)
    }
    func getDateInFormateWith(withMillSec: Double, format: String = "MM-dd-yyyy") -> String {
        let date = Date(milliseconds: withMillSec).description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date1 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = format
        let date2 = dateFormatter.string(from: date1!)
        return date2
    }
    func convertDateFormater(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date1 = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let date2 = dateFormatter.string(from: date1!)
        return date2
    }
    
    func getDateString(withFormat format: String = "MMM d, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}
