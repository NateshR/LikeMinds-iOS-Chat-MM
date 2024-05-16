//
//  LMExploreChatroomViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 19/04/24.
//

import Foundation
import LMChatUI_iOS

open class LMExploreChatroomViewController: LMViewController {
    var viewModel: LMExploreChatroomViewModel?
    
//    open private(set) lazy var containerView: LMView = {
//        let view = LMView()
//        view
//    }()
    
    open private(set) lazy var containerView: LMExploreChatroomListView? = {
        if let view = try? LMChatExploreChatroomViewModel.createModule() {
            view.view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        return .none
    }()
    
    open private(set) lazy var filterButton: LMButton = {
        let button = LMButton.createButton(with: "Newest", image: Constants.shared.images.downArrowIcon, textColor: Appearance.shared.colors.gray51, textFont: Appearance.shared.fonts.headingFont1, contentSpacing: .init(top: 20, left: 10, bottom: 20, right: 10))
        button.setFont(Appearance.shared.fonts.headingFont1)
        button.tintColor = Appearance.shared.colors.gray51
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft
        let spacing: CGFloat = 10
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: 0)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(filterButtonClicked), for: .touchUpInside)
        return button
    }()
    
    open private(set) lazy var pinnedButton: LMButton = {
        let image1 = Constants.shared.images.pinCircleIcon.withSystemImageConfig(pointSize: 24)
        let image2 = Constants.shared.images.pinCircleFillIcon.withSystemImageConfig(pointSize: 24)
        let button = LMButton.createButton(with: "", image: image1, textColor: Appearance.shared.colors.gray51, textFont: Appearance.shared.fonts.headingFont1, contentSpacing: .init(top: 14, left: 14, bottom: 8, right: 10))
        button.setFont(Appearance.shared.fonts.headingFont1)
        button.tintColor = Appearance.shared.colors.gray51
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image2, for: .selected)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(pinnedButtonClicked), for: .touchUpInside)
        return button
    }()
    
    public weak var delegate: LMChatExploreChatroomFilterProtocol?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitleAndSubtitle(with: "Explore Chatrooms", subtitle: nil)
        delegate = containerView
    }
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        
        view.addSubview(filterButton)
        view.addSubview(pinnedButton)
        
        if let containerView {
            addChild(containerView)
            view.addSubview(containerView.view)
            containerView.didMove(toParent: self)
        }
    }
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            filterButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            pinnedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            pinnedButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pinnedButton.leadingAnchor.constraint(greaterThanOrEqualTo: filterButton.trailingAnchor),
            pinnedButton.bottomAnchor.constraint(equalTo: filterButton.bottomAnchor)
        ])
        
        if let containerView {
            containerView.view.topAnchor.constraint(equalTo: filterButton.bottomAnchor).isActive = true
            containerView.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            containerView.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            containerView.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        }
    }
    
    @objc func filterButtonClicked(_ sender: UIButton) {
        let filters = LMChatExploreChatroomViewModel.Filter.allCases
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        filters.forEach { filter in
            let actionItem = UIAlertAction(title: filter.stringName, style: .default) { [weak self] _ in
                self?.filterButton.setTitle(filter.stringName, for: .normal)
                self?.delegate?.applyFilter(with: filter)
            }
            alert.addAction(actionItem)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc 
    open func pinnedButtonClicked(_ sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.applyPinnedStatus()
    }
}
