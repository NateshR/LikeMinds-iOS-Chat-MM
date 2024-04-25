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
        }
        
        public struct Reaction {
            public let memberUUID: [String]
            public let reaction: String
            public let count: Int
        }
        
        public struct Attachment {
            public let fileUrl: String?
            public let thumbnailUrl: String?
            public let fileSize: Int64?
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
    public var audioIndex: IndexPath?
    
    let reactionHeight: CGFloat = 50.0
    let spaceReactionHeight: CGFloat = 10.0
    let menuHeight: CGFloat = 200
    
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
        if let url = notification.object as? URL {
            
        }
    }
    
    open func reloadData() {
        tableSections.sort(by: {$0.timestamp < $1.timestamp})
        tableView.reloadData()
    }
    
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
            self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        }
    }
    
    public func updateChatroomsData(chatroomData: [LMHomeFeedChatroomCell.ContentModel]) {
        reloadData()
    }
    
    public func updateExploreTabCount(exploreTabCount: LMHomeFeedExploreTabCell.ContentModel) {
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
                cell.setData(with: .init(message: item), delegate: self, index: indexPath)
                cell.currentIndexPath = indexPath
                cell.delegate = self
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatroomHeaderMessageCell) {
                cell.setData(with: .init(message: item), delegate: self, index: indexPath)
                cell.currentIndexPath = indexPath
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
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) { }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didTapOnCell(indexPath: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.chatNotificationCell) {
            cell.infoLabel.text = tableSections[section].section
            cell.containerView.backgroundColor = Appearance.shared.colors.clear
            return cell
        }
        return LMView()
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = tableSections[indexPath.section].data[indexPath.row]
        guard item.messageType == 0 && (item.isDeleted != true) else { return nil }
        let identifier = NSString(string: "\(indexPath.row),\(indexPath.section)")
        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return UIMenu() }
            return self.createContextMenu(indexPath, item: item)
        }
    }
    
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? LMChatMessageCell)?.resetAudio()
        if indexPath == audioIndex {
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
//        reactionView.widthAnchor.constraint(equalToConstant: 50*4).isActive = true
        reactionView.heightAnchor.constraint(equalToConstant: reactionHeight).isActive = true
        
        let centerPoint = CGPoint(x: cell.center.x, y: cell.center.y)
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
        guard let row = Int(identifier) else { return nil }
        guard let cell = tableView.cellForRow(at: .init(row: row, section: 0)) as? LMChatMessageCell else { return nil }
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
    
    @available(iOS 13.0, *)
    func createContextMenu(_ indexPath: IndexPath, item: ContentModel.Message) -> UIMenu {
        let replyAction = UIAction(title: NSLocalizedString("Reply", comment: ""),
                                   image: UIImage(systemName: "arrow.down.square")) { [weak self] action in
            self?.delegate?.contextMenuItemClicked(withType: .reply, atIndex: indexPath, message: item)
        }
        
        let editAction = UIAction(title: NSLocalizedString("Edit", comment: ""),
                                  image: UIImage(systemName: "pencil")) { [weak self] action in
            self?.delegate?.contextMenuItemClicked(withType: .edit, atIndex: indexPath, message: item)
        }
        
        let copyAction = UIAction(title: NSLocalizedString("Copy", comment: ""),
                                  image: UIImage(systemName: "doc.on.doc")) { [weak self] action in
            self?.delegate?.contextMenuItemClicked(withType: .copy, atIndex: indexPath, message: item)
        }
        
        let deleteAction = UIAction(title: NSLocalizedString("Delete", comment: ""),
                                    image: UIImage(systemName: "trash"),
                                    attributes: .destructive) { [weak self] action in
            self?.delegate?.contextMenuItemClicked(withType: .delete, atIndex: indexPath, message: item)
        }
        return UIMenu(title: "", children: [replyAction, editAction, copyAction, deleteAction])
    }
}


// MARK: LMChatAudioProtocol
extension LMMessageListView: LMChatAudioProtocol {
    public func didTapPlayPauseButton(for url: String, index: IndexPath) {
        if let audioIndex {
            (tableView.cellForRow(at: audioIndex) as? LMChatMessageCell)?.resetAudio()
        }
        
        audioIndex = index
        
        LMChatAudioPlayManager.shared.startAudio(url: url) { [weak self] progress in
            (self?.tableView.cellForRow(at: index) as? LMChatMessageCell)?.seekSlider(to: Float(progress), url: url)
        }
    }
    
    public func didSeekTo(_ position: Float, _ url: String, index: IndexPath) {
        LMChatAudioPlayManager.shared.seekAt(position, url: url)
    }
}

extension LMMessageListView: LMChatMessageCellDelegate {
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
