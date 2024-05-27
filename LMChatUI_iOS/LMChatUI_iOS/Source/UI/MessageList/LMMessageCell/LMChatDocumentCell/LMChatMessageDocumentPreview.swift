//
//  LMMessageDocumentPreview.swift
//  SampleApp
//
//  Created by Devansh Mohata on 02/04/24.
//

import UIKit

public protocol LMChatMessageDocumentPreviewDelegate: AnyObject {
    func onClickAttachment(_ url: String)
}

open class LMChatMessageDocumentPreview: LMView {
    
    public struct ContentModel {
        public let fileUrl: String?
        public let thumbnailUrl: String?
        public let fileSize: Int?
        public let numberOfPages: Int?
        public let fileType: String?
        public let fileName: String?
        public var fileSizeInMb: String {
            guard let fileSize else { return "" }
            let kbs = Float((fileSize )/1000)
            let size = kbs > 999 ? String(format: "%0.2f MB",(kbs/1000)) : String(format: "%0.1f KB", kbs)
           return size
        }
    }
    
    weak var delegate: LMChatMessageDocumentPreviewDelegate?
    
    public var outerStackView: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    public var previewImage: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        return image
    }()
    
    public var containerView: LMView = {
        let view = LMView().translatesAutoresizingMaskIntoConstraints()
        return view
    }()
    
    public var innerStackView: LMStackView = {
        let stack = LMStackView().translatesAutoresizingMaskIntoConstraints()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = 4
        return stack
    }()
    
    public var sampleImage: LMImageView = {
        let image = LMImageView().translatesAutoresizingMaskIntoConstraints()
        image.clipsToBounds = true
        image.setWidthConstraint(with: 40)
        image.setHeightConstraint(with: 50)
        image.image = Constants.shared.images.documentsIcon
        image.tintColor = .systemRed
        return image
    }()
    
    public var titleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.font = Appearance.shared.fonts.subHeadingFont2
        label.textColor = Appearance.shared.colors.black
        return label
    }()
    
    public var subtitleLabel: LMLabel = {
        let label = LMLabel().translatesAutoresizingMaskIntoConstraints()
        label.font = Appearance.shared.fonts.subHeadingFont1
        label.textColor = Appearance.shared.colors.previewSubtitleTextColor
        label.text = "10 Pages • 1.8 MB • PDF"
        return label
    }()
    
    var viewData: ContentModel?
    
    open override func setupViews() {
        addSubview(outerStackView)
//        outerStackView.addArrangedSubview(previewImage)
        outerStackView.addArrangedSubview(containerView)
        
        containerView.addSubview(sampleImage)
        containerView.addSubview(innerStackView)
        
        innerStackView.addArrangedSubview(titleLabel)
        innerStackView.addArrangedSubview(subtitleLabel)
//        previewImage.image = UIImage(named: "imag", in: LMChatCoreBundle, with: nil)
        
        containerView.backgroundColor = Appearance.shared.colors.previewBackgroundColor
//        previewImage.isHidden = true
        isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(onAttachmentClicked))
        tapGuesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGuesture)
    }
    
    open override func setupLayouts() {
        
        NSLayoutConstraint.activate([
            outerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            outerStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            outerStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
//            previewImage.heightAnchor.constraint(equalTo: previewImage.widthAnchor, multiplier: 0.5),
            
            sampleImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 4),
            sampleImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            sampleImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4),
            
            innerStackView.topAnchor.constraint(greaterThanOrEqualTo: containerView.topAnchor, constant: 12),
            innerStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12),
            innerStackView.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -16),
            innerStackView.leadingAnchor.constraint(equalTo: sampleImage.trailingAnchor, constant: 4),
//            innerStackView.centerYAnchor.constraint(equalTo: sampleImage.centerYAnchor)
        ])
        
        let cons = titleLabel.heightAnchor.constraint(equalToConstant: 10)
        cons.priority = .defaultLow
        cons.isActive = true
    }
    
    func setData(_ data: ContentModel) {
        viewData = data
        let fileName = data.fileName ?? ""
        titleLabel.text = fileName.isEmpty ? "Document" : fileName
        var details = ""
        if let pages = data.numberOfPages, pages > 0 {
            details = details + "\(data.numberOfPages ?? 0) Pages • "
        }
        if !data.fileSizeInMb.isEmpty {
            details = details + "\(data.fileSizeInMb) • "
        }
        subtitleLabel.text = details + "\(data.fileType?.uppercased() ?? "PDF")"
    }
    
    @objc func onAttachmentClicked(_ gesture: UITapGestureRecognizer) {
        guard let url = viewData?.fileUrl else { return }
        delegate?.onClickAttachment(url)
    }
}
