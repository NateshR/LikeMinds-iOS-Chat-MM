//
//  LMChatMediaPreviewViewModel.swift
//  LMChatCore_iOS
//
//  Created by Devansh Mohata on 20/04/24.
//


public protocol LMMediaViewModelDelegate: AnyObject {
    func showImages(with media: [LMChatMediaPreviewContentModel], userName: String, date: String)
    func scrollToIndex(index: Int)
}

public final class LMChatMediaPreviewViewModel {
    public struct DataModel {
        let userName: String
        let senDate: String
        let media: [MediaModel]

        public init(userName: String, senDate: String, media: [MediaModel]) {
            self.userName = userName
            self.senDate = senDate
            self.media = media
        }
        
        public struct MediaModel {
            let mediaType: MediaType
            let thumbnailURL: String?
            let mediaURL: String
            
            public init(mediaType: MediaType, thumbnailURL: String?, mediaURL: String) {
                self.mediaType = mediaType
                self.thumbnailURL = thumbnailURL
                self.mediaURL = mediaURL
            }
        }
    }
    
    let data: DataModel
    var startIndex: Int?
    weak var delegate: LMMediaViewModelDelegate?
    
    init(data: DataModel, startIndex: Int, delegate: LMMediaViewModelDelegate?) {
        self.data = data
        self.startIndex = startIndex
        self.delegate = delegate
    }
    
    public static func createModule(with data: DataModel, startIndex: Int = 0) -> LMChatMediaPreviewScreen {
        let viewController = LMChatMediaPreviewScreen()
        let viewModel = Self.init(data: data, startIndex: startIndex, delegate: viewController)
        
        viewController.viewModel = viewModel
        return viewController
    }
    
    public func showMediaPreview() {
        let viewData: [LMChatMediaPreviewContentModel] = data.media.map {
            .init(mediaURL: $0.mediaURL, thumbnailURL: $0.thumbnailURL, isVideo: $0.mediaType == .video)
        }
        
        delegate?.showImages(with: viewData, userName: data.userName, date: data.senDate)
    }
    
    public func scrollToMediaPreview() {
        guard let startIndex else { return }
        delegate?.scrollToIndex(index: startIndex)
        self.startIndex = nil
    }
}
