//
//  ViewController.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 13/12/23.
//

import UIKit
import LikeMindsChat
import LikeMindsChatUI
import LikeMindsChatCore

class ViewController: LMViewController {
    
    @IBOutlet weak var apiKeyField: UITextField?
    @IBOutlet weak var userIdField: UITextField?
    @IBOutlet weak var userNameField: UITextField?
    @IBOutlet weak var loginButton: UIButton?
    
    
//    open private(set) lazy var containerView: LMChatBottomMessageComposerView = {
//        let view = LMChatBottomMessageComposerView().translatesAutoresizingMaskIntoConstraints()
////        view.backgroundColor = .cyan
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMChatHomeFeedChatroomView = {
//        let view = LMChatHomeFeedChatroomView().translatesAutoresizingMaskIntoConstraints()
////                view.backgroundColor = .cyan
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMChatHomeFeedExploreTabView = {
//        let view = LMChatHomeFeedExploreTabView().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .systemGroupedBackground
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMChatHomeFeedListView = {
//        let view = LMChatHomeFeedListView().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .systemGroupedBackground
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMChatMessageReplyPreview = {
//        let view = LMChatMessageReplyPreview().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .cyan
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMBottomMessageLinkPreview = {
//        let view = LMBottomMessageLinkPreview().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .cyan
//        return view
//    }()
    
    private(set) lazy var loadingView: LMChatMessageLoadingShimmerView = {
        let view = LMChatMessageLoadingShimmerView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: UIScreen.main.bounds.size.width)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        isSavedData()
    }
    
    func moveToNextScreen() {
        self.showHideLoaderView(isShow: false, backgroundColor: .clear)
        guard let homefeedvc = try? LMChatHomeFeedViewModel.createModule() else { return }
        let navigation = UINavigationController(rootViewController: homefeedvc)
        navigation.modalPresentationStyle = .overFullScreen
        self.present(navigation, animated: false)
    }
    
    // MARK: setupViews
    open override func setupViews() {
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
    }
    
    @IBAction func loginAsCMButtonClicked(_ sender: UIButton) {
        apiKeyField?.text = "5f567ca1-9d74-4a1b-be8b-a7a81fef796f"
        userIdField?.text = "99b69c4f-998d-4248-86c1-6eed66e53ad2"
        userNameField?.text = "og shubh Gupta"
    }
    
    @IBAction func loginAsMemberButtonClicked(_ sender: UIButton) {
        apiKeyField?.text = "5f567ca1-9d74-4a1b-be8b-a7a81fef796f"
        userIdField?.text = "53b0176d-246f-4954-a746-9de96a572cc6"
        userNameField?.text = "DEFCON"
    }

    @IBAction func loginButtonClicked(_ sender: UIButton) {
        guard let apiKey = apiKeyField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !apiKey.isEmpty,
              let userId = userIdField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !userId.isEmpty,
              let username = userNameField?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            showAlert(message: "All fields are mandatory!")
            return
        }
        
        let userDefalut = UserDefaults.standard
        userDefalut.setValue(apiKey, forKey: "apiKey")
        userDefalut.setValue(userId, forKey: "userId")
        userDefalut.setValue(username, forKey: "username")
        userDefalut.synchronize()
        callInitiateApi(userId: userId, username: username, apiKey: apiKey)
    }
    
    func isSavedData() -> Bool {
        let userDefalut = UserDefaults.standard
        guard let apiKey = userDefalut.value(forKey: "apiKey") as? String,
              let userId = userDefalut.value(forKey: "userId") as? String,
              let username = userDefalut.value(forKey: "username") as? String else {
            return false
        }
        callInitiateApi(userId: userId, username: username, apiKey: apiKey)
        return true
    }
    
    func callInitiateApi(userId: String, username: String, apiKey: String) {
        LMChatMain.shared.configure(apiKey: apiKey)
        self.showHideLoaderView(isShow: true, backgroundColor: .clear)
        try? LMChatMain.shared.initiateUser(username: username, userId: userId, deviceId: UIDevice.current.identifierForVendor?.uuidString ?? "") {[weak self] success, error in
            guard success else { return }
            self?.moveToNextScreen()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
 
}

