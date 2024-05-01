//
//  AttachmentUploadRequest.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 15/04/24.
//

import Foundation

import Foundation

class AttachmentUploadRequest {
    let name: String?
    let fileUrl: URL?
    let fileType: String
    let awsFolderPath: String
    let localFilePath: String?
    let index: Int
    let width: Int?
    let height: Int?
    let thumbnailUri: URL?
    let thumbnailAWSFolderPath: String?
    let thumbnailLocalFilePath: String?
    let isThumbnail: Bool?
    let hasThumbnail: Bool?
    let meta: AttachmentMetaDataRequest?
    
    static func builder() -> Builder {
        Builder()
    }
    
    private init(name: String?,
                 fileUrl: URL?,
                 fileType: String,
                 awsFolderPath: String,
                 localFilePath: String?,
                 index: Int,
                 width: Int?,
                 height: Int?,
                 thumbnailUri: URL?,
                 thumbnailAWSFolderPath: String?,
                 thumbnailLocalFilePath: String?,
                 isThumbnail: Bool?,
                 hasThumbnail: Bool?,
                 meta: AttachmentMetaDataRequest?) {
        self.name = name
        self.fileUrl = fileUrl
        self.fileType = fileType
        self.awsFolderPath = awsFolderPath
        self.localFilePath = localFilePath
        self.index = index
        self.width = width
        self.height = height
        self.thumbnailUri = thumbnailUri
        self.thumbnailAWSFolderPath = thumbnailAWSFolderPath
        self.thumbnailLocalFilePath = thumbnailLocalFilePath
        self.isThumbnail = isThumbnail
        self.hasThumbnail = hasThumbnail
        self.meta = meta
    }
    
    class Builder {
        private var name: String? = nil
        private var fileUrl: URL? = nil
        private var fileType: String = ""
        private var awsFolderPath: String = ""
        private var localFilePath: String? = nil
        private var index: Int = 0
        private var width: Int? = nil
        private var height: Int? = nil
        private var thumbnailUri: URL? = nil
        private var thumbnailAWSFolderPath: String? = nil
        private var thumbnailLocalFilePath: String? = nil
        private var isThumbnail: Bool? = nil
        private var hasThumbnail: Bool? = nil
        private var meta: AttachmentMetaDataRequest? = nil
        
        func name(_ name: String?) -> Builder {
            self.name = name
            return self
        }
        
        func fileUrl(_ fileUrl: URL?) -> Builder {
            self.fileUrl = fileUrl
            return self
        }
        
        func fileType(_ fileType: String) -> Builder {
            self.fileType = fileType
            return self
        }
        
        func awsFolderPath(_ awsFolderPath: String) -> Builder {
            self.awsFolderPath = awsFolderPath
            return self
        }
        
        func localFilePath(_ localFilePath: String?) -> Builder {
            self.localFilePath = localFilePath
            return self
        }
        
        func index(_ index: Int) -> Builder {
            self.index = index
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
        
        func thumbnailUri(_ thumbnailUri: URL?) -> Builder {
            self.thumbnailUri = thumbnailUri
            return self
        }
        
        func thumbnailAWSFolderPath(_ thumbnailAWSFolderPath: String?) -> Builder {
            self.thumbnailAWSFolderPath = thumbnailAWSFolderPath
            return self
        }
        
        func thumbnailLocalFilePath(_ thumbnailLocalFilePath: String?) -> Builder {
            self.thumbnailLocalFilePath = thumbnailLocalFilePath
            return self
        }
        
        func isThumbnail(_ isThumbnail: Bool?) -> Builder {
            self.isThumbnail = isThumbnail
            return self
        }
        
        func hasThumbnail(_ hasThumbnail: Bool?) -> Builder {
            self.hasThumbnail = hasThumbnail
            return self
        }
        
        func meta(_ meta: AttachmentMetaDataRequest?) -> Builder {
            self.meta = meta
            return self
        }
        
        func build() -> AttachmentUploadRequest {
            return AttachmentUploadRequest(name: name,
                                      fileUrl: fileUrl,
                                      fileType: fileType,
                                      awsFolderPath: awsFolderPath,
                                      localFilePath: localFilePath,
                                      index: index,
                                      width: width,
                                      height: height,
                                      thumbnailUri: thumbnailUri,
                                      thumbnailAWSFolderPath: thumbnailAWSFolderPath,
                                      thumbnailLocalFilePath: thumbnailLocalFilePath,
                                      isThumbnail: isThumbnail,
                                      hasThumbnail: hasThumbnail,
                                      meta: meta)
        }
    }
    
    func toBuilder() -> Builder {
        return Builder()
            .name(name)
            .fileUrl(fileUrl)
            .fileType(fileType)
            .awsFolderPath(awsFolderPath)
            .localFilePath(localFilePath)
            .index(index)
            .width(width)
            .height(height)
            .thumbnailUri(thumbnailUri)
            .thumbnailAWSFolderPath(thumbnailAWSFolderPath)
            .thumbnailLocalFilePath(thumbnailLocalFilePath)
            .isThumbnail(isThumbnail)
            .hasThumbnail(hasThumbnail)
            .meta(meta)
    }
}
