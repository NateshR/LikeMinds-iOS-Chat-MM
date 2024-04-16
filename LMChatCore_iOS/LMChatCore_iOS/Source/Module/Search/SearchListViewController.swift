//
//  SearchListViewController.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 16/04/24.
//

import LMChatUI_iOS
import UIKit

public class SearchListViewController: LMViewController {
    lazy var tableView: LMTableView = {
        let table = LMTableView(frame: .zero, style: .grouped).translatesAutoresizingMaskIntoConstraints()
        table.register(SearchMessageCell.self)
        table.register(SearchGroupCell.self)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController()
        search.searchResultsUpdater = self
        return search
    }()
    
    var searchResults: [SearchCellProtocol] = []
    var timer: Timer?
    var viewmodel: SearchListViewModel?
    
    open override func setupViews() {
        super.setupViews()
        view.addSubviewWithDefaultConstraints(tableView)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        dummyData()
        
        tableView.reloadData()
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        
        viewmodel?.searchList()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    
    func dummyData() {
        searchResults.append(SearchGroupCell.ContentModel(chatroomID: "ABC", image: "https://img.freepik.com/free-photo/woman-scrolling-laptop_53876-167050.jpg", chatroomName: "Testing1"))
        
        searchResults.append(SearchGroupCell.ContentModel(chatroomID: "ABC", image: "https://img.freepik.com/free-photo/woman-scrolling-laptop_53876-167050.jpg", chatroomName: "Testing2"))
        
        searchResults.append(SearchMessageCell.ContentModel(chatroomID: "ABC", messageID: "XYZ", title: "Hello i'm underwater", subtitle: "Notification: T", date: Date(), isJoined: true))
        searchResults.append(SearchMessageCell.ContentModel(chatroomID: "ABC", messageID: "XYZ", title: "Hogging my crank", subtitle: "Notification: T", date: Date(), isJoined: false))
    }
}

// MARK: UITableView
extension SearchListViewController: UITableViewDataSource, UITableViewDelegate {
    open func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = searchResults[indexPath.row] as? SearchMessageCell.ContentModel,
           let cell = tableView.dequeueReusableCell(SearchMessageCell.self) {
            cell.configure(with: data)
            return cell
        } else if let data = searchResults[indexPath.row] as? SearchGroupCell.ContentModel,
                  let cell = tableView.dequeueReusableCell(SearchGroupCell.self) {
            cell.configure(with: data)
            return cell
        }
        
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { 
        section == 1 ? "Messages" : nil
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        section == 1 ? 24 : .leastNonzeroMagnitude
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNonzeroMagnitude
    }
}


// MARK: UISearchResultsUpdating
extension SearchListViewController: UISearchResultsUpdating {
    open func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            timer?.invalidate()
            // Shows No Results
            searchResults.removeAll(keepingCapacity: true)
            tableView.reloadData()
            return
        }
        
        timer?.invalidate()
        timer = Timer(timeInterval: 0.5, repeats: false) { _ in
            
        }
    }
}


// MARK: SearchListViewProtocol
extension SearchListViewController: SearchListViewProtocol {
    
}
