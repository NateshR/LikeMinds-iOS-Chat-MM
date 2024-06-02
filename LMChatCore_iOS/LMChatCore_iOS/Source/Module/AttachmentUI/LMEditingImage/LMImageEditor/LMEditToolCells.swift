//
//  LMEditToolCells.swift
//  LMImageEditor
//
//  Created by long on 2021/12/21.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

// MARK: Edit tool cell

class LMEditToolCell: UICollectionViewCell {
    var toolType: LMImageEditorConfiguration.EditTool = .draw {
        didSet {
            switch toolType {
            case .draw:
                icon.image = .lm.getImage("lm_drawLine")
                icon.highlightedImage = .lm.getImage("lm_drawLine_selected")
            case .clip:
                icon.image = .lm.getImage("lm_clip")
                icon.highlightedImage = .lm.getImage("lm_clip")
            case .imageSticker:
                icon.image = .lm.getImage("lm_imageSticker")
                icon.highlightedImage = .lm.getImage("lm_imageSticker")
            case .textSticker:
                icon.image = .lm.getImage("lm_textSticker")
                icon.highlightedImage = .lm.getImage("lm_textSticker")
            case .mosaic:
                icon.image = .lm.getImage("lm_mosaic")
                icon.highlightedImage = .lm.getImage("lm_mosaic_selected")
            case .filter:
                icon.image = .lm.getImage("lm_filter")
                icon.highlightedImage = .lm.getImage("lm_filter_selected")
            case .adjust:
                icon.image = .lm.getImage("lm_adjust")
                icon.highlightedImage = .lm.getImage("lm_adjust_selected")
            }
            if let color = UIColor.lm.toolIconHighlightedColor {
                icon.highlightedImage = icon.highlightedImage?
                    .lm.fillColor(color)
            }
        }
    }
    
    lazy var icon = UIImageView(frame: contentView.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: draw color cell

class LMDrawColorCell: UICollectionViewCell {
    lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return view
    }()
    
    lazy var bgWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        return view
    }()
    
    var color: UIColor = .clear {
        didSet {
            colorView.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bgWhiteView)
        contentView.addSubview(colorView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.center = contentView.center
        bgWhiteView.center = contentView.center
    }
}

// MARK: filter cell

class LMFilterImageCell: UICollectionViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: adjust tool cell

class LMAdjustToolCell: UICollectionViewCell {
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: bounds.height - 30, width: bounds.width, height: 30)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: (bounds.width - 30) / 2, y: 0, width: 30, height: 30)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var adjustTool: LMImageEditorConfiguration.AdjustTool = .brightness {
        didSet {
            switch adjustTool {
            case .brightness:
                imageView.image = .lm.getImage("lm_brightness")
                imageView.highlightedImage = .lm.getImage("lm_brightness_selected")
                nameLabel.text = EditImageConstants.brightness
            case .contrast:
                imageView.image = .lm.getImage("lm_contrast")
                imageView.highlightedImage = .lm.getImage("lm_contrast_selected")
                nameLabel.text = EditImageConstants.contrast
            case .saturation:
                imageView.image = .lm.getImage("lm_saturation")
                imageView.highlightedImage = .lm.getImage("lm_saturation_selected")
                nameLabel.text = EditImageConstants.saturation
            }
            if let color = UIColor.lm.toolIconHighlightedColor {
                imageView.highlightedImage = imageView.highlightedImage?
                    .lm.fillColor(color)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
