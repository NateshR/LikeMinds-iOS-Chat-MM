//
//  FileUtils.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/04/24.
//

import Foundation
import AVFoundation
import PDFKit

class FileUtils {
    
    static func getDimensions(fileUrl: URL) {
        
    }
    
    static func fileNameWithoutExtension(_ filename: String) -> String {
        let name = filename as NSString
        let pathExtention = name.pathExtension
        let pathPrefix = name.deletingPathExtension
        return pathPrefix
    }
    
    static func saveImageToLocalDirectory(image: UIImage, imageName: String?) -> URL? {
        var fileName = imageName ?? "\(Date().millisecondsSince1970).jpeg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let targetURL = documentsDirectory?.appendingPathComponent(fileName) else { return nil }
        do {
            if FileManager.default.fileExists(atPath: targetURL.path) {
                try FileManager.default.removeItem(at: targetURL)
            }
            try image.jpegData(compressionQuality: 1.0)?.write(to: targetURL, options: .atomic)
        } catch {
            print(error.localizedDescription)
        }
        return targetURL
    }
    
    // get video dimensions
    static func videoDimensions(with fileURL: URL) -> (width: CGFloat, height: CGFloat)? {
        let resolution = Self.resolutionForLocalVideo(url: fileURL)
        guard let width = resolution?.width, let height = resolution?.height else {
            return nil
        }
        return (width , height)
    }
    
    // get video dimensions
    static func imageDimensions(with fileURL: URL) -> (width: Int, height: Int)? {
        if let imageSource = CGImageSourceCreateWithURL(fileURL as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as? Int
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as? Int
                return (pixelWidth ?? 0, pixelHeight ?? 0)
            }
        }
        return nil
    }
    
    private static  func resolutionForLocalVideo(url: URL) -> CGSize? {
        guard let track = AVURLAsset(url: url).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
    
    // get video size in byte
    static func fileSizeInByte(url: URL?) -> Double? {
        guard let filePath = url?.path else {
            return nil
        }
        do {
            let attribute = try FileManager.default.attributesOfItem(atPath: filePath)
            if let size = attribute[FileAttributeKey.size] as? NSNumber {
                return Double(truncating: size)
            }
        } catch {
            print("Error: \(error)")
        }
        return nil
    }
    
    static func getDetail(forVideoUrl url: URL) -> (thumbnail: UIImage?, thumbnailUrl: URL?, fileSize: Double?, duration: Int?)? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.maximumSize = .init(width: 240, height: 240)
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMakeWithSeconds(1.0, preferredTimescale: 600), actualTime: nil)
            let image = UIImage(cgImage: thumbnailImage)
            return (image,
                    saveImageToLocalDirectory(image: image, imageName: "thumbnail_\(fileNameWithoutExtension(url.lastPathComponent)).jpeg"),
                    Self.fileSizeInByte(url: url),
                    Int(CMTimeGetSeconds(asset.duration)))
        } catch let error {
            print(error)
        }
        return (nil, nil, Self.fileSizeInByte(url: url), Int(CMTimeGetSeconds(asset.duration)))
    }
    
    static func getDetail(forPDFUrl url: URL) -> (thumbnail: UIImage?, thumbnailUrl: URL?, pageCount: Int?, fileSize: Double?)? {
        guard let pdfDoc = PDFDocument(url: url),
              let pdfPage = pdfDoc.page(at: 0) else { return nil }
        let pdfPageRect = pdfPage.bounds(for: .mediaBox)
        let thumbnailImage = pdfPage.thumbnail(of: pdfPageRect.size, for: .mediaBox)
        return (thumbnailImage,
                saveImageToLocalDirectory(image: thumbnailImage, imageName: "thumbnail_\(fileNameWithoutExtension(url.lastPathComponent)).jpeg"),
                pdfDoc.pageCount,
                Self.fileSizeInByte(url: url))
    }
}
