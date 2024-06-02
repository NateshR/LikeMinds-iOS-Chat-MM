//
//  LMChatHomeFeedExploreTabCell.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 12/02/24.
//

import Foundation
import Kingfisher

@IBDesignable
open class LMChatHomeFeedExploreTabCell: LMTableViewCell {
    
    public struct ContentModel {
        public let totalChatroomsCount: Int?
        public let unseenChatroomsCount: Int?
        
        public init(totalChatroomsCount: Int?, unseenChatroomsCount: Int?) {
            self.totalChatroomsCount = totalChatroomsCount
            self.unseenChatroomsCount = unseenChatroomsCount
        }
    }
    
    // MARK: UI Elements
    open private(set) lazy var exploreTabView: LMChatHomeFeedExploreTabView = {
        let view = LMUIComponents.shared.homeFeedExploreTabView.init().translatesAutoresizingMaskIntoConstraints()
        view.clipsToBounds = true
        return view
    }()
    
    open private(set) lazy var sepratorView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    
    // MARK: setupViews
    open override func setupViews() {
        super.setupViews()
        
        contentView.addSubview(containerView)
        containerView.addSubview(exploreTabView)
        containerView.addSubview(sepratorView)
    }
    
    
    // MARK: setupLayouts
    open override func setupLayouts() {
        super.setupLayouts()
        
        contentView.pinSubView(subView: containerView)
        
        NSLayoutConstraint.activate([
            exploreTabView.topAnchor.constraint(equalTo: containerView.topAnchor),
            exploreTabView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            exploreTabView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            exploreTabView.bottomAnchor.constraint(equalTo: sepratorView.topAnchor),
            
            sepratorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            sepratorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            sepratorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            sepratorView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    
    // MARK: setupAppearance
    open override func setupAppearance() {
        super.setupAppearance()
        
        sepratorView.backgroundColor = Appearance.shared.colors.gray4
        backgroundColor = Appearance.shared.colors.clear
        contentView.backgroundColor = Appearance.shared.colors.clear
    }
    
    // MARK: configure
    open func configure(with data: ContentModel) {
        exploreTabView.setData(LMChatHomeFeedExploreTabView.ContentModel(tilesName: "Explore", tilesIcon: "", unreadCount: data.unseenChatroomsCount ?? 0, totalCount: data.totalChatroomsCount ?? 0))
    }
}
