//
//  LMPHPickerViewController.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 13/04/24.
//

import Foundation
import PhotosUI

public class MediaPickerModel {
    enum MediaType {
        case photo, video, livePhoto, gif, audio, document
    }
    
    public var id: String
    var photo: UIImage?
    var originalPhoto: UIImage?
    var url: URL?
    var livePhoto: PHLivePhoto?
    var mediaType: MediaType = .photo
    
    init(with photo: UIImage) {
        id = UUID().uuidString
        self.photo = photo
        self.originalPhoto = photo
        mediaType = .photo
    }
    
    init(with videoURL: URL) {
        id = UUID().uuidString
        url = videoURL
        mediaType = .video
    }
    
    init(with livePhoto: PHLivePhoto) {
        id = UUID().uuidString
        self.livePhoto = livePhoto
        mediaType = .livePhoto
    }
}

protocol MediaPickerDelegate: AnyObject {
    func mediaPicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel])
    func filePicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel], fileType: MediaPickerModel.MediaType)
}

extension MediaPickerDelegate {
    func mediaPicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel]) {}
    func filePicker(_ picker: UIViewController, didFinishPicking results: [MediaPickerModel], fileType: MediaPickerModel.MediaType) {}
}

class MediaPickerManager: NSObject {
    
    weak var delegate: MediaPickerDelegate?
    
    static let shared = MediaPickerManager()
    
    var mediaPickerItems: [MediaPickerModel] = []
    
    let group = DispatchGroup()
    
    private override init() {}
    
    func presentPicker(viewController: UIViewController, delegate: MediaPickerDelegate?) {
        self.delegate = delegate
        if #available(iOS 14.0, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .any(of: [.videos, .images])
            configuration.selectionLimit = 10
            configuration.preferredAssetRepresentationMode = .automatic
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            picker.isModalInPresentation = true
            viewController.present(picker, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func presentAudioAndDocumentPicker(viewController: UIViewController, delegate: MediaPickerDelegate?, fileType: MediaPickerModel.MediaType) {
        guard [MediaPickerModel.MediaType.document, .audio].contains(fileType) else { return }
        self.delegate = delegate
        let docTypes = fileType == .document ? ["com.adobe.pdf"] : ["public.audiovisual-​content", "public.audio"]
        let docVc = UIDocumentPickerViewController(documentTypes: docTypes, in: .import)
        docVc.delegate = self
        docVc.allowsMultipleSelection = true
        docVc.isModalInPresentation = true
        viewController.present(docVc, animated: true)
    }
}

@available(iOS 14.0, *)
extension MediaPickerManager: PHPickerViewControllerDelegate  {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard !results.isEmpty else {
            delegate?.mediaPicker(picker, didFinishPicking: mediaPickerItems)
            return
        }
        for result in results {
            let itemProvider = result.itemProvider
            
            guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first,
                  let utType = UTType(typeIdentifier)
            else { continue }
            
            if utType.conforms(to: .image) {
                group.enter()
                self.getPhoto(from: itemProvider)
            } else if utType.conforms(to: .movie) {
                group.enter()
                self.getVideo(from: itemProvider, typeIdentifier: typeIdentifier)
            } 
            group.notify(queue: DispatchQueue.main) { [weak self] in
                guard let self else { return }
                delegate?.mediaPicker(picker, didFinishPicking: mediaPickerItems)
                picker.dismiss(animated: true)
            }
        }
    }
    
    private func getPhoto(from itemProvider: NSItemProvider) {
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let image = object as? UIImage {
                    DispatchQueue.main.async {[weak self] in
                        guard let self else { return }
                        mediaPickerItems.append(.init(with: image))
                        group.leave()
                    }
                }
            }
        }
    }
    
    private func getVideo(from itemProvider: NSItemProvider, typeIdentifier: String) {
        itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier) { url, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let url = url else { return }
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            guard let targetURL = documentsDirectory?.appendingPathComponent(url.lastPathComponent) else { return }
            
            do {
                if FileManager.default.fileExists(atPath: targetURL.path) {
                    try FileManager.default.removeItem(at: targetURL)
                }
                try FileManager.default.copyItem(at: url, to: targetURL)
                DispatchQueue.main.async {[weak self] in
                    guard let self else { return }
                    mediaPickerItems.append(.init(with: targetURL))
                    group.leave()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func getPhoto(from itemProvider: NSItemProvider, isLivePhoto: Bool) {
        let objectType: NSItemProviderReading.Type = !isLivePhoto ? UIImage.self : PHLivePhoto.self
        
        if itemProvider.canLoadObject(ofClass: objectType) {
            itemProvider.loadObject(ofClass: objectType) { object, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let livePhoto = object as? PHLivePhoto {
                    DispatchQueue.main.async {[weak self] in
                        guard let self else { return }
//                        mediaPickerItems.append(.init(with: livePhoto))
                        group.leave()
                    }
                }
            }
        }
    }
}

extension MediaPickerManager: UIDocumentPickerDelegate {
    
    func documentMenu(_ documentMenu: UIDocumentPickerViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
//        documentPicker.delegate = self
//        viewController.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        /*
         if documentPickerType == .audio  {
         // For Audio Selection
         
         } else if documentPickerType == .document {
         // For PDF/Documents Selection
         arrDoc.removeAll()
         arrDocData.removeAll()
         for url in urls {
         arrDoc.append(url)
         let pdfFilename = url.lastPathComponent
         
         do {
         let data = try Data(contentsOf: url)
         arrDocData.append([pdfFilename:data])
         }
         catch {
         LMLog(message: error, type: .error, print: true)
         }
         }
         // Call upload PDF API & functionality
         didUploadMultiplePdf(withData: arrDocData, andSelectedPdfs: arrDoc, andAnswerText: "")
         */
    }
}
