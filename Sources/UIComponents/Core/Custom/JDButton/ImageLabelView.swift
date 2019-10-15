//
//  ImageLabelView.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/20.
//

import UIKit

open class ImageLabelView: CustomControl {
    public convenience init(image: UIImage?, inset: UIEdgeInsets? = nil) {
        self.init()
        self.config(image: image)
        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
    public convenience init(text: String, color: UIColor, font: UIFont, inset: UIEdgeInsets? = nil) {
        self.init()
        self.config(text: text, color: color, font: font)

        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
    // ZJaDe: 
    public private(set) lazy var imageView: ImageView = {
        let result = ImageView()
        result.isUserInteractionEnabled = false
        config(imageView: result)
        return result
    }()
    internal func config(imageView: ImageView) {
        imageView.image = self.image
    }
    public private(set) lazy var titleLabel: Label = {
        let result = Label()
        result.isUserInteractionEnabled = false
        config(titleLabel: result)
        return result
    }()
    internal func config(titleLabel: Label) {
        titleLabel.attributedText = self.attributedTitle
    }
    // MARK: -
    private var _contentStackView: UIStackView?
    public var contentStackView: UIStackView {
        if let result = _contentStackView {
            return result
        } else {
            let result = UIStackView(axis: .horizontal, alignment: .center, distribution: .fill, spacing: 8)
            result.isUserInteractionEnabled = false
            _contentStackView = result
            return result
        }
    }
    public enum ImageAlignment {
        case begin
        case end
    }
    /// ZJaDe: image和label的相对位置
    public var imageAlignment: ImageAlignment = .begin {
        didSet {updateContentItem()}
    }
    public override func getContentItem() -> UIView? {
        let hasImage = self.hasImage
        let hasTitle = self.hasTitle
        func removeContentStackView() {
            if let contentStackView = _contentStackView {
                bindingView(contentStackView, false)
            }
        }
        switch (hasImage, hasTitle) {
        case (true, false):
            removeContentStackView()
            bindingView(self.imageView, true)
            return self.imageView
        case (false, true):
            removeContentStackView()
            bindingView(self.titleLabel, true)
            return self.titleLabel
        case (true, true):
            bindingView(self.contentStackView, true)
            self.contentStackView.removeAllSubviews()
            switch self.imageAlignment {
            case .begin:
                self.contentStackView.addArrangedSubview(self.imageView)
                self.contentStackView.addArrangedSubview(self.titleLabel)
            case .end:
                self.contentStackView.addArrangedSubview(self.titleLabel)
                self.contentStackView.addArrangedSubview(self.imageView)
            }
            return self.contentStackView
        case (false, false):
            removeContentStackView()
            return nil
        }
    }

    // MARK: - ContentSize
    open override var intrinsicContentSize: CGSize {
        let hasImage = self.hasImage
        let hasTitle = self.hasTitle
        var result = CGSize(width: self.contentEdgeInsets.left + self.contentEdgeInsets.right, height: self.contentEdgeInsets.top + self.contentEdgeInsets.bottom)
        switch (hasImage, hasTitle) {
        case (true, false):
            let imageSize = self.imageView.intrinsicContentSize
            result += imageSize
        case (false, true):
            let labelSize = self.titleLabel.intrinsicContentSize
            result += labelSize
        case (true, true):
            let imageSize = self.imageView.intrinsicContentSize
            let labelSize = self.titleLabel.intrinsicContentSize
            switch self.contentStackView.axis {
            case .horizontal:
                result += CGSize(width: labelSize.width + imageSize.width + self.contentStackView.spacing, height: max(labelSize.height, imageSize.height))
            case .vertical:
                result += CGSize(width: max(labelSize.width, imageSize.width), height: labelSize.height + imageSize.height + self.contentStackView.spacing)
            @unknown default:
                fatalError()
            }
        case (false, false):
            result = super.intrinsicContentSize
        }
        return result
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.intrinsicContentSize
    }
    // MARK: -
    public var image: UIImage? {
        didSet {updateImageViewData()}
    }
    public func config(image: UIImage?) {
        self.image = image
    }
    public var attributedTitle: NSAttributedString? {
        didSet {updateTitleLabelData()}
    }
    public func config(text: String, color: UIColor, font: UIFont) {
        self.titleColor = color
        self.titleFont = font
        self.title = text
    }
    public var title: String? {
        get {return self.attributedTitle?.string}
        set {
            self.attributedTitle = newValue?.font(titleFont).color(titleColor).finalize()
        }
    }
    public var titleFont: UIFont? {
        didSet {
            let titleFont = self.titleFont ?? Font.h3
            self.attributedTitle = self.attributedTitle?.font(titleFont).finalize()
        }
    }
    public var titleColor: UIColor? {
        didSet {
            let textColor = self.titleColor ?? Color.black
            self.attributedTitle = self.attributedTitle?.color(textColor).finalize()
        }
    }
    func updateTitleLabelData() {
        updateData()
        updateContentItem()
    }
    func updateImageViewData() {
        updateData()
        updateContentItem()
    }
    // MARK: -
    func updateData() {
        if hasTitle {
            self.config(titleLabel: self.titleLabel)
        }
        if hasImage {
            self.config(imageView: self.imageView)
        }
        invalidateIntrinsicContentSize()
    }
    var hasTitle: Bool {
        title != nil
    }
    var hasImage: Bool {
        image != nil
    }
}
