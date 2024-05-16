//
//  LMExploreChatroomListView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LMChatUI_iOS

public protocol LMChatExploreChatroomFilterProtocol: AnyObject {
    func applyFilter(with filter: LMChatExploreChatroomViewModel.Filter)
    func applyPinnedStatus()
}

@IBDesignable
open class LMExploreChatroomListView: LMViewController {
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var loadingView: LMHomeFeedShimmerView = {
        let view = LMHomeFeedShimmerView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: UIScreen.main.bounds.size.width)
        return view
    }()
    
    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView().translatesAutoresizingMaskIntoConstraints()
        table.register(LMChatExploreChatroomCell.self)
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.clipsToBounds = true
        table.separatorStyle = .none
        table.backgroundColor = .gray
        table.backgroundView = loadingView
        return table
    }()
    
    
    // MARK: Data Variables
    public let cellHeight: CGFloat = 60
    public var data: [LMHomeFeedChatroomCell.ContentModel] = []
    public var viewModel: LMChatExploreChatroomViewModel?
    public var chatroomData: [LMChatExploreChatroomView.ContentModel] = []
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        view.addSubview(containerView)
        containerView.addSubview(tableView)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        view.pinSubView(subView: containerView)
        containerView.pinSubView(subView: tableView)
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        view.backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.white
        tableView.backgroundColor = Appearance.shared.colors.clear
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.getExploreChatrooms()
    }
    
    public func updateChatroomsData(chatroomData: [LMChatExploreChatroomView.ContentModel]) {
        self.chatroomData = chatroomData
        tableView.reloadData()
        
        if !chatroomData.isEmpty {
            tableView.backgroundView = nil
        }
    }
}


// MARK: UITableView
extension LMExploreChatroomListView: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
   open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatroomData.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = chatroomData[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(LMChatExploreChatroomCell.self) {
            cell.configure(with: data, delegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatroom = chatroomData[indexPath.row]
        NavigationScreen.shared.perform(.chatroom(chatroomId: chatroom.chatroomId), from: self, params: nil)
    }
    
    open func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row >= chatroomData.count }) {
            viewModel?.getExploreChatrooms()
        }
    }
}


extension LMExploreChatroomListView: LMChatExploreChatroomProtocol {
    public func onTapJoinButton(_ value: Bool, _ chatroomId: String) {
        viewModel?.followUnfollow(chatroomId: chatroomId, status: value)
    }
}


extension LMExploreChatroomListView: LMChatExploreChatroomViewModelProtocol {
    public func updateExploreChatroomsData(with data: [LMChatExploreChatroomView.ContentModel]) {
        chatroomData = data
        tableView.reloadData()
    }
}

extension LMExploreChatroomListView: LMChatExploreChatroomFilterProtocol {
    public func applyFilter(with filter: LMChatExploreChatroomViewModel.Filter) {
        viewModel?.applyFilter(filter: filter)
    }
    
    public func applyPinnedStatus() {
        viewModel?.applyFilter()
    }
}
