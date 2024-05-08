//
//  LMExploreChatroomViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMExploreChatroomViewController: LMViewController {
    open private(set) lazy var containerView: LMExploreChatroomListView = {
        let view = LMExploreChatroomListView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    open private(set) lazy var filterButton: LMButton = {
        let button = LMButton.createButton(with: viewModel?.orderType.stringName ?? "Newest", image: Constants.shared.images.downArrowIcon, textColor: Appearance.shared.colors.gray51, textFont: Appearance.shared.fonts.headingFont1, contentSpacing: .init(top: 20, left: 20, bottom: 20, right: 10))
        button.setFont(Appearance.shared.fonts.headingFont1)
        button.tintColor = Appearance.shared.colors.gray51
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(filterButtonClicked), for: .touchUpInside)
        return button
    }()
    
    public var viewModel: LMExploreChatroomViewModel?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        viewModel?.getExploreChatrooms()
        setNavigationTitleAndSubtitle(with: "Explore Chatroom", subtitle: nil)
    }
    
    // MARK: setupViews
    open override func setupViews() {
        self.view.addSubview(filterButton)
        self.view.addSubview(containerView)
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //            containerView.heightAnchor.constraint(equalToConstant: 40),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: filterButton.bottomAnchor)
        ])
    }
    
    @objc func filterButtonClicked(_ sender: UIButton) {
        let filters: [LMExploreChatroomViewModel.Filter] = [.newest, .recentlyActive, .mostParticipants, .mostMessages]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for item in filters {
            let actionItem = UIAlertAction(title: item.stringName, style: UIAlertAction.Style.default) {[weak self] (UIAlertAction) in
                self?.filterButton.setTitle(item.stringName, for: .normal)
                self?.viewModel?.applyFilter(filter: item)
            }
            alert.addAction(actionItem)
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
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
        viewModel?.getExploreChatrooms()
    }
    
    public func followUnfollowStatusUpdate(_ value: Bool, _ chatroomId: String) {
        viewModel?.followUnfollow(chatroomId: chatroomId, status: value)
    }
}
