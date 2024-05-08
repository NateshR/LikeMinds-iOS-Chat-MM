//
//  SearchListViewController.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 16/04/24.
//

import LMChatUI_iOS
import UIKit

public class SearchListViewController: LMViewController {
    public struct ContentModel {
        let title: String?
        let data: [SearchCellProtocol]
        
        public init(title: String?, data: [SearchCellProtocol]) {
            self.title = title
            self.data = data
        }
    }
    
    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView(frame: .zero, style: .grouped).translatesAutoresizingMaskIntoConstraints()
        table.register(SearchMessageCell.self)
        table.register(SearchGroupCell.self)
        table.dataSource = self
        table.delegate = self
        table.estimatedSectionHeaderHeight = .leastNonzeroMagnitude
        table.bounces = false
        return table
    }()
    
    open private(set) lazy var searchController: UISearchController = {
        let search = UISearchController()
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        return search
    }()
    
    public var searchResults: [ContentModel] = []
    public var timer: Timer?
    public var viewmodel: SearchListViewModel?
    
    open override func setupViews() {
        super.setupViews()
        view.addSubview(tableView)
    }
    
    open override func setupLayouts() {
        super.setupLayouts()
        
        tableView.addConstraint(top: (view.safeAreaLayoutGuide.topAnchor, 0),
                                bottom: (view.safeAreaLayoutGuide.bottomAnchor, 0),
                                leading: (view.safeAreaLayoutGuide.leadingAnchor, 0),
                                trailing: (view.safeAreaLayoutGuide.trailingAnchor, 0))
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        LMChatMain.analytics?.trackEvent(for: .chatroomSearchClosed, eventProperties: [:])
    }
}

// MARK: UITableView
extension SearchListViewController: UITableViewDataSource, UITableViewDelegate {
    open func numberOfSections(in tableView: UITableView) -> Int { searchResults.count }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults[section].data.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = searchResults[indexPath.section].data[indexPath.row] as? SearchMessageCell.ContentModel,
           let cell = tableView.dequeueReusableCell(SearchMessageCell.self) {
            cell.configure(with: data)
            return cell
        } else if let data = searchResults[indexPath.section].data[indexPath.row] as? SearchGroupCell.ContentModel,
                  let cell = tableView.dequeueReusableCell(SearchGroupCell.self) {
            cell.configure(with: data)
            return cell
        }
        
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { 
        searchResults[section].title
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        searchResults[section].title != nil ? 24 : 0.001
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == searchResults.count - 1,
           indexPath.row == searchResults[indexPath.section].data.count - 1 {
            self.showHideFooterLoader(isShow: true)
            viewmodel?.fetchMoreData()
        }
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = searchResults[indexPath.section].data[indexPath.row] as? SearchGroupCell.ContentModel {
            LMChatMain.analytics?.trackEvent(for: .chatroomSearched, eventProperties: [:])
            NavigationScreen.shared.perform(.chatroom(chatroomId: data.chatroomID, conversationId: nil), from: self, params: nil)
        } else if let data = searchResults[indexPath.section].data[indexPath.row] as? SearchMessageCell.ContentModel {
            LMChatMain.analytics?.trackEvent(for: .messageSearched, eventProperties: [:])
            NavigationScreen.shared.perform(.chatroom(chatroomId: data.chatroomID, conversationId: data.messageID), from: self, params: nil)
        }
    }
}


// MARK: UISearchResultsUpdating
extension SearchListViewController: UISearchBarDelegate {
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text,
              !text.isEmpty else {
            resetSearchData()
            return
        }
        
        tableView.backgroundView = LMChatSearchShimmerView(frame: tableView.bounds)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.viewmodel?.searchList(with: text)
        }
    }
    
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        LMChatMain.analytics?.trackEvent(for: .searchCrossIconClicked, eventProperties: [LMChatAnalyticsKeys.source.rawValue: LMChatAnalyticsSource.homeFeed.rawValue])
        
        resetSearchData()
    }
    
    public func resetSearchData() {
        timer?.invalidate()
        viewmodel?.searchList(with: "")
        searchResults.removeAll(keepingCapacity: true)
        tableView.backgroundView = nil
        tableView.reloadData()
    }
}


// MARK: SearchListViewProtocol
extension SearchListViewController: SearchListViewProtocol {
   public func updateSearchList(with data: [ContentModel]) {
       tableView.backgroundView = data.isEmpty ? SearchListNoResultView(frame: tableView.bounds) : nil
        showHideFooterLoader(isShow: false)
        self.searchResults = data
        tableView.reloadData()
    }
    
    public func showHideFooterLoader(isShow: Bool) {
        tableView.showHideFooterLoader(isShow: isShow)
    }
}
