//
//  LMParticipantList.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 16/02/24.
//

import Foundation
import LMChatUI_iOS

public protocol LMParticipantListViewDelegate: AnyObject {
    func didTapOnCell(indexPath: IndexPath)
    func loadMoreData()
}

@IBDesignable
open class LMParticipantListView: LMView {
    
    public struct ContentModel {
        public let userImage: String?
        public let userName: String
        public let route: String
        
        public init(userImage: String?, userName: String, route: String) {
            self.userImage = userImage
            self.userName = userName
            self.route = route
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    open private(set) lazy var tableView: LMTableView = {
        let table = LMTableView().translatesAutoresizingMaskIntoConstraints()
        table.register(LMUIComponents.shared.participantListCell)
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
    public var data: [LMParticipantCell.ContentModel] = []
    public weak var delegate: LMParticipantListViewDelegate?
    
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
//        containerView.layer.borderColor = Appearance.shared.colors.gray4.cgColor
//        containerView.layer.borderWidth = 1
//        containerView.roundCornerWithShadow(cornerRadius: 16, shadowRadius: .zero, offsetX: .zero, offsetY: .zero, colour: .black, opacity: 0.1, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        tableView.backgroundColor = Appearance.shared.colors.clear
    }
    
    open func reloadList() {
        tableView.reloadData()
    }
}


// MARK: UITableView
extension LMParticipantListView: UITableViewDataSource, UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(LMUIComponents.shared.participantListCell) {
            let item = data[indexPath.row]
            cell.configure(with: item)
            if indexPath.row >= (data.count - 5) {
                delegate?.loadMoreData()
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        if taggingCellsData.count - 1 == indexPath.row {
        //            viewModel?.fetchMoreUsers()
        //        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapOnCell(indexPath: indexPath)
    }
}


