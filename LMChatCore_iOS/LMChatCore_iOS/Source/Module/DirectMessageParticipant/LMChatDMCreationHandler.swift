//
//  LMChatDMCreationHandler.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 21/06/24.
//

import Foundation
import LikeMindsChatUI
import LikeMindsChat

public final class LMChatDMCreationHandler {
    
    public static let shared = LMChatDMCreationHandler()
    let moduleName = "DM Createion Handler"
    var completion: ((_ chatroomId: String?) -> Void)?
    weak var viewController: LMViewController?
    
    public func openDMChatroom(uuid: String, viewController: LMViewController?, completion: ((_ chatroomId: String?) -> Void)?) {
        self.viewController = viewController
        self.completion = completion
        (self.viewController)?.showHideLoaderView(isShow: true, backgroundColor: .clear)
        self.checkDMLimit(uuid: uuid)
    }
    
    public func validateDMChatroom(withUUID uuid: String, completion: ((_ chatroomId: String?) -> Void)?) {
        self.completion = completion
        self.checkDMLimit(uuid: uuid)
    }
    
    private func checkDMLimit(uuid: String) {
        let request = CheckDMLimitRequest.builder()
            .uuid(uuid)
            .build()
        LMChatClient.shared.checkDMLimit(request: request) {[weak self] response in
            (self?.viewController)?.showHideLoaderView(isShow: false, backgroundColor: .clear)
            guard let chatroomId = response.data?.chatroomId else {
                if LMSharedPreferences.bool(forKey: LMSharedPreferencesKeys.isDMWithRequestEnabled.rawValue) == true {
                    if response.data?.isRequestDMLimitExceeded == false {
                        self?.createDMChatroom(uuid: uuid)
                    } else {
                        var message = "You can send only \(response.data?.userDMLimit?.numberInDuration ?? 0) DM requests per \(response.data?.userDMLimit?.duration ?? "Day")."
                        
                        if let duration = response.data?.newRequestDMTimestamp {
                            let date = Date(milliseconds: duration)
                            let dateComponentsFormatter = RelativeDateTimeFormatter()
                            dateComponentsFormatter.unitsStyle = .full
                            
                            let diff = dateComponentsFormatter.localizedString(for: date, relativeTo: Date())
                            message.append("\nTry again \(diff).")
                        }
                        
                        self?.viewController?.showErrorAlert("Request limit exceeded", message: message)
                        self?.completion?(nil)
                    }
                } else {
                    self?.createDMChatroom(uuid: uuid)
                }
                return
            }
            if let completion = self?.completion {
                completion("\(chatroomId)")
            } else {
                self?.routeToChatroom(chatroomId: "\(chatroomId)")
            }
        }
    }
    
    private func createDMChatroom(uuid: String) {
        (self.viewController)?.showHideLoaderView(isShow: true, backgroundColor: .clear)
        let request = CreateDMChatroomRequest.builder()
            .uuid(uuid)
            .build()
        LMChatClient.shared.createDMChatroom(request: request) {[weak self] response in
            (self?.viewController)?.showHideLoaderView(isShow: false, backgroundColor: .clear)
            guard let chatroomId = response.data?.chatroomData?.id else {
                self?.viewController?.showErrorAlert(nil, message: response.errorMessage)
                self?.completion?(nil)
                return
            }
            if let completion = self?.completion {
                completion(chatroomId)
            } else {
                self?.routeToChatroom(chatroomId: chatroomId)
            }
        }
    }
    
    private func routeToChatroom(chatroomId: String?) {
        guard let viewController, let chatroomId else { return }
        DispatchQueue.main.async {
            NavigationScreen.shared.perform(.chatroom(chatroomId: chatroomId, conversationID: nil), from: viewController, params: nil)
        }
    }
}
