//
//  LMChatDMParticipantsViewController.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 20/06/24.
//

import Foundation
import LikeMindsChatUI

open class LMChatMemberListViewController: LMViewController {
    public var viewModel: LMChatMemberListViewModel?
    public var searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: UI Elements
    open private(set) lazy var memberCountsLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.text = ""
        label.font = Appearance.shared.fonts.textFont2
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        label.numberOfLines = 1
        return label
    }()
    
    open private(set) lazy var containerView: LMChatParticipantListView = {
        let view = LMUIComponents.shared.participantListView.init().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        self.view.addSubview(memberCountsLabel)
        self.view.addSubview(containerView)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        memberCountsLabel.addConstraint(top: (view.safeAreaLayoutGuide.topAnchor, 12),
                                        leading: (view.leadingAnchor, 16),
                                     trailing: (view.trailingAnchor, -16))
        containerView.addConstraint(top: (memberCountsLabel.topAnchor, 8),
                                    bottom: (view.safeAreaLayoutGuide.bottomAnchor, 0),
                                        leading: (view.leadingAnchor, 0),
                                        trailing: (view.trailingAnchor, 0))
    }
    
    
    // MARK: viewDidLoad
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitleAndSubtitle(with: Constants.shared.strings.sendDMToTitle, subtitle: nil, alignment: .center)
        setupSearchBar()
        viewModel?.getParticipants()
    }
    
    open func setupSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationController?.navigationBar.prefersLargeTitles = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension LMChatMemberListViewController: LMChatMemberListViewModelProtocol {
    public func reloadData(with data: [LMChatParticipantCell.ContentModel]) {
        containerView.data = data
        containerView.reloadList()
        
        var subCount: String? = nil
        
        if let count = viewModel?.totalParticipantCount,
           count != 0 {
            subCount = "\(count) members"
        }
        memberCountsLabel.text = subCount
    }
}

@objc
extension LMChatMemberListViewController: LMParticipantListViewDelegate {
    
    open func didTapOnCell(indexPath: IndexPath) {
        print("participant clicked......")
        let member = containerView.data[indexPath.row]
        guard let uuid = member.id else { return }
        LMChatDMCreationHandler.shared.openDMChatroom(uuid: uuid, viewController: self) {[weak self] chatroomId in
            guard let self, let chatroomId else { return }
            DispatchQueue.main.async {
                NavigationScreen.shared.perform(.chatroom(chatroomId: chatroomId, conversationID: nil), from: self, params: nil)
            }
        }
    }
    
    open func loadMoreData() {
        viewModel?.getParticipants()
    }
}

extension LMChatMemberListViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        viewModel?.searchParticipants(searchController.searchBar.text )
    }
}
