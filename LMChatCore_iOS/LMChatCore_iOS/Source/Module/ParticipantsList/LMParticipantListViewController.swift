//
//  LMParticipantListViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 16/02/24.
//

import Foundation
import LMChatUI_iOS

open class LMParticipantListViewController: LMViewController {
    
    var viewModel: LMParticipantListViewModel?
    public var searchController = UISearchController(searchResultsController: nil)
    
    open private(set) lazy var containerView: LMParticipantListView = {
        let view = LMCoreComponents.shared.participantListView.init().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        return view
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupLayouts()
        self.setNavigationTitleAndSubtitle(with: "Participants", subtitle: nil, alignment: .center)
        self.setupSearchBar()
        viewModel?.getParticipants()
    }
    
    open func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = false
        searchController.obscuresBackgroundDuringPresentation = false
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
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension LMParticipantListViewController: LMParticipantListViewModelProtocol {
    
    public func reloadData() {
        containerView.data = viewModel?.participantsContentModels ?? []
        containerView.reloadList()
    }
}

extension LMParticipantListViewController: LMParticipantListViewDelegate {
    public func didTapOnCell(indexPath: IndexPath) {
        print("participant clicked......")
    }
    
    public func loadMoreData() {
        viewModel?.getParticipants()
    }
}

