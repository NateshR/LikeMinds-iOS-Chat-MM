//
//  ViewController.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 13/12/23.
//

import UIKit
import LMChatCore_iOS
import LikeMindsChat

class ViewController: UIViewController {
    
//    open private(set) lazy var containerView: LMBottomMessageComposerView = {
//        let view = LMBottomMessageComposerView().translatesAutoresizingMaskIntoConstraints()
////        view.backgroundColor = .cyan
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMHomeFeedChatroomView = {
//        let view = LMHomeFeedChatroomView().translatesAutoresizingMaskIntoConstraints()
////                view.backgroundColor = .cyan
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMHomeFeedExploreTabView = {
//        let view = LMHomeFeedExploreTabView().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .systemGroupedBackground
//        return view
//    }()
    
    open private(set) lazy var containerView: LMHomeFeedListView = {
        let view = LMHomeFeedListView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
//    open private(set) lazy var containerView: LMBottomMessageReplyPreview = {
//        let view = LMBottomMessageReplyPreview().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .cyan
//        return view
//    }()
    
//    open private(set) lazy var containerView: LMBottomMessageLinkPreview = {
//        let view = LMBottomMessageLinkPreview().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .cyan
//        return view
//    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        setupViews()
//        setupLayouts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            guard let homefeedvc =
              try? LMMessageListViewModel.createModule(withChatroomId: "88638") else { return }
//            try? LMChatAttachmentViewModel.createModule() else { return }
//            try? LMParticipantListViewModel.createModule(withChatroomId: "36689") else { return }
//            try? LMHomeFeedViewModel.createModule() else { return }
//            try? LMChatReportViewModel.createModule(reportContentId: ("36689", nil, nil)) else { return }
            self.addChild(homefeedvc)
            self.view.addSubview(homefeedvc.view)
            homefeedvc.didMove(toParent: self)
            
//            self.navigationItem.leftBarButtonItem = LMBarButtonItem()
        }
    }
    // MARK: setupViews
    open func setupViews() {
        self.view.addSubview(containerView)
    }
    
    // MARK: setupLayouts
    open func setupLayouts() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
//            containerView.heightAnchor.constraint(equalToConstant: 40),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
 
/*
    func syncChatroom() {
        let request = InitiateUserRequest.builder()
            .apiKey("5f567ca1-9d74-4a1b-be8b-a7a81fef796f")
            .uuid("53b0176d-246f-4954-a746-9de96a572cc6")
            .userName("DEFCON")
            .isGuest(false)
            .deviceId(UIDevice.current.identifierForVendor?.uuidString ?? "")
            .build()
        LMChatClient.shared.initiateUser(request: request) { response in
            print(response)
        }
    }
*/
    
}

