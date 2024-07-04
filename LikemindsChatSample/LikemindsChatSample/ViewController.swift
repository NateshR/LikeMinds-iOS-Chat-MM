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

    override func viewDidLoad() {
        super.viewDidLoad()
        isSavedData()
    }
    
    func moveToNextScreen() {
        self.showHideLoaderView(isShow: false, backgroundColor: .clear)
        let homefeedvc = ChatFeedViewModel.createModule()
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
    }
    
    @IBAction func loginAsMemberButtonClicked(_ sender: UIButton) {
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
    
    @discardableResult
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
            guard success else {
                self?.showAlert(message: error ?? "")
                return
            }
            self?.moveToNextScreen()
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
 
}

