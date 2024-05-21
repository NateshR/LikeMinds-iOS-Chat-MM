//
//  LMChatMessageListViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 18/03/24.
//

import AVFoundation
import LMChatUI_iOS
import GiphyUISDK
import UIKit

protocol LMChatMessageListControllerDelegate: AnyObject {
    func postMessage(message: String?,
                     filesUrls: [LMChatAttachmentMediaData]?,
                     shareLink: String?,
                     replyConversationId: String?,
                     replyChatRoomId: String?)
    func postMessageWithAttachment()
    func postMessageWithGifAttachment()
    func postMessageWithAudioAttachment(with url: URL)
}

open class LMChatMessageListViewController: LMViewController {
    // MARK: UI Elements
    open private(set) lazy var bottomMessageBoxView: LMChatBottomMessageComposerView = {
        let view = LMChatBottomMessageComposerView().translatesAutoresizingMaskIntoConstraints()
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.delegate = self
        view.inputTextView.mentionDelegate = self
        return view
    }()
    
    open private(set) lazy var scrollToBottomButton: LMButton = {
        let button = LMButton().translatesAutoresizingMaskIntoConstraints()
        button.setImage(Constants.shared.images.downChevronArrowIcon, for: .normal)
        button.contentMode = .scaleToFill
        button.setWidthConstraint(with: 40)
        button.setHeightConstraint(with: 40)
        button.backgroundColor = Appearance.shared.colors.white.withAlphaComponent(0.8)
        button.tintColor = Appearance.shared.colors.black
        button.cornerRadius(with: 20)
        button.addTarget(self, action: #selector(scrollToBottomClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var messageListView: LMChatMessageListView = {
        let view = LMChatMessageListView().translatesAutoresizingMaskIntoConstraints()
        view.backgroundColor = .systemGroupedBackground
        view.delegate = self
        view.cellDelegate = self
        view.audioDelegate = self
        view.chatroomHeaderCellDelegate = self
        return view
    }()
    
    open private(set) lazy var chatroomTopicBar: LMChatroomTopicView = {
        let view = LMChatroomTopicView().translatesAutoresizingMaskIntoConstraints()
//        view.backgroundColor = .systemGroupedBackground
//        view.delegate = self
        return view
    }()
    
    open private(set) lazy var taggingListView: LMChatTaggingListView = {
        let view = LMChatTaggingListView().translatesAutoresizingMaskIntoConstraints()
        let viewModel = LMChatTaggingListViewModel(delegate: view)
        view.viewModel = viewModel
        view.delegate = self
        return view
    }()
    
    open private(set) var taggingViewHeightConstraints: NSLayoutConstraint?
    
    public var viewModel: LMChatMessageListViewModel?
    weak var delegate: LMChatMessageListControllerDelegate?
    var linkDetectorTimer: Timer?
    var bottomTextViewContainerBottomConstraints: NSLayoutConstraint?
    
    open private(set) lazy var deleteMessageBarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: Constants.shared.images.deleteIcon, style: .plain, target: self, action: #selector(deleteSelectedMessageAction))
        return buttonItem
    }()
    
    open private(set) lazy var cancelSelectionsBarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: Constants.shared.images.crossIcon, style: .plain, target: self, action: #selector(cancelSelectedMessageAction))
        return buttonItem
    }()
    
    open private(set) lazy var copySelectedMessagesBarItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: Constants.shared.images.copyIcon, style: .plain, target: self, action: #selector(copySelectedMessageAction))
        return buttonItem
    }()
    
    var isLoadingMoreData: Bool = false
    var lastSectionItem: LMChatMessageListView.ContentModel?
    var lastRowItem: LMChatMessageListView.ContentModel.Message?
    let backButtonItem = LMBarButtonItem()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationTitleAndSubtitle(with: "Chatroom", subtitle: nil, alignment: .center)
        setupNavigationBar()
        
        viewModel?.getInitialData()
        viewModel?.syncConversation()
        
        setRightNavigationWithAction(title: nil, image: Constants.shared.images.ellipsisCircleIcon, style: .plain, target: self, action: #selector(chatroomActions))
        setupBackButtonItemWithImageView()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupBackButtonItemWithImageView() {
        backButtonItem.actionButton.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
        navigationItem.leftItemsSupplementBackButton = false
        navigationItem.leftBarButtonItem = backButtonItem
    }
    
    open override func setupAppearance() {
        super.setupAppearance()
        scrollToBottomButton.addShadow()
        chatroomTopicBar.addShadow()
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        self.view.addSubview(messageListView)
        self.view.addSubview(bottomMessageBoxView)
        self.view.addSubview(chatroomTopicBar)
        self.view.addSubview(scrollToBottomButton)
        bottomMessageBoxView.addOnVerticleStackView.insertArrangedSubview(taggingListView, at: 0)
        bottomMessageBoxView.inputTextView.placeHolderText = "Type your response"
        chatroomTopicBar.onTopicViewClick = {[weak self] topicId in
            self?.topicBarClicked(topicId: topicId)
        }
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        bottomTextViewContainerBottomConstraints = bottomMessageBoxView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        bottomTextViewContainerBottomConstraints?.isActive = true
                                   
        NSLayoutConstraint.activate([
            chatroomTopicBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatroomTopicBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatroomTopicBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            messageListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messageListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messageListView.bottomAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor),
            messageListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            scrollToBottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            scrollToBottomButton.bottomAnchor.constraint(equalTo: bottomMessageBoxView.topAnchor, constant: -10),
            
            bottomMessageBoxView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomMessageBoxView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        taggingViewHeightConstraints = taggingListView.setHeightConstraint(with: 0)
    }
    
    @objc
    open override func keyboardWillShow(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        self.bottomTextViewContainerBottomConstraints?.isActive = false
        self.bottomTextViewContainerBottomConstraints?.constant = -((frame.size.height - self.view.safeAreaInsets.bottom))
        self.bottomTextViewContainerBottomConstraints?.isActive = true
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    open override func keyboardWillHide(_ sender: Notification) {
        self.bottomTextViewContainerBottomConstraints?.isActive = false
        self.bottomTextViewContainerBottomConstraints?.constant = 0
        self.bottomTextViewContainerBottomConstraints?.isActive = true
        UIView.animate(withDuration: 0.3) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    open override func setupObservers() {
        super.setupObservers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(audioEnded), name: .LMChatAudioEnded, object: nil)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LMChatAudioRecordManager.shared.deleteAudioRecording()
        LMChatAudioPlayManager.shared.resetAudioPlayer()
        self.view.endEditing(true)
    }
    
    @objc
    open func chatroomActions() {
        self.view.endEditing(true)
        guard let actions = viewModel?.chatroomActionData?.chatroomActions else { return }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for item in actions {
            let actionItem = UIAlertAction(title: item.title, style: UIAlertAction.Style.default) {[weak self] (UIAlertAction) in
                self?.viewModel?.performChatroomActions(action: item)
            }
            alert.addAction(actionItem)
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (UIAlertAction) in
        }
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    open func scrollToBottomClicked(_ sender: UIButton) {
        self.scrollToBottomButton.isHidden = true
        viewModel?.fetchBottomConversations()
    }
    
    @objc
    open func deleteSelectedMessageAction() {
        guard !messageListView.selectedItems.isEmpty else { return }
        deleteMessageConfirmation(messageListView.selectedItems.compactMap({$0.messageId}))
    }
    
    func deleteMessageConfirmation(_ conversationIds: [String]) {
        let alert = UIAlertController(title: "Delete Message?", message: Constants.shared.strings.warningMessageForDeletion, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self] action in
            self?.viewModel?.deleteConversations(conversationIds: conversationIds)
            self?.cancelSelectedMessageAction()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc
    open func copySelectedMessageAction() {
        guard !messageListView.selectedItems.isEmpty else { return }
        viewModel?.copyConversation(conversationIds: messageListView.selectedItems.compactMap({$0.messageId}))
        cancelSelectedMessageAction()
    }
    
    @objc
    open func cancelSelectedMessageAction() {
        messageListView.isMultipleSelectionEnable = false
        messageListView.selectedItems.removeAll()
        navigationItem.rightBarButtonItems = nil
        setRightNavigationWithAction(title: nil, image: Constants.shared.images.ellipsisCircleIcon, style: .plain, target: self, action: #selector(chatroomActions))
        updateChatroomSubtitles()
        memberRightsCheck()
        messageListView.justReloadData()
    }
    
    open func multipleSelectionEnable() {
        let barButtonItems: [UIBarButtonItem] = [cancelSelectionsBarItem, copySelectedMessagesBarItem, deleteMessageBarItem]
        navigationItem.rightBarButtonItems = barButtonItems
        bottomMessageBoxView.enableOrDisableMessageBox(withMessage: "", isEnable: false)
        navigationTitleView.isHidden = true
    }
    
    public func updateChatroomSubtitles() {
        navigationTitleView.isHidden = false
        let participantCount = viewModel?.chatroomActionData?.participantCount ?? 0
        let subtitle = participantCount > 0 ? "\(participantCount) participants" : ""
        setNavigationTitleAndSubtitle(with: viewModel?.chatroomViewData?.header, subtitle: subtitle)
        
        if viewModel?.chatroomViewData?.type == 7 && viewModel?.memberState?.state != 1 {
            bottomMessageBoxView.enableOrDisableMessageBox(withMessage: Constants.shared.strings.restrictForAnnouncement, isEnable: false)
        } else {
            bottomMessageBoxView.enableOrDisableMessageBox(withMessage: Constants.shared.strings.restrictByManager, isEnable: (viewModel?.chatroomViewData?.memberCanMessage ?? true))
        }
    }
    
    func topicBarClicked(topicId: String) {
        guard let chatroom = viewModel?.chatroomViewData else {
            return
        }
        viewModel?.fetchIntermediateConversations(chatroom: chatroom, conversationId: topicId)
    }
    
    public func memberRightsCheck() {
        if viewModel?.checkMemberRight(.respondsInChatRoom) == false {
            bottomMessageBoxView.enableOrDisableMessageBox(withMessage: Constants.shared.strings.restrictByManager, isEnable: false)
        }
    }
    
}

extension LMChatMessageListViewController: LMMessageListViewModelProtocol {
    
    public func scrollToSpecificConversation(indexPath: IndexPath) {
        reloadChatMessageList()
        self.messageListView.scrollAtIndexPath(indexPath: indexPath)
    }
    
    public func reloadChatMessageList() {
        messageListView.tableSections = viewModel?.messagesList ?? []
        messageListView.currentLoggedInUserTagFormat = viewModel?.loggedInUserTagValue ?? ""
        messageListView.currentLoggedInUserReplaceTagFormat = viewModel?.loggedInUserReplaceTagValue ?? ""
        messageListView.reloadData()
        bottomMessageBoxView.inputTextView.chatroomId = viewModel?.chatroomViewData?.id ?? ""
    }
    
    public func reloadData(at: ScrollDirection) {
        if at == .scroll_UP {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
                guard let self else { return }
                messageListView.tableSections = viewModel?.messagesList ?? []
                messageListView.reloadData()
                guard let lastSectionItem,
                      let lastRowItem,
                    let section = messageListView.tableSections.firstIndex(where: {$0.section == lastSectionItem.section}),
                      let row = messageListView.tableSections[section].data.firstIndex(where: {$0.messageId == lastRowItem.messageId}) else { return }
                
                messageListView.tableView.scrollToRow(at: IndexPath(row: row, section: section), at: .top, animated: false)
            }
        } else {
            messageListView.tableSections = viewModel?.messagesList ?? []
            messageListView.reloadData()
        }
    }
    
    public func scrollToBottom() {
        reloadChatMessageList()
        messageListView.scrollToBottom()
        bottomMessageBoxView.inputTextView.chatroomId = viewModel?.chatroomViewData?.id ?? ""
        updateChatroomSubtitles()
        self.scrollToBottomButton.isHidden = true
    }
    
    public func updateTopicBar() {
        if let topic = viewModel?.chatroomTopic {
            chatroomTopicBar.setData(.init(title: GetAttributedTextWithRoutes.getAttributedText(from: topic.answer).string, createdBy: viewModel?.chatroomViewData?.member?.name ?? "", chatroomImageUrl: viewModel?.chatroomViewData?.chatroomImageUrl ?? "", topicId: topic.id ?? ""))
        } else {
            chatroomTopicBar.setData(.init(title: viewModel?.chatroomViewData?.title ?? "", createdBy: viewModel?.chatroomViewData?.member?.name ?? "", chatroomImageUrl: viewModel?.chatroomViewData?.chatroomImageUrl ?? "", topicId: viewModel?.chatroomViewData?.id ?? ""))
        }
        
        backButtonItem.imageView.kf.setImage(with: URL(string: viewModel?.chatroomViewData?.chatroomImageUrl ?? ""), placeholder: UIImage.generateLetterImage(name: viewModel?.chatroomViewData?.header ?? ""))
    }
}

extension LMChatMessageListViewController: LMChatMessageListViewDelegate {
    
    public func didCancelUploading(messageId: String) {
        LMChatAWSManager.shared.cancelAllTaskFor(groupId: messageId)
    }
    
    public func didRetryUploading(messageId: String) {
        LMChatAWSManager.shared.resumeAllTaskFor(groupId: messageId)
    }
    
    public func didScrollTableView(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if let lastSection = messageListView.tableSections.last {
            let indexPath = IndexPath(row: (lastSection.data.count - 1), section: messageListView.tableSections.count - 1)
            if let _ = messageListView.tableView.cellForRow(at: indexPath) {
                scrollToBottomButton.isHidden = true
            } else {
                scrollToBottomButton.isHidden = false
            }
        }
        
        // Check if user scrolled to the top
        if contentOffsetY <= 20 && !isLoadingMoreData && viewModel?.fetchingInitialBottomData == false {
            print("end dragged top!$!$")
            guard let visibleIndexPaths = messageListView.tableView.indexPathsForVisibleRows,
                  let firstIndexPath = visibleIndexPaths.first else {return}
            isLoadingMoreData = true
            
            fetchDataOnScroll(indexPath: firstIndexPath, direction: .scroll_UP)
        }
        
        // Check if user scrolled to the bottom
        if contentOffsetY + frameHeight >= contentHeight && !isLoadingMoreData && viewModel?.fetchingInitialBottomData == false {
            print("end dragged bottom!$!$")
            guard let visibleIndexPaths = messageListView.tableView.indexPathsForVisibleRows,
                  let lastIndexPath = visibleIndexPaths.last else {return}
            isLoadingMoreData = true
            fetchDataOnScroll(indexPath: lastIndexPath, direction: .scroll_DOWN)
        }
    }

    public func getMessageContextMenu(_ indexPath: IndexPath, item: LMChatMessageListView.ContentModel.Message) -> UIMenu {
        
        if item.messageType == LMChatMessageListView.chatroomHeader {
            return contextMenuForChatroomData(indexPath, item: item)
        }
        
        var actions: [UIAction] = []
        let replyAction = UIAction(title: Constants.shared.strings.reply,
                                   image: Constants.shared.images.replyIcon) { [weak self] action in
            self?.contextMenuItemClicked(withType: .reply, atIndex: indexPath, message: item)
        }
        actions.append(replyAction)
        if let message = item.message, !message.isEmpty {
            let copyAction = UIAction(title: Constants.shared.strings.copy,
                                      image: Constants.shared.images.copyIcon) { [weak self] action in
                self?.contextMenuItemClicked(withType: .copy, atIndex: indexPath, message: item)
            }
            actions.append(copyAction)
        }
        
        if viewModel?.isAdmin() == true {
            let setTopicAction = UIAction(title: Constants.shared.strings.setTopic,
                                      image: Constants.shared.images.documentsIcon) { [weak self] action in
                self?.contextMenuItemClicked(withType: .setTopic, atIndex: indexPath, message: item)
            }
            actions.append(setTopicAction)
        }
        
        if item.isIncoming == false, viewModel?.checkMemberRight(.respondsInChatRoom) == true {
            if item.message?.isEmpty == false {
                let editAction = UIAction(title: Constants.shared.strings.edit,
                                          image:Constants.shared.images.pencilIcon) { [weak self] action in
                    self?.contextMenuItemClicked(withType: .edit, atIndex: indexPath, message: item)
                }
                actions.append(editAction)
            }
            
            let deleteAction = UIAction(title: Constants.shared.strings.delete,
                                        image: Constants.shared.images.trashIcon,
                                        attributes: .destructive) { [weak self] action in
                self?.contextMenuItemClicked(withType: .delete, atIndex: indexPath, message: item)
            }
            let selectAction = UIAction(title: Constants.shared.strings.select,
                                        image: Constants.shared.images.checkmarkCircleIcon) { [weak self] action in
                self?.contextMenuItemClicked(withType: .select, atIndex: indexPath, message: item)
            }
            actions.append(deleteAction)
            actions.append(selectAction)
        } else {
            let reportAction = UIAction(title: Constants.shared.strings.reportMessage) { [weak self] action in
                self?.contextMenuItemClicked(withType: .report, atIndex: indexPath, message: item)
            }
            actions.append(reportAction)
        }
        
        return UIMenu(title: "", children: actions)
    }
    
    public func contextMenuForChatroomData(_ indexPath: IndexPath, item: LMChatMessageListView.ContentModel.Message) -> UIMenu {
        var actions: [UIAction] = []
        let replyAction = UIAction(title: Constants.shared.strings.reply,
                                   image: Constants.shared.images.replyIcon) { [weak self] action in
            self?.contextMenuItemClicked(withType: .reply, atIndex: indexPath, message: item)
        }
        actions.append(replyAction)
        if let message = item.message, !message.isEmpty {
            let copyAction = UIAction(title: Constants.shared.strings.copy,
                                      image: Constants.shared.images.copyIcon) { [weak self] action in
                self?.contextMenuItemClicked(withType: .copy, atIndex: indexPath, message: item)
            }
            actions.append(copyAction)
        }
        
        return UIMenu(title: "", children: actions)
    }
    
    public func trailingSwipeAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction? {
        let item = messageListView.tableSections[indexPath.section].data[indexPath.row]
        guard viewModel?.checkMemberRight(.respondsInChatRoom) == true, item.isDeleted == false else { return nil }
        let action = UIContextualAction(style: .normal,
                                        title: "") {[weak self] (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self?.contextMenuItemClicked(withType: .reply, atIndex: indexPath, message: item)
            completionHandler(true)
        }
        let swipeReplyImage = Constants.shared.images.replyIcon
        action.image = swipeReplyImage
        action.backgroundColor = UIColor(red: 208.0 / 255.0, green: 216.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
        return action
    }
    
    public func didReactOnMessage(reaction: String, indexPath: IndexPath) {
        let message = messageListView.tableSections[indexPath.section].data[indexPath.row]
        if reaction == "more" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
                guard let self else { return }
                let emojiPicker: NavigationActions = message.messageType == LMChatMessageListView.chatroomHeader ? .emojiPicker(conversationId: nil, chatroomId: message.messageId) : .emojiPicker(conversationId: message.messageId, chatroomId: nil)
                NavigationScreen.shared.perform(emojiPicker, from: self, params: nil)
            }
        } else {
            if message.messageType == LMChatMessageListView.chatroomHeader { 
                viewModel?.putChatroomReaction(chatroomId: message.messageId, reaction: reaction)
            } else {
                viewModel?.putConversationReaction(conversationId: message.messageId, reaction: reaction)
            }
        }
    }
    
    public func contextMenuItemClicked(withType type: LMMessageActionType, atIndex indexPath: IndexPath, message: LMChatMessageListView.ContentModel.Message) {
        switch type {
        case .delete:
            deleteMessageConfirmation([message.messageId])
        case .edit:
            viewModel?.editConversation(conversationId: message.messageId)
            guard let messageText = viewModel?.editChatMessage?.answer.replacingOccurrences(of: GiphyAPIConfiguration.gifMessage, with: "").trimmingCharacters(in: .whitespacesAndNewlines), !messageText.isEmpty else {
                viewModel?.editChatMessage = nil
                return
            }
            bottomMessageBoxView.inputTextView.becomeFirstResponder()
            bottomMessageBoxView.inputTextView.setAttributedText(from: messageText)
            bottomMessageBoxView.showEditView(withData: .init(username: "", replyMessage: messageText
                                                              , attachmentsUrls: [], messageType: message.messageType))
            break
        case .reply:
            bottomMessageBoxView.inputTextView.becomeFirstResponder()
            viewModel?.replyConversation(conversationId: message.messageId)
            bottomMessageBoxView.showReplyView(withData: .init(username: message.createdBy, replyMessage: message.message, attachmentsUrls: message.attachments?.compactMap({($0.thumbnailUrl, $0.fileUrl, $0.fileType)}), messageType: message.messageType))
            break
        case .copy:
            viewModel?.copyConversation(conversationIds: [message.messageId])
            break
        case .report:
            NavigationScreen.shared.perform(.report(chatroomId: nil, conversationId: message.messageId, memberId: nil), from: self, params: nil)
        case .select:
            messageListView.isMultipleSelectionEnable = true
            messageListView.justReloadData()
            multipleSelectionEnable()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
                self?.messageListView.selectedItems.append(message)
                self?.messageListView.tableView.reloadRows(at: [indexPath], with: .none)
            }
        case .setTopic:
            viewModel?.setAsCurrentTopic(conversationId: message.messageId)
        default:
            break
        }
    }

    public func didTappedOnReplyPreviewOfMessage(indexPath: IndexPath) {
        let message = messageListView.tableSections[indexPath.section].data[indexPath.row]
        guard let chatroom = viewModel?.chatroomViewData,
            let repliedId = message.replied?.first?.messageId else {
            return
        }
        
        if let mediumConversation = viewModel?.chatMessages.first(where: {$0.id == repliedId}) {
            guard let section = messageListView.tableSections.firstIndex(where: {$0.section == mediumConversation.date}),
                  let index = messageListView.tableSections[section].data.firstIndex(where: {$0.messageId == mediumConversation.id}) else { return }
            scrollToSpecificConversation(indexPath: IndexPath(row: index, section: section))
            return
        }
        
        viewModel?.fetchIntermediateConversations(chatroom: chatroom, conversationId: repliedId)
    }
    
    public func didTappedOnAttachmentOfMessage(url: String, indexPath: IndexPath) {
        guard let fileUrl = URL(string: url.getLinkWithHttps()) else {
            return
        }
        NavigationScreen.shared.perform(.browser(url: fileUrl), from: self, params: nil)
    }
    
    public func didTappedOnGalleryOfMessage(attachmentIndex: Int, indexPath: IndexPath) {
        let message = messageListView.tableSections[indexPath.section].data[indexPath.row]
        guard let attachments = message.attachments, !attachments.isEmpty else { return }
        
        let mediaData: [LMChatMediaPreviewViewModel.DataModel.MediaModel] = attachments.compactMap {
            .init(mediaType: MediaType(rawValue: ($0.fileType ?? "")) ?? .image, thumbnailURL: $0.thumbnailUrl, mediaURL: $0.fileUrl ?? "")
        }
        
        let data: LMChatMediaPreviewViewModel.DataModel = .init(userName: message.createdBy ?? "User", senDate: formatDate(message.timestamp ?? 0), media: mediaData)
        
        NavigationScreen.shared.perform(.mediaPreview(data: data, startIndex: attachmentIndex), from: self, params: nil)
    }
    
    public func didTappedOnReaction(reaction: String, indexPath: IndexPath) {
        let message = messageListView.tableSections[indexPath.section].data[indexPath.row]
        if message.messageType == LMChatMessageListView.chatroomHeader {
            NavigationScreen.shared.perform(.reactionSheet(reactions: (viewModel?.chatroomViewData?.reactions ?? []).reversed(), selectedReaction: reaction, conversation: nil, chatroomId: message.messageId), from: self, params: nil)
            return
        }
        guard let conversation = viewModel?.chatMessages.first(where: {$0.id == message.messageId}),
              let reactions = conversation.reactions else { return }
        NavigationScreen.shared.perform(.reactionSheet(reactions: reactions.reversed(), selectedReaction: reaction, conversation: conversation.id, chatroomId: nil), from: self, params: nil)
    }
    
    
    public func fetchDataOnScroll(indexPath: IndexPath, direction: ScrollDirection) {
        let message = messageListView.tableSections[indexPath.section].data[indexPath.row]
        lastRowItem = message
        lastSectionItem = messageListView.tableSections[indexPath.section]
        viewModel?.getMoreConversations(conversationId: message.messageId, direction: direction)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            self?.isLoadingMoreData = false
        }
        if direction == .scroll_UP {
            chatroomTopicBar.isHidden = true
        } else {
            chatroomTopicBar.isHidden = false
        }
    }
    
    
    public func didTapOnCell(indexPath: IndexPath) {
        self.bottomMessageBoxView.inputTextView.resignFirstResponder()
    }

    // TODO: Move to Date Extension Folder
    func formatDate(_ epoch: Int, _ format: String = "dd MMM yyyy, HH:mm") -> String {
        // Convert epoch to Date
        var epoch = epoch
        
        if epoch > Int(Date().timeIntervalSince1970) {
            epoch /= 1000
        }
        
        let date = Date(timeIntervalSince1970: TimeInterval(epoch))
        
        // Create a DateFormatter to format the Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: date)
    }
}

extension LMChatMessageListViewController: LMChatBottomMessageComposerDelegate {
    
    public func cancelReply() {
        viewModel?.replyChatMessage = nil
        viewModel?.replyChatMessage = nil
        viewModel?.editChatMessage = nil
        bottomMessageBoxView.replyMessageViewContainer.isHidden = true
    }
    
    public func cancelLinkPreview() {
        viewModel?.currentDetectedOgTags = nil
        bottomMessageBoxView.linkPreviewView.isHidden = true
    }
    
    public func composeMessage(message: String, composeLink: String?) {
        
        if let chatMessage = viewModel?.editChatMessage {
            viewModel?.editChatMessage = nil
            viewModel?.postEditedConversation(text: message, shareLink: composeLink, conversation: chatMessage)
        } else {
            delegate?.postMessage(message: message, filesUrls: nil, shareLink: composeLink, replyConversationId: viewModel?.replyChatMessage?.id, replyChatRoomId: viewModel?.replyChatroom)
        }
        cancelReply()
        cancelLinkPreview()
    }
    
    public func composeAttachment() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {[weak self] (UIAlertAction) in
            guard let self else { return }
            MediaPickerManager.shared.presentCamera(viewController: self, delegate: self)
        }
        let cameraImage = Constants.shared.images.cameraIcon
        camera.setValue(cameraImage, forKey: "image")
        
        let photo = UIAlertAction(title: "Photo & Video", style: UIAlertAction.Style.default) { [weak self] (UIAlertAction) in
            guard let self else { return }
            NavigationScreen.shared.perform(.messageAttachment(delegate: self, chatroomId: viewModel?.chatroomId, sourceType: .photoLibrary), from: self, params: nil)
        }
        
        let photoImage = Constants.shared.images.galleryIcon
        photo.setValue(photoImage, forKey: "image")
        
        let audio = UIAlertAction(title: "Audio", style: UIAlertAction.Style.default) { [weak self] (UIAlertAction) in
            guard let self else { return }
            MediaPickerManager.shared.presentAudioAndDocumentPicker(viewController: self, delegate: self, fileType: .audio)
        }
        
        let audioImage = Constants.shared.images.micIcon
        audio.setValue(audioImage, forKey: "image")
        
        let document = UIAlertAction(title: "Document", style: UIAlertAction.Style.default) { [weak self] (UIAlertAction) in
            guard let self else { return }
            MediaPickerManager.shared.presentAudioAndDocumentPicker(viewController: self, delegate: self, fileType: .pdf)
        }
        
        let documentImage = Constants.shared.images.documentsIcon
        document.setValue(documentImage, forKey: "image")
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) 
        
        alert.addAction(camera)
        alert.addAction(photo)
        alert.addAction(audio)
        alert.addAction(document)
        /*
        if let provider = dataProvider,
           provider.checkMemberRight(with: .createPolls),
           provider.currentChatRoom?.type != .directMessage {
            let microPollAction = UIAlertAction(title: "Poll", style: .default) { UIAlertAction in
                self.presenter?.openMediaPicker(mediaType: "poll")
            }
            let pollImage = UIImage(named: "microPoll")
            microPollAction.setValue(pollImage, forKey: "image")
            alert.addAction(microPollAction)
        }
        */
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    public func composeAudio() {
        if let audioURL = LMChatAudioRecordManager.shared.recordingStopped() {
            let newURL = URL(fileURLWithPath: audioURL.absoluteString)
            let mediaModel = MediaPickerModel(with: newURL, type: .voice_note)
            postConversationWithAttchments(message: nil, attachments: [mediaModel])
        }
        LMChatAudioRecordManager.shared.resetAudioParameters()
    }
    
    public func composeGif() {
        let giphy = GiphyViewController()
        giphy.mediaTypeConfig = [.gifs]
        giphy.theme = GPHTheme(type: .lightBlur)
        giphy.showConfirmationScreen = false
        giphy.rating = .ratedPG
        giphy.delegate = self
        self.present(giphy, animated: true, completion: nil)
    }
    
    public func linkDetected(_ link: String) { 
        linkDetectorTimer?.invalidate()
        linkDetectorTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: {[weak self] timer in
            print("detected first link: \(link)")
            self?.viewModel?.decodeUrl(url: link) {[weak self] ogTags in
                guard let ogTags else { return }
                if self?.bottomMessageBoxView.detectedFirstLink != nil && self?.bottomMessageBoxView.detectedFirstLink == ogTags.url {
                    self?.bottomMessageBoxView.linkPreviewView.isHidden = false
                    self?.bottomMessageBoxView.linkPreviewView.setData(.init(title: ogTags.title, description: ogTags.description, link: ogTags.url, imageUrl: ogTags.image))
                }
            }
        })
    }
    
    public func audioRecordingStarted() {
        LMChatAudioPlayManager.shared.stopAudio { }
        // If Any Audio is playing, stop audio and reset audio view
        resetAudio()
        
        do {
            let canRecord = try LMChatAudioRecordManager.shared.recordAudio(audioDelegate: self)
            if canRecord {
                bottomMessageBoxView.showRecordingView()
                NotificationCenter.default.addObserver(self, selector: #selector(updateRecordDuration), name: .audioDurationUpdate, object: nil)
            } else {
                // TODO: Show Error Alert if false
            }
        } catch let error {
            // TODO: Show Error Alert
            print(error.localizedDescription)
        }
    }
    
    public func audioRecordingEnded() {
        if let url = LMChatAudioRecordManager.shared.recordingStopped() {
            print(url)
            bottomMessageBoxView.showPlayableRecordView()
        } else {
            bottomMessageBoxView.resetRecordingView()
        }
    }
    
    public func playRecording() {
        guard let url = LMChatAudioRecordManager.shared.audioURL else { return }
        LMChatAudioPlayManager.shared.startAudio(fileURL: url.absoluteString) { [weak self] progress in
            self?.bottomMessageBoxView.updateRecordTime(with: progress, isPlayback: true)
        }
    }
    
    public func stopRecording(_ onStop: (() -> Void)) {
        LMChatAudioPlayManager.shared.stopAudio(stopCallback: onStop)
    }
    
    public func deleteRecording() {
        LMChatAudioRecordManager.shared.deleteAudioRecording()
    }
    
    @objc
    open func updateRecordDuration(_ notification: Notification) {
        if let val = notification.object as? Int {
            bottomMessageBoxView.updateRecordTime(with: val)
        }
    }
}

extension LMChatMessageListViewController: MediaPickerDelegate {
    func filePicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel], fileType: MediaType) {
        postConversationWithAttchments(message: nil, attachments: results)
    }
}

extension LMChatMessageListViewController: UIDocumentPickerDelegate {
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        var results: [MediaPickerModel] = []
        for item in urls {
            guard let localPath = MediaPickerManager.shared.createLocalURLfromPickedAssetsUrl(url: item) else { continue }
            switch MediaPickerManager.shared.fileTypeForDocument {
            case .audio:
                if let mediaDeatil = FileUtils.getDetail(forVideoUrl: localPath) {
                    let mediaModel = MediaPickerModel(with: localPath, type: .audio, thumbnailPath: mediaDeatil.thumbnailUrl)
                    mediaModel.duration = mediaDeatil.duration
                    mediaModel.fileSize = Int(mediaDeatil.fileSize ?? 0)
                    results.append(mediaModel)
                }
            case .pdf:
                if let pdfDetail = FileUtils.getDetail(forPDFUrl: localPath) {
                    let mediaModel = MediaPickerModel(with: localPath, type: .pdf, thumbnailPath: pdfDetail.thumbnailUrl)
                    mediaModel.numberOfPages = pdfDetail.pageCount
                    mediaModel.fileSize = Int(pdfDetail.fileSize ?? 0)
                    results.append(mediaModel)
                }
            default:
                continue
            }
        }
        NavigationScreen.shared.perform(.messageAttachmentWithData(data: results,
                                                                   delegate: self,
                                                                   chatroomId: viewModel?.chatroomId,
                                                                   mediaType: MediaPickerManager.shared.fileTypeForDocument), from: self, params: nil)
    }
}

extension LMChatMessageListViewController: LMChatAttachmentViewDelegate {
    public func postConversationWithAttchments(message: String?, attachments: [MediaPickerModel]) {
        let attachmentMedia: [LMChatAttachmentMediaData] = attachments.compactMap { media in
            var mediaData = LMChatAttachmentMediaData.builder()
                .url(media.url)
                .fileType(media.mediaType)
                .mediaName(media.url?.lastPathComponent)
                .format(media.mediaType.rawValue)
                .image(media.photo)
        
            switch media.mediaType {
            case .video, .audio, .voice_note:
                if let url = media.url, let videoDeatil = FileUtils.getDetail(forVideoUrl: url) {
                    mediaData = mediaData.duration(videoDeatil.duration)
                        .size(Int64(videoDeatil.fileSize ?? 0))
                        .thumbnailurl(videoDeatil.thumbnailUrl)
                }
            case .pdf:
                if let url = media.url, let pdfDetail = FileUtils.getDetail(forPDFUrl: url) {
                    mediaData = mediaData.pdfPageCount(pdfDetail.pageCount)
                        .size(Int64(pdfDetail.fileSize ?? 0))
                        .thumbnailurl(pdfDetail.thumbnailUrl)
                }
            case .image, .gif:
                if let url = media.url {
                    let dimension = FileUtils.imageDimensions(with: url)
                    mediaData = mediaData.size(Int64(FileUtils.fileSizeInByte(url: media.url) ?? 0))
                        .width(dimension?.width)
                        .height(dimension?.height)
                }
            default:
                break
            }
            return mediaData.build()
        }
        
        viewModel?.postMessage(message: message, filesUrls: attachmentMedia, shareLink: self.viewModel?.currentDetectedOgTags?.url, replyConversationId: viewModel?.replyChatMessage?.id, replyChatRoomId: viewModel?.replyChatroom)
        cancelReply()
        cancelLinkPreview()
    }
}


// MARK: Audio Recording
extension LMChatMessageListViewController: AVAudioRecorderDelegate { 
    @objc
    open func audioEnded(_ notification: Notification) {
        let duration: Int = (notification.object as? Int) ?? 0
        bottomMessageBoxView.resetAudioDuration(with: duration)
    }
}

extension LMChatMessageListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        var mediaType: MediaType = .image
        var mediaData: [MediaPickerModel] = []
        if let videoURL = info[.mediaURL] as? URL, let localPath = MediaPickerManager.shared.createLocalURLfromPickedAssetsUrl(url: videoURL),
           let videoDetails = FileUtils.getDetail(forVideoUrl: localPath){
            mediaType = .video
            mediaData = [.init(with: localPath, type: .video, thumbnailPath: videoDetails.thumbnailUrl)]
        } else if let imageUrl = info[.imageURL] as? URL, let localPath = MediaPickerManager.shared.createLocalURLfromPickedAssetsUrl(url: imageUrl) {
            mediaType = .image
            mediaData = [.init(with: localPath, type: .image)]
        } else if let capturedImage = info[.originalImage] as? UIImage, let localPath = MediaPickerManager.shared.saveImageIntoDirecotry(image: capturedImage) {
            mediaType = .image
            mediaData = [.init(with: localPath, type: .image)]
        }
        NavigationScreen.shared.perform(.messageAttachmentWithData(data: mediaData,
                                                                   delegate: self,
                                                                   chatroomId: viewModel?.chatroomId,
                                                                   mediaType: mediaType), from: self, params: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension LMChatMessageListViewController: LMChatEmojiListViewDelegate {
    func emojiSelected(emoji: String, conversationId: String?, chatroomId: String?) {
        if let conversationId {
            viewModel?.putConversationReaction(conversationId: conversationId, reaction: emoji)
        } else if let chatroomId {
            viewModel?.putChatroomReaction(chatroomId: chatroomId, reaction: emoji)
        }
    }
}

extension LMChatMessageListViewController: LMReactionViewControllerDelegate {
    public func reactionDeleted(chatroomId: String?, conversationId: String?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {[weak self] in
            self?.viewModel?.updateDeletedReaction(conversationId: conversationId, chatroomId: chatroomId)
        }
    }
}

// MARK: LMChatAudioProtocol
extension LMChatMessageListViewController: LMChatAudioProtocol {
    
    public func didTapPlayPauseButton(for url: String, index: IndexPath) {
        resetAudio()
        
        guard messageListView.tableSections.indices.contains(index.section),
              messageListView.tableSections[index.section].data.indices.contains(index.row) else { return }
        
        let messageID = messageListView.tableSections[index.section].data[index.row].messageId
        
        messageListView.audioIndex = (index.section, messageID)
        
        LMChatAudioPlayManager.shared.startAudio(url: url) { [weak self] progress in
            (self?.messageListView.tableView.cellForRow(at: index) as? LMChatAudioViewCell)?.seekSlider(to: Float(progress), url: url)
        }
    }
    
    
    public func didSeekTo(_ position: Float, _ url: String, index: IndexPath) {
        LMChatAudioPlayManager.shared.seekAt(position, url: url)
    }
    
    public func resetAudio() {
        if let audioIndex = messageListView.audioIndex,
           messageListView.tableSections.indices.contains(audioIndex.section),
           let row = messageListView.tableSections[audioIndex.section].data.firstIndex(where: { $0.messageId == audioIndex.messageID }) {
            
            (messageListView.tableView.cellForRow(at: .init(row: row, section: audioIndex.section)) as? LMChatAudioViewCell)?.resetAudio()
        }
        
        messageListView.audioIndex = nil
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        (cell as? LMChatAudioViewCell)?.resetAudio()
//        if indexPath == messageListView.audioIndex {
//            LMChatAudioPlayManager.shared.resetAudioPlayer()
//        }
    }
}

extension LMChatMessageListViewController: LMChatMessageCellDelegate, LMChatroomHeaderMessageCellDelegate {
    
    public func pauseAudioPlayer() {
        LMChatAudioPlayManager.shared.stopAudio { }
    }

    public func onClickOfSeeMore(for messageID: String, indexPath: IndexPath) {
        guard messageListView.tableSections.indices.contains(indexPath.section),
              let row = messageListView.tableSections[indexPath.section].data.firstIndex(where: { $0.messageId == messageID }) else { return }
        
        messageListView.tableSections[indexPath.section].data[row].isShowMore.toggle()
        messageListView.tableView.beginUpdates()
        messageListView.tableView.reloadRows(at: [.init(row: row, section: indexPath.section)], with: .none)
        messageListView.tableView.endUpdates()
    }
    
    public func didCancelAttachmentUploading(indexPath: IndexPath) {
        let item = messageListView.tableSections[indexPath.section].data[indexPath.row]
        didCancelUploading(messageId: item.messageId)
    }
    
    public func didRetryAttachmentUploading(indexPath: IndexPath) {
        let item = messageListView.tableSections[indexPath.section].data[indexPath.row]
        didRetryUploading(messageId: item.messageId)
    }
    
    
    public func didTappedOnSelectionButton(indexPath: IndexPath?) {
        guard let indexPath else { return }
        let item = messageListView.tableSections[indexPath.section].data[indexPath.row]
        let itemIndex = messageListView.selectedItems.firstIndex(where: {$0.messageId == item.messageId})
        if let itemIndex {
            messageListView.selectedItems.remove(at: itemIndex)
        } else {
            messageListView.selectedItems.append(item)
        }
    }
    
    public func onClickReplyOfMessage(indexPath: IndexPath?) {
        guard let indexPath else { return }
        didTappedOnReplyPreviewOfMessage(indexPath: indexPath)
    }
    
    public func onClickAttachmentOfMessage(url: String, indexPath: IndexPath?) {
        guard let indexPath else { return }
        didTappedOnAttachmentOfMessage(url: url, indexPath: indexPath)
    }
    
    public func onClickGalleryOfMessage(attachmentIndex: Int, indexPath: IndexPath?) {
        guard let indexPath else { return }
        didTappedOnGalleryOfMessage(attachmentIndex: attachmentIndex, indexPath: indexPath)
    }
    
    public func onClickReactionOfMessage(reaction: String, indexPath: IndexPath?) {
        guard let indexPath else { return }
        didTappedOnReaction(reaction: reaction, indexPath: indexPath)
    }
    
    public func didTapOnProfileLink(route: String) {
        print(route)
    }

}
