//
//  LMExploreChatroomViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMExploreChatroomViewController: LMViewController {
    
    var viewModel: LMExploreChatroomViewModel?
    
    open private(set) lazy var containerView: LMExploreChatroomListView = {
        let view = LMExploreChatroomListView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        viewModel?.getExploreChatrooms()
        setNavigationTitleAndSubtitle(with: "Explore", subtitle: nil)
    }
    
    // MARK: setupViews
    open override func setupViews() {
        self.view.addSubview(containerView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //            containerView.heightAnchor.constraint(equalToConstant: 40),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension LMExploreChatroomViewController: LMExploreChatroomViewModelDelegate {
    
    public func updateExploreChatroomsData() {
        let chatrooms =  (viewModel?.chatrooms ?? []).compactMap({ chatroom in
            LMExploreChatroomCell.ContentModel(chatroom: chatroom)
        })
        containerView.updateChatroomsData(chatroomData: chatrooms)
        containerView.reloadData()
    }
    
    public func reloadData() {
        
    }
}

extension LMExploreChatroomViewController: LMExploreChatroomListViewDelegate {
    
    public func didTapOnCell(indexPath: IndexPath) {
        guard let viewModel else { return }
        let chatroom = viewModel.chatrooms[indexPath.row]
        NavigationScreen.shared.perform(.chatroom(chatroomId: chatroom.id), from: self, params: nil)
    }
    
    public func fetchMoreData() {
        //     Add Logic for next page data
    }
}
