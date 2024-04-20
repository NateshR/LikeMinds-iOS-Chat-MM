//
//  LMExploreChatroomListView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LMChatUI_iOS

public protocol LMExploreChatroomListViewDelegate: AnyObject {
    func didTapOnCell(indexPath: IndexPath)
    func fetchMoreData()
}


@IBDesignable
open class LMExploreChatroomListView: LMView {
    
    public struct ContentModel {
        public let data: [Any]
        public let sectionOrder: Int
        
        init(data: [Any], sectionOrder: Int) {
            self.data = data
            self.sectionOrder = sectionOrder
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView().translatesAutoresizingMaskIntoConstraints()
        table.register(LMUIComponents.shared.exploreChatroomCell)
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.clipsToBounds = true
        table.separatorStyle = .none
        table.backgroundColor = .gray
        return table
    }()
    
    
    // MARK: Data Variables
    public let cellHeight: CGFloat = 60
    private var data: [LMHomeFeedChatroomCell.ContentModel] = []
    public weak var delegate: LMExploreChatroomListViewDelegate?
    public var tableSections:[ContentModel] = []
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(tableView)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        backgroundColor = Appearance.shared.colors.clear
        containerView.backgroundColor = Appearance.shared.colors.white
        tableView.backgroundColor = Appearance.shared.colors.clear
    }
    
    open func reloadData() {
        tableSections.sort(by: {$0.sectionOrder < $1.sectionOrder})
        tableView.reloadData()
    }
    
    public func updateChatroomsData(chatroomData: [LMExploreChatroomCell.ContentModel]) {
        tableSections.append(.init(data: chatroomData, sectionOrder: 1))
        reloadData()
    }
    
}


// MARK: UITableView
extension LMExploreChatroomListView: UITableViewDataSource, UITableViewDelegate {
    
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSections[section].data.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = tableSections[indexPath.section].data
        if let item = items[indexPath.row] as? LMExploreChatroomCell.ContentModel,
           let cell = tableView.dequeueReusableCell(LMUIComponents.shared.exploreChatroomCell) {
            cell.configure(with: item)
            if indexPath.row >= (items.count - 4) {
                self.delegate?.fetchMoreData()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didTapOnCell(indexPath: indexPath)
    }
}

