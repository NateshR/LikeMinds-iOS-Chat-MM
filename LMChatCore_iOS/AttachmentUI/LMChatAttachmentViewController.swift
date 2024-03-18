//
//  LMChatAttachmentViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 13/03/24.
//

import Foundation
import LMChatUI_iOS

open class LMChatAttachmentViewController: LMViewController {
    
    open private(set) lazy var bottomMessageBoxView: LMAttachmentBottomMessageView = {
        let view = LMAttachmentBottomMessageView().translatesAutoresizingMaskIntoConstraints()
                view.backgroundColor = .cyan
        return view
    }()
    
    public var viewmodel: LMChatAttachmentViewModel?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        self.view.addSubview(bottomMessageBoxView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        NSLayoutConstraint.activate([
            bottomMessageBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMessageBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomMessageBoxView.heightAnchor.constraint(equalToConstant: 44),
            bottomMessageBoxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            //            bottomMessageBoxView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
}

extension LMChatAttachmentViewController: LMChatAttachmentViewModelProtocol {
    
}
