//
//  LMMessageListView.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 21/03/24.
//

import Foundation
import LMChatUI_iOS

public enum ScrollDirection : Int {
    case scroll_DOWN = 1
    case scroll_UP = 0
    case none = -1
}

public protocol LMMessageListViewDelegate: AnyObject {
    func didTapOnCell(indexPath: IndexPath)
    func fetchDataOnScroll(indexPath: IndexPath, direction: ScrollDirection)
}

@IBDesignable
open class LMMessageListView: LMView {
    
    public struct ContentModel {
        public var data: [Message]
        public let section: String
        public let timestamp: Int
        
        init(data: [Message], section: String, timestamp: Int) {
            self.data = data
            self.section = section
            self.timestamp = timestamp
        }
        
        public struct Message {
            public let messageId: String
            public let message: String?
            public let timestamp: Int?
            public let reactions: [Reaction]?
            public let attachments: [String]?
            public let replied: [Message]?
            public let isDeleted: Bool?
            public let createdBy: String?
            public let createdByImageUrl: String?
            public let isIncoming: Bool?
            public let messageType: Int
            public let createdTime: String?
        }
        
        public struct Reaction {
            public let memberUUID: String
            public let reaction: String
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView().translatesAutoresizingMaskIntoConstraints()
        table.register(LMUIComponents.shared.chatMessageCell)
        table.register(LMUIComponents.shared.chatNotificationCell)
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
    private var data: [BaseContentModel] = []
    public weak var delegate: LMMessageListViewDelegate?
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
        backgroundColor = Appearance.shared.colors.backgroundColor
        containerView.backgroundColor = Appearance.shared.colors.backgroundColor
        tableView.backgroundColor = Appearance.shared.colors.backgroundColor
    }
    
    open func reloadData() {
        tableSections.sort(by: {$0.timestamp < $1.timestamp})
        tableView.reloadData()
    }
    
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let indexPath = IndexPath(
                row: self.tableView.numberOfRows(inSection:  self.tableView.numberOfSections-1) - 1,
                section: self.tableView.numberOfSections - 1)
            if hasRowAtIndexPath(indexPath: indexPath) {
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
        
        func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
            return indexPath.section < tableView.numberOfSections && indexPath.row < tableView.numberOfRows(inSection: indexPath.section)
        }
    }
    
    public func updateChatroomsData(chatroomData: [LMHomeFeedChatroomCell.ContentModel]) {
//        if let index = tableSections.firstIndex(where: {$0.sectionType == .chatrooms}) {
//            tableSections[index] = .init(data: chatroomData, sectionType: .chatrooms, sectionOrder: 2)
//        } else {
//            tableSections.append(.init(data: chatroomData, sectionType: .chatrooms, sectionOrder: 2))
//        }
        reloadData()
    }
    
    public func updateExploreTabCount(exploreTabCount: LMHomeFeedExploreTabCell.ContentModel) {
//        if let index = tableSections.firstIndex(where: {$0.sectionType == .exploreTab}) {
//            tableSections[index] = .init(data: [exploreTabCount], sectionType: .exploreTab, sectionOrder: 1)
//        } else {
//            tableSections.append(.init(data: [exploreTabCount], sectionType: .exploreTab, sectionOrder: 1))
//        }
        reloadData()
    }
    
}


// MARK: UITableView
extension LMMessageListView: UITableViewDataSource, UITableViewDelegate {
    
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableSections[section].data.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableSections[indexPath.section].data[indexPath.row]
        switch item.messageType {
        case 0:
            if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatMessageCell) {
                cell.setData(with: .init(message: item))
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatNotificationCell) {
                cell.setData(with: .init(message: item))
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
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatNotificationCell) {
            cell.infoLabel.text = tableSections[section].section
            return cell
        }
        return LMView()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = tableView.contentOffset.y
        let contentHeight = tableView.contentSize.height

        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.y > 0 {
            guard let visibleIndexPaths = self.tableView.indexPathsForVisibleRows,
                  let lastIndexPath = visibleIndexPaths.last else {return}
            delegate?.fetchDataOnScroll(indexPath: lastIndexPath, direction: .scroll_UP)
            
        } else {
            guard let visibleIndexPaths = self.tableView.indexPathsForVisibleRows,
                  let firstIndexPath = visibleIndexPaths.first else {return}
            delegate?.fetchDataOnScroll(indexPath: firstIndexPath, direction: .scroll_DOWN)
        }
    }

    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let replyAction = UIAction(title: NSLocalizedString("Reply", comment: ""),
                                      image: UIImage(systemName: "arrow.down.square")) { action in
            }
            
            let editAction = UIAction(title: NSLocalizedString("Edit", comment: ""),
                                       image: UIImage(systemName: "pencil")) { action in
            }
            
            let copyAction = UIAction(title: NSLocalizedString("Copy", comment: ""),
                                        image: UIImage(systemName: "doc.on.doc")) { action in
            }
            
            let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""),
                                        image: UIImage(systemName: "trash"),
                                        attributes: .destructive) { action in
            }
            return UIMenu(title: "", children: [replyAction, editAction, copyAction, deleteAction])
        }
    }
}


