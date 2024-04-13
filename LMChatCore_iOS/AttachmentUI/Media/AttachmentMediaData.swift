//
//  AttachmentMediaData.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/04/24.
//

import Foundation
import Foundation

enum AttachmentType: String {
    case image
    case gif
    case video
}

struct AttachmentMediaData {
    let url: URL
    let fileType: AttachmentType
    let width: Int?
    let height: Int?
    let thumbnailurl: URL?
    let size: Int64
    let mediaName: String?
    let pdfPageCount: Int?
    let duration: Int?
    let awsFolderPath: String?
    let format: String?
    
    init(url: URL,
         fileType: AttachmentType,
         width: Int?,
         height: Int?,
         thumbnailurl: URL?,
         size: Int64,
         mediaName: String?,
         pdfPageCount: Int?,
         duration: Int?,
         awsFolderPath: String?,
         format: String?) {
        self.url = url
        self.fileType = fileType
        self.width = width
        self.height = height
        self.thumbnailurl = thumbnailurl
        self.size = size
        self.mediaName = mediaName
        self.pdfPageCount = pdfPageCount
        self.duration = duration
        self.awsFolderPath = awsFolderPath
        self.format = format
    }
    
    static func builder() -> Builder {
        return Builder()
    }

    class Builder {
        private var url: URL?
        private var fileType: AttachmentType = .image
        private var width: Int?
        private var height: Int?
        private var thumbnailurl: URL?
        private var size: Int64 = 0
        private var mediaName: String?
        private var pdfPageCount: Int?
        private var duration: Int?
        private var awsFolderPath: String?
        private var format: String?
        
        func url(_ url: URL) -> Builder {
            self.url = url
            return self
        }
        
        func fileType(_ fileType: AttachmentType) -> Builder {
            self.fileType = fileType
            return self
        }
        
        func width(_ width: Int?) -> Builder {
            self.width = width
            return self
        }
        
        func height(_ height: Int?) -> Builder {
            self.height = height
            return self
        }
        
        func thumbnailurl(_ thumbnailurl: URL?) -> Builder {
            self.thumbnailurl = thumbnailurl
            return self
        }
        
        func size(_ size: Int64) -> Builder {
            self.size = size
            return self
        }
        
        func mediaName(_ mediaName: String?) -> Builder {
            self.mediaName = mediaName
            return self
        }
        
        func pdfPageCount(_ pdfPageCount: Int?) -> Builder {
            self.pdfPageCount = pdfPageCount
            return self
        }
        
        func duration(_ duration: Int?) -> Builder {
            self.duration = duration
            return self
        }
        
        func awsFolderPath(_ awsFolderPath: String?) -> Builder {
            self.awsFolderPath = awsFolderPath
            return self
        }
        
        func format(_ format: String?) -> Builder {
            self.format = format
            return self
        }
        
        func build() -> AttachmentMediaData {
            return AttachmentMediaData(url: url!,
                                 fileType: fileType,
                                 width: width,
                                 height: height,
                                 thumbnailurl: thumbnailurl,
                                 size: size,
                                 mediaName: mediaName,
                                 pdfPageCount: pdfPageCount,
                                 duration: duration,
                                 awsFolderPath: awsFolderPath,
                                 format: format)
        }
    }
}
