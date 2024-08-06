//
//  LMChatCreatePollDataModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 17/07/24.
//

import Foundation

public enum LMChatPollSelectState: Int, CustomStringConvertible, CaseIterable {
    case exactly
    case atMax
    case atLeast
    
    public var description: String {
        switch self {
        case .exactly:
            return "Exactly"
        case .atMax:
            return "At most"
        case .atLeast:
            return "At least"
        }
    }
    
    public var apiKey: String {
        switch self {
        case .exactly:
            return "exactly"
        case .atMax:
            return "at_max"
        case .atLeast:
            return "at_least"
        }
    }
    
    public func checkValidity(with count: Int, allowedCount: Int) -> Bool {
        switch self {
        case .exactly:
            return count == allowedCount
        case .atMax:
            return count > 0 && count <= allowedCount
        case .atLeast:
            return count >= allowedCount
        }
    }
    
    public func toastMessage(with count: Int, allowedCount: Int) -> String {
        
        switch self {
        case .exactly:
            return "You must select \(allowedCount) options. Unselect an option or submit your vote now."//count == allowedCount
        case .atMax:
            return "You can select max \(allowedCount) options. Unselect an option or submit your vote now."//count > 0 && count <= allowedCount
        case .atLeast:
            return "Select at least \(allowedCount - count) more options to submit your vote."//count >= allowedCount
        }
    }
}

extension LMChatPollSelectState {
    init?(key: String) {
        guard let type = LMChatPollSelectState.allCases.first(where: { $0.apiKey == key }) else { return nil }
        self = type
    }
}

public struct LMChatCreatePollDataModel {
    public enum MetaOptions: Int, CustomStringConvertible, CaseIterable {
        case isAnonymousPoll
        case isInstantPoll
        case allowAddOptions
        
        public var description: String {
            switch self {
            case .isAnonymousPoll:
                return "Anonymous poll"
            case .isInstantPoll:
                return "Don’t show live results"
            case .allowAddOptions:
                return "Allow voters to add options"
            }
        }
    }
    
    let pollQuestion: String
    let expiryTime: Date
    let pollOptions: [String]
    let isInstantPoll: Bool
    let selectState: LMChatPollSelectState
    let selectStateCount: Int
    let isAnonymous: Bool
    let allowAddOptions: Bool
    
    public init(
        pollQuestion: String,
        expiryTime: Date,
        pollOptions: [String],
        isInstantPoll: Bool,
        selectState: LMChatPollSelectState,
        selectStateCount: Int,
        isAnonymous: Bool,
        allowAddOptions: Bool
    ) {
        self.pollQuestion = pollQuestion
        self.expiryTime = expiryTime
        self.pollOptions = pollOptions
        self.isInstantPoll = isInstantPoll
        self.selectState = selectState
        self.selectStateCount = selectStateCount
        self.isAnonymous = isAnonymous
        self.allowAddOptions = allowAddOptions
    }
}
