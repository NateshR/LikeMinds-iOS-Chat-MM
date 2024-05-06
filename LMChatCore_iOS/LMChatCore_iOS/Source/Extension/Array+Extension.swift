//
//  Array+Extension.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 01/05/24.
//

import Foundation

extension Array where Element: Equatable {
    func unique() -> [Element] {
        var arr = [Element]()
        self.forEach {
            if !arr.contains($0) {
                arr.append($0)
            }
        }
        return arr
    }
}
