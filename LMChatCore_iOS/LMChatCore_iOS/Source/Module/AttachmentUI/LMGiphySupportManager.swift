//
//  LMGiphySupportManager.swift
//  LikeMindsChatCore
//
//  Created by Pushpendra Singh on 22/04/24.
//

import Foundation
//import SwiftyGif
import GiphyUISDK
import LikeMindsChatUI

@objc class GiphyAPIConfiguration: NSObject {
    static let gifMessage = "* This is a gif message. Please update your app *"
    @objc static func configure() {
        let apiKey = "pcNuU0wKZaplc0LrMqEnNQhTjAB77tJo"
        Giphy.configure(apiKey: apiKey)
    }
}


class GIFImage {
    var imageData: Data
    var size: CGSize
    var title: String?
    var localPath: URL?
    init(withGIFImageData imageData: Data, withSize size: CGSize, withTitle title: String?, url: URL?) {
        self.imageData = imageData
        self.size = size
        self.title = title
        self.localPath = url
    }
}

extension LMChatBottomMessageComposerView {
    @objc func handleDidPressGIF(_ sender: UIButton) {
        let giphy = GiphyViewController()
        giphy.mediaTypeConfig = [.gifs]
        giphy.theme = GPHTheme(type: .lightBlur)
        giphy.showConfirmationScreen = false
        giphy.rating = .ratedPG
        giphy.delegate = self.delegate as? LMChatMessageListViewController
        self.window?.rootViewController?.present(giphy, animated: true, completion: nil)
    }
}

extension LMChatMessageListViewController: GiphyDelegate {
    public func didDismiss(controller: GiphyViewController?) {
        
    }
    
    public func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia, contentType: GPHContentType) {
        giphyViewController.dismiss(animated: true) {
            self.showHideLoaderView(isShow: true, backgroundColor: .clear)
            guard contentType == .gifs else {return}
            DispatchQueue.main.async {
                URLSession.shared.dataTask(with: URL(string: media.url(rendition: .fixedHeight, fileType: .gif)!)!) { data, response, error in
                    guard let gifImageData = data, error == nil else {
                        print(error)
                        return
                    }
                    let fileName = (media.title?.components(separatedBy: " ").joined(separator: "_") ?? "\(Date().millisecondsSince1970)") + ".gif"
                    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                    guard let targetURL = documentsDirectory?.appendingPathComponent(fileName) else { return }
                    do {
                        if FileManager.default.fileExists(atPath: targetURL.path) {
                            try FileManager.default.removeItem(at: targetURL)
                        }
                        try gifImageData.write(to: targetURL, options: .atomic)
                    } catch {
                        print(error.localizedDescription)
                    }
                    DispatchQueue.main.async { [weak self] in
                        guard let weakSelf = self, let giphyImage = GiphyYYImage(data: gifImageData) else {return}
                        let size = giphyImage.size
                        
                        weakSelf.showHideLoaderView(isShow: false)
                        NavigationScreen.shared.perform(.messageAttachmentWithData(data: 
                                                                                    [.init(with: targetURL, type: .gif)],
                                                                                   delegate: weakSelf, chatroomId: weakSelf.viewModel?.chatroomId, mediaType: .gif), from: weakSelf, params: nil)                    }
                }.resume()
            }
        }
    }
}
