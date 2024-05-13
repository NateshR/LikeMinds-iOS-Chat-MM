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
    func didTappedOnReaction(reaction: String, indexPath: IndexPath)
    func didTappedOnAttachmentOfMessage(url: String, indexPath: IndexPath)
    func didTappedOnGalleryOfMessage(attachmentIndex: Int, indexPath: IndexPath)
    func didTappedOnReplyPreviewOfMessage(indexPath: IndexPath)
    func contextMenuItemClicked(withType type: LMMessageActionType, atIndex indexPath: IndexPath, message: LMMessageListView.ContentModel.Message)
    func didReactOnMessage(reaction: String, indexPath: IndexPath)
    func getMessageContextMenu(_ indexPath: IndexPath, item: LMMessageListView.ContentModel.Message) -> UIMenu
    func trailingSwipeAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction?
    func didScrollTableView(_ scrollView: UIScrollView)
}

public enum LMMessageActionType: String {
    case delete
    case reply
    case copy
    case edit
    case select
    case invite
    case report
    case setTopic
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
            public let memberTitle: String?
            public let message: String?
            public let timestamp: Int?
            public let reactions: [Reaction]?
            public let attachments: [Attachment]?
            public let replied: [Message]?
            public let isDeleted: Bool?
            public let createdBy: String?
            public let createdByImageUrl: String?
            public let isIncoming: Bool?
            public let messageType: Int
            public let createdTime: String?
            public let ogTags: OgTags?
            public let isEdited: Bool?
            public let attachmentUploaded: Bool?
        }
        
        public struct Reaction {
            public let memberUUID: [String]
            public let reaction: String
            public let count: Int
        }
        
        public struct Attachment {
            public let fileUrl: String?
            public let thumbnailUrl: String?
            public let fileSize: Int?
            public let numberOfPages: Int?
            public let duration: Int?
            public let fileType: String?
            public let fileName: String?
        }
        
        public struct OgTags {
            public let link: String?
            public let thumbnailUrl: String?
            public let title: String?
            public let subtitle: String?
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
        table.register(LMUIComponents.shared.chatroomHeaderMessageCell)
        table.register(LMUIComponents.shared.chatMessageGalleryCell)
        table.register(LMUIComponents.shared.chatMessageDocumentCell)
        table.register(LMUIComponents.shared.chatMessageAudioCell)
        table.register(LMUIComponents.shared.chatMessageLinkPreviewCell)
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.clipsToBounds = true
        table.separatorStyle = .none
        table.backgroundView = loadingView
//        table.keyboardDismissMode = .interactive
        table.contentInset = .init(top: 0, left: 0, bottom: 14, right: 0)
        return table
    }()
    
    private(set) lazy var loadingView: LMMessageLoadingShimmerView = {
        let view = LMMessageLoadingShimmerView().translatesAutoresizingMaskIntoConstraints()
        view.setWidthConstraint(with: UIScreen.main.bounds.size.width)
        return view
    }()
    
    
    // MARK: Data Variables
    public let cellHeight: CGFloat = 60
    private var data: [BaseContentModel] = []
    public weak var delegate: LMMessageListViewDelegate?
    public var tableSections:[ContentModel] = []
    public var audioIndex: (section: Int, messageID: String)?
    public var currentLoggedInUserTagFormat: String = ""
    public var currentLoggedInUserReplaceTagFormat: String = ""
    
    let reactionHeight: CGFloat = 50.0
    let spaceReactionHeight: CGFloat = 10.0
    let menuHeight: CGFloat = 200
    var isMultipleSelectionEnable: Bool = false
    var selectedItems: [ContentModel.Message] = []
    
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
    
    
    // MARK: setupObservers
    open override func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(audioEnded), name: .LMChatAudioEnded, object: nil)
    }
    
    @objc 
    open func audioEnded(notification: Notification) {
        resetAudio()
    }
    
    open func reloadData() {
        tableSections.sort(by: {$0.timestamp < $1.timestamp})
        removeShimmer()
        tableView.reloadData()
    }
    
    func justReloadData() {
        tableSections.sort(by: {$0.timestamp < $1.timestamp})
        removeShimmer()
        tableView.reloadData()
    }
    
    func removeShimmer() {
        if !tableSections.isEmpty { tableView.backgroundView = nil }
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
    
    func scrollAtIndexPath(indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            guard let cell = self.tableView.cellForRow(at: indexPath) as? LMChatMessageCell else { return }
            cell.containerView.backgroundColor = Appearance.shared.colors.linkColor.withAlphaComponent(0.4)
            UIView.animate(withDuration: 2, delay: 1, usingSpringWithDamping: 1,
                           initialSpringVelocity: 1, options: .allowUserInteraction,
                           animations: { cell.containerView.backgroundColor = .clear }) {_ in}
        }
    }
    
    public func updateChatroomsData(chatroomData: [LMHomeFeedChatroomCell.ContentModel]) {
        reloadData()
    }
    
    public func updateExploreTabCount(exploreTabCount: LMHomeFeedExploreTabCell.ContentModel) {
        reloadData()
    }
    
    // we set a variable to hold the contentOffSet before scroll view scrolls
    open var lastContentOffset: CGFloat = 0
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
        var tableViewCell: UITableViewCell = UITableViewCell()
        switch item.messageType {
        case 0, 10:
            tableViewCell =  cellFor(rowAt: indexPath, tableView: tableView)
        case 111:
            if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatroomHeaderMessageCell) {
                cell.setData(with: .init(message: item), delegate: self, index: indexPath)
                cell.currentIndexPath = indexPath
                tableViewCell = cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatNotificationCell) {
                cell.setData(with: .init(message: item, loggedInUserTag: currentLoggedInUserTagFormat, loggedInUserReplaceTag: currentLoggedInUserReplaceTagFormat))
                tableViewCell =  cell
            }
        }
        return tableViewCell
    }
    
    func cellFor(rowAt indexPath: IndexPath, tableView: UITableView) -> LMChatMessageCell {
        let item = tableSections[indexPath.section].data[indexPath.row]
        var cell: LMChatMessageCell?
        if let attachments = item.attachments,
              !attachments.isEmpty,
            let type = attachments.first?.fileType {
            switch type {
            case "image", "video", "gif":
                cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatMessageGalleryCell)
            case "pdf", "document", "doc":
                cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatMessageDocumentCell)
            case "audio", "voice_note":
                cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatMessageAudioCell)
            default:
                cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatMessageCell)
            }
        } else if let ogTag = item.ogTags {
            cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatMessageLinkPreviewCell)
        } else {
            cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatMessageCell)
        }
        guard let cell else { return  LMChatMessageCell() }
        let isSelected =  selectedItems.firstIndex(where: {$0.messageId == item.messageId})
        cell.setData(with: .init(message: item, isSelected: isSelected != nil), delegate: self, index: indexPath)
        cell.currentIndexPath = indexPath
        cell.delegate = self
        if self.isMultipleSelectionEnable, !(item.isIncoming ?? false), item.isDeleted == false {
            cell.selectedButton.isHidden = false
        } else {
            cell.selectedButton.isHidden = true
        }
        return cell
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isMultipleSelectionEnable {
            self.delegate?.didTapOnCell(indexPath: indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatNotificationCell) {
            cell.infoLabel.text = tableSections[section].section
            cell.containerView.backgroundColor = Appearance.shared.colors.clear
            return cell
        }
        return LMView()
    }
    
    //Swipe to reply
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = tableSections[indexPath.section].data[indexPath.row]
        guard (item.messageType == 0 || item.messageType == 10) && item.isDeleted == false && !isMultipleSelectionEnable else { return nil }
        guard let replyAction = delegate?.trailingSwipeAction(forRowAtIndexPath: indexPath) else { return nil }
        let swipeConfig = UISwipeActionsConfiguration(actions: [replyAction])
        swipeConfig.performsFirstActionWithFullSwipe = true
        return swipeConfig
    }
    
    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            tableView.isEditing = false
        }
    }
    
    public func tableView(_ tableView: UITableView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    public func tableView(_ tableView: UITableView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
//        self.setEditing(true, animated: true)
    }
    
    public func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
    }
    
    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let item = tableSections[indexPath.section].data[indexPath.row]
        guard (item.messageType == 0 || item.messageType == 10) && item.isDeleted == false else { return false }
            return true
    }
    
    
    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScrollTableView(scrollView)
    }
    
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = tableSections[indexPath.section].data[indexPath.row]
        guard !self.isMultipleSelectionEnable, (item.messageType == 0 || item.messageType == 10) && (item.isDeleted != true) else { return nil }
        let identifier = NSString(string: "\(indexPath.row),\(indexPath.section)")
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return UIMenu() }
            return delegate?.getMessageContextMenu(indexPath, item: item)
        }
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? LMChatAudioViewCell)?.resetAudio()
        if indexPath.section == audioIndex?.section,
           tableSections[indexPath.section].data[indexPath.row].messageId == audioIndex?.messageID {
            LMChatAudioPlayManager.shared.resetAudioPlayer()
        }
    }

    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        makeTargetedPreview(for: configuration)
    }
    
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        makeTargetedDismissPreview(for: configuration)
    }
    
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.preferredCommitStyle = .pop
    }

    @available(iOS 13.0, *)
    func makeTargetedPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else { return nil }
        let values = identifier.components(separatedBy: ",")
        guard let row = Int(values.first ?? "0") else { return nil }
        guard let section = Int(values.last ?? "0") else { return nil }
        let indexPath = IndexPath(row: row, section: section)
        guard let cell = tableView.cellForRow(at: indexPath) as? LMChatMessageCell else { return nil }
        guard let snapshot = cell.resizableSnapshotView(from: CGRect(origin: .zero,
                                                                     size: CGSize(width: cell.bounds.width, height: min(cell.bounds.height, UIScreen.main.bounds.height - reactionHeight - spaceReactionHeight - menuHeight))),
                                                        afterScreenUpdates: false,
                                                        withCapInsets: UIEdgeInsets.zero) else { return nil }
        
        let reactionView = LMReactionPopupView()
        reactionView.onReaction = { [weak self] reactionType in
            guard let self = self else { return }
            delegate?.didReactOnMessage(reaction: reactionType.rawValue, indexPath: indexPath)
            (delegate as? UIViewController)?.dismiss(animated: true)
        }
        reactionView.layer.cornerRadius = 10
        reactionView.layer.masksToBounds = true
        reactionView.translatesAutoresizingMaskIntoConstraints = false
        
        snapshot.layer.cornerRadius = 10
        snapshot.layer.masksToBounds = true
        snapshot.translatesAutoresizingMaskIntoConstraints = false
        
        let container = UIView(frame: CGRect(origin: .zero,
                                             size: CGSize(width: cell.bounds.width,
                                                          height: snapshot.bounds.height + reactionHeight + spaceReactionHeight)))
        container.backgroundColor = .clear
        container.addSubview(reactionView)
        container.addSubview(snapshot)
        
        snapshot.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        snapshot.topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        snapshot.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        snapshot.bottomAnchor.constraint(equalTo: reactionView.topAnchor, constant: -spaceReactionHeight).isActive = true
        
        reactionView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10).isActive = true
        reactionView.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        reactionView.heightAnchor.constraint(equalToConstant: reactionHeight).isActive = true
        
        let centerPoint = CGPoint(x: cell.center.x, y: cell.center.y + 26)
        let previewTarget = UIPreviewTarget(container: tableView, center: centerPoint)
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            parameters.shadowPath = UIBezierPath()
        }
        return UITargetedPreview(view: container, parameters: parameters, target: previewTarget)
    }
    
    @available(iOS 13.0, *)
    func makeTargetedDismissPreview(for configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let identifier = configuration.identifier as? String else { return nil }
        let values = identifier.components(separatedBy: ",")
        guard let row = Int(values.first ?? "0") else { return nil }
        guard let section = Int(values.last ?? "0") else { return nil }
        let indexPath = IndexPath(row: row, section: section)
        guard let cell = tableView.cellForRow(at: indexPath) as? LMChatMessageCell else { return nil }
        guard let snapshot = cell.resizableSnapshotView(from: CGRect(origin: .zero,
                                                                     size: CGSize(width: cell.bounds.width, height: min(cell.bounds.height, UIScreen.main.bounds.height - reactionHeight - spaceReactionHeight - menuHeight))),
                                                        afterScreenUpdates: false,
                                                        withCapInsets: UIEdgeInsets.zero) else { return nil }
        
        let centerPoint = CGPoint(x: cell.center.x, y: cell.center.y)
        let previewTarget = UIPreviewTarget(container: tableView, center: centerPoint)
        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        if #available(iOS 14.0, *) {
            parameters.shadowPath = UIBezierPath()
        }
        return UITargetedPreview(view: snapshot, parameters: parameters, target: previewTarget)
    }
}


// MARK: LMChatAudioProtocol
extension LMMessageListView: LMChatAudioProtocol {
    public func pauseAudioPlayer() {
        LMChatAudioPlayManager.shared.stopAudio { }
    }
    
    public func didTapPlayPauseButton(for url: String, index: IndexPath) {
        resetAudio()
        
        guard tableSections.indices.contains(index.section),
              tableSections[index.section].data.indices.contains(index.row) else { return }
        
        let messageID = tableSections[index.section].data[index.row].messageId
        
        audioIndex = (index.section, messageID)
        
        LMChatAudioPlayManager.shared.startAudio(url: url) { [weak self] progress in
            (self?.tableView.cellForRow(at: index) as? LMChatAudioViewCell)?.seekSlider(to: Float(progress), url: url)
        }
    }
    
    public func didSeekTo(_ position: Float, _ url: String, index: IndexPath) {
        LMChatAudioPlayManager.shared.seekAt(position, url: url)
    }
    
    public func resetAudio() {
        if let audioIndex,
           tableSections.indices.contains(audioIndex.section),
           let row = tableSections[audioIndex.section].data.firstIndex(where: { $0.messageId == audioIndex.messageID }) {
            
            (tableView.cellForRow(at: .init(row: row, section: audioIndex.section)) as? LMChatAudioViewCell)?.resetAudio()
        }
        
        audioIndex = nil
    }
}

extension LMMessageListView: LMChatMessageCellDelegate {
    
    public func didTappedOnSelectionButton(indexPath: IndexPath?) {
        guard let indexPath else { return }
        let item = tableSections[indexPath.section].data[indexPath.row]
        let itemIndex = selectedItems.firstIndex(where: {$0.messageId == item.messageId})
        if let itemIndex {
            self.selectedItems.remove(at: itemIndex)
        } else {
            self.selectedItems.append(item)
        }
    }
    
    public func onClickReplyOfMessage(indexPath: IndexPath?) {
        guard let indexPath else { return }
        delegate?.didTappedOnReplyPreviewOfMessage(indexPath: indexPath)
    }
    
    public func onClickAttachmentOfMessage(url: String, indexPath: IndexPath?) {
        guard let indexPath else { return }
        delegate?.didTappedOnAttachmentOfMessage(url: url, indexPath: indexPath)
    }
    
    public func onClickGalleryOfMessage(attachmentIndex: Int, indexPath: IndexPath?) {
        guard let indexPath else { return }
        delegate?.didTappedOnGalleryOfMessage(attachmentIndex: attachmentIndex, indexPath: indexPath)
    }
    
    public func onClickReactionOfMessage(reaction: String, indexPath: IndexPath?) {
        guard let indexPath else { return }
        delegate?.didTappedOnReaction(reaction: reaction, indexPath: indexPath)
    }
}
