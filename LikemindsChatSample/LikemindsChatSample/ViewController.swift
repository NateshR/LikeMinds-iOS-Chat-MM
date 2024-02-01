//
//  ViewController.swift
//  LikemindsChatSample
//
//  Created by Pushpendra Singh on 13/12/23.
//

import UIKit
import LMChatCore_iOS

class ViewController: UIViewController {
    
//    open private(set) lazy var containerView: BottomMessageComposerView = {
//        let view = BottomMessageComposerView().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .cyan
//        return view
//    }()
    
    open private(set) lazy var containerView: BottomMessageReplyPreview = {
        let view = BottomMessageReplyPreview().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .cyan
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
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
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

