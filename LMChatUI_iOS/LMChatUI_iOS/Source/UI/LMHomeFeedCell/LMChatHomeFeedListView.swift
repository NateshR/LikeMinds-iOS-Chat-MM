//
//  LMChatHomeFeedListView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 09/02/24.
//

import Foundation
import LMChatUI_iOS

protocol BaseContentModel {}

public protocol LMHomFeedListViewDelegate: AnyObject {
    func didTapOnCell(indexPath: IndexPath)
    func fetchMoreData()
}

public enum HomeFeedSection: String {
    case exploreTab = "Explore Tab"
    case chatrooms = "Chatrooms"
}

@IBDesignable
open class LMChatHomeFeedListView: LMView {
    
    public struct ContentModel {
        public let data: [Any]
        public let sectionType: HomeFeedSection
        public let sectionOrder: Int
        
        init(data: [Any], sectionType: HomeFeedSection, sectionOrder: Int) {
            self.data = data
            self.sectionType = sectionType
            self.sectionOrder = sectionOrder
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var loadingView: LMChatHomeFeedShimmerView = {
        let view = LMChatHomeFeedShimmerView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: UIScreen.main.bounds.size.width)
        return view
    }()
    
    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView().translatesAutoresizingMaskIntoConstraints()
        table.register(LMUIComponents.shared.homeFeedChatroomCell)
        table.register(LMUIComponents.shared.homeFeedExploreTabCell)
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.clipsToBounds = true
        table.separatorStyle = .none
        return table
    }()
    
    
    // MARK: Data Variables
    public let cellHeight: CGFloat = 60
    private var data: [LMChatHomeFeedChatroomCell.ContentModel] = []
    public weak var delegate: LMHomFeedListViewDelegate?
    public var tableSections:[ContentModel] = []
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        addSubview(containerView)
        containerView.addSubview(tableView)
        tableView.backgroundView = loadingView
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
        self.tableView.reloadData()
    }
    
    public func updateChatroomsData(chatroomData: [LMChatHomeFeedChatroomCell.ContentModel]) {
        if let index = tableSections.firstIndex(where: {$0.sectionType == .chatrooms}) {
            tableSections[index] = .init(data: chatroomData, sectionType: .chatrooms, sectionOrder: 2)
        } else {
            if !chatroomData.isEmpty {
                tableSections.append(.init(data: chatroomData, sectionType: .chatrooms, sectionOrder: 2))
                tableView.backgroundView = nil
            }
        }
        reloadData()
    }
    
    public func updateExploreTabCount(exploreTabCount: LMChatHomeFeedExploreTabCell.ContentModel) {
        if let index = tableSections.firstIndex(where: {$0.sectionType == .exploreTab}) {
            tableSections[index] = .init(data: [exploreTabCount], sectionType: .exploreTab, sectionOrder: 1)
        } else {
            tableSections.append(.init(data: [exploreTabCount], sectionType: .exploreTab, sectionOrder: 1))
        }
        reloadData()
    }
    
}


// MARK: UITableView
extension LMChatHomeFeedListView: UITableViewDataSource, UITableViewDelegate {
    

    open func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSections[section].data.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let items = tableSections[indexPath.section].data
        
        switch tableSections[indexPath.section].sectionType {
        case .exploreTab:
            if let item = items[indexPath.row] as? LMChatHomeFeedExploreTabCell.ContentModel,
               let cell = tableView.dequeueReusableCell(LMUIComponents.shared.homeFeedExploreTabCell) {
                cell.configure(with: item)
                return cell
            }
        case .chatrooms:
            if let item = items[indexPath.row] as? LMChatHomeFeedChatroomCell.ContentModel,
               let cell = tableView.dequeueReusableCell(LMUIComponents.shared.homeFeedChatroomCell) {
                cell.configure(with: item)
                if indexPath.row >= (items.count - 4) {
                    self.delegate?.fetchMoreData()
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didTapOnCell(indexPath: indexPath)
    }
}

