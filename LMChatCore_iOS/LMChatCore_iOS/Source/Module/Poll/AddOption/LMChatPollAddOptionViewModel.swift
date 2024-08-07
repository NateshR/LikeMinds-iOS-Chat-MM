//
//  LMChatPollAddOptionViewModel.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 26/07/24.
//

import LikeMindsChat
import LikeMindsChatUI

public protocol LMChatPollAddOptionViewModelProtocol: LMBaseViewControllerProtocol {
    func setSubmitButton(isEnabled: Bool)
    func showButtonLoader()
    func onAddOptionResponse(postID: String, success: Bool, errorMessage: String?)
}

public final class LMChatPollAddOptionViewModel {
    let postID: String
    let pollID: String
    let pollOptions: [String]
    weak var delegate: LMChatPollAddOptionViewModelProtocol?
    
    init(postID: String, pollID: String, pollOptions: [String], delegate: LMChatPollAddOptionViewModelProtocol? = nil) {
        self.postID = postID
        self.pollID = pollID
        self.pollOptions = pollOptions
        self.delegate = delegate
    }
    
    public static func createModule(for postID: String, pollID: String, options: [String], delegate: LMChatAddOptionProtocol?) throws -> LMChatPollAddOptionScreen {
        guard LMChatCore.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewcontroller = LMChatPollAddOptionScreen()
        
        let viewmodel = Self.init(postID: postID, pollID: pollID, pollOptions: options, delegate: viewcontroller)
        viewcontroller.viewmodel = viewmodel
        viewcontroller.delegate = delegate
        
        return viewcontroller
    }
    
    public func checkValidOption(with value: String?) {
        delegate?.setSubmitButton(isEnabled: checkValidString(value: value))
    }
    
    private func checkValidString(value: String?) -> Bool {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty else {
            return false
        }
        
        return !pollOptions.contains(value)
    }
    
    public func onSubmitClick(with value: String?) {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              checkValidString(value: value) else { return }
     /*
        let request = AddPollOptionRequest
            .builder()
            .pollID(pollID)
            .pollText(value)
            .build()
        
        LMChatClient.shared.addPollOption(request) { [weak self] response in
            guard let self else { return }
            
            delegate?.onAddOptionResponse(postID: self.postID, success: response.success, errorMessage: response.errorMessage)
        }
        */
    }
}
