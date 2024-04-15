//
//  LMHomeFeedViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/02/24.
//

import Foundation
import LMChatUI_iOS

open class LMHomeFeedViewController: LMViewController {
    
    var viewModel: LMHomeFeedViewModel?
    
    open private(set) lazy var containerView: LMHomeFeedListView = {
        let view = LMHomeFeedListView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        
        viewModel?.getExploreTabCount()
        viewModel?.getChatrooms()
        viewModel?.syncChatroom()
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

extension LMHomeFeedViewController: LMHomeFeedViewModelProtocol {
    
    public func updateHomeFeedChatroomsData() {
       let chatrooms =  (viewModel?.chatrooms ?? []).compactMap({ chatroom in
            LMHomeFeedChatroomCell.ContentModel(chatroom: chatroom)
        })
        containerView.updateChatroomsData(chatroomData: chatrooms)
        containerView.reloadData()
    }
    
    public func updateHomeFeedExploreCountData() {
        guard let countData = viewModel?.exploreTabCountData else { return }
        containerView.updateExploreTabCount(exploreTabCount: LMHomeFeedExploreTabCell.ContentModel(totalChatroomsCount: countData.totalChatroomCount, unseenChatroomsCount: countData.unseenChatroomCount))
        containerView.reloadData()
    }
    
    
    public func reloadData() {
        
    }
}

extension LMHomeFeedViewController: LMHomFeedListViewDelegate {
    
    public func didTapOnCell(indexPath: IndexPath) {
        print("Chatroom clicked")
    }
    
    public func fetchMoreData() {
//     Add Logic for next page data
    }
}
