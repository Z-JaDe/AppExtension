//
//  Button.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import CocoaExtension

open class Button: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
    }
    // MARK: -
    public enum ImagePosition {
        case left, right, top, bottom
    }
    public var imagePosition: ImagePosition = .left {
        didSet { setNeedsLayout() }
    }
    public var spacingBetweenImageAndTitle: CGFloat = 0 {
        didSet {
            spacingBetweenImageAndTitle = spacingBetweenImageAndTitle.flat()
            setNeedsLayout()
        }
    }
    // MARK: Round
    private var isRound: Bool = false
    open override func roundView() {
        self.isRound = true
        super.roundView()
    }
    public convenience init(image: UIImage?, backgroundColor: UIColor? = nil, inset: UIEdgeInsets? = nil) {
        self.init()
        self.setImage(image, for: .normal)
        self.setBackgroundColor(backgroundColor, for: .normal)
        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
    public convenience init(text: String, color: UIColor, font: UIFont, backgroundColor: UIColor? = nil, inset: UIEdgeInsets? = nil) {
        self.init()
        self.setTitle(text, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.titleLabel?.font = font
        self.setBackgroundColor(backgroundColor, for: .normal)
        if let inset = inset {
            self.contentEdgeInsets = inset
        }
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.isRound {
            self.roundView()
        }
        _layoutTitleAndImage()
    }
    open override var intrinsicContentSize: CGSize {
        sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        _sizeThatFits(size)
    }
}
// MARK: - Layout
extension Button {
    private func _sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        // 如果调用 sizeToFit，那么传进来的 size 就是当前按钮的 size，此时的计算不要去限制宽高
        if self.bounds.size == size {
            size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        }

        let spacing = calculateSpacingBetweenImageAndTitle()
        let contentLimitSize = size - contentEdgeInsets

        let imageTotalSize: CGSize = {
            guard let currentImage = self.currentImage else { return .zero }
            let imageSize: CGSize
            switch self.imagePosition {
            case .top, .bottom:
                let imageLimitWidth = contentLimitSize.width - imageEdgeInsets.horizontal
                imageSize = calculateImageSize(CGSize(width: imageLimitWidth, height: .greatestFiniteMagnitude), currentImage: currentImage)
            case .left, .right:
                let imageLimitHeight = contentLimitSize.height - imageEdgeInsets.vertical
                imageSize = calculateImageSize(CGSize(width: .greatestFiniteMagnitude, height: imageLimitHeight), currentImage: currentImage)
            }
            return imageSize + imageEdgeInsets
        }()
        let titleTotalSize: CGSize = {
            guard isTitleLabelShowing else { return .zero }
            var titleLimitSize: CGSize
            switch self.imagePosition {
            case .top, .bottom:
                titleLimitSize = contentLimitSize - titleEdgeInsets
                titleLimitSize.height -= imageTotalSize.height
                titleLimitSize.height -= spacing
            case .left, .right:
                // 注意这里有一个和系统不一致的行为：当 titleLabel 为多行时，系统的 sizeThatFits: 计算结果固定是单行的，所以当 QMUIButtonImagePositionLeft 并且titleLabel 多行的情况下，QMUIButton 计算的结果与系统不一致
                titleLimitSize = contentLimitSize - titleEdgeInsets
                titleLimitSize.width -= imageTotalSize.width
                titleLimitSize.width -= spacing
            }
            return calculateTitleSize(titleLimitSize) + titleEdgeInsets
        }()
        return calculateImageAndTitleTotalSize(imageTotalSize, titleTotalSize)
    }
}
extension Button {
    private func _layoutTitleAndImage() {
        if self.bounds.isEmpty { return }

        let spacing = calculateSpacingBetweenImageAndTitle()
        var imageFrame: CGRect = .zero
        var titleFrame: CGRect = .zero
        let contentLimitSize = bounds.size - contentEdgeInsets
        /// 根据 ImageSize+imageEdgeInsets算出的imageTotalSize
        var imageTotalSize: CGSize = {
            guard let currentImage = currentImage else { return .zero }
            // 图片的布局原则都是尽量完整展示，所以不管 imagePosition 的值是什么，这个计算过程都是相同的
            let imageLimitSize = contentLimitSize - imageEdgeInsets
            imageFrame.size = calculateImageSize(imageLimitSize, currentImage: currentImage)
            return imageFrame.size + imageEdgeInsets
        }()
        /// TitleSize+titleEdgeInsets算出的titleTotalSize
        var titleTotalSize: CGSize = {
            guard isTitleLabelShowing else { return .zero }
            var titleLimitSize: CGSize
            switch imagePosition {
            case .top, .bottom:
                titleLimitSize = contentLimitSize - titleEdgeInsets
                titleLimitSize.height -= imageTotalSize.height
                titleLimitSize.height -= spacing
            case .left, .right:
                titleLimitSize = contentLimitSize - titleEdgeInsets
                titleLimitSize.width -= imageTotalSize.width
                titleLimitSize.width -= spacing
            }
            titleFrame.size = calculateTitleSize(titleLimitSize, limitWidth: true)
            return titleFrame.size + titleEdgeInsets
        }()
        adjustImageAndTitleTotalSize(&imageTotalSize, &titleTotalSize, contentLimitSize)
        let tempContentRect = calculateTempContentRect(calculateImageAndTitleTotalSize(imageTotalSize, titleTotalSize))
        adjustImageAndTitleFrame(&imageFrame, &titleFrame, tempContentRect)
        ///
        if isImageViewShowing {
            self.imageView?.frame = imageFrame.flat()
        }
        if isTitleLabelShowing {
            self.titleLabel?.frame = titleFrame.flat()
        }
    }
}
// MARK: - Rect
extension Button {
    /**
     * 根据整体位置计算出最终imageFrame、titleFrame
     */
    func adjustImageAndTitleFrame(_ imageFrame: inout CGRect, _ titleFrame: inout CGRect, _ tempContentRect: CGRect) {
        let spacing = calculateSpacingBetweenImageAndTitle()
        let contentLimitRect = tempContentRect - contentEdgeInsets
        switch self.imagePosition {
        case .top:
            calculateX(&imageFrame, contentLimitRect)
            calculateX(&titleFrame, contentLimitRect)
            imageFrame.origin.y = 0
            titleFrame.origin.y = imageFrame.maxY + spacing
        case .bottom:
            calculateX(&imageFrame, contentLimitRect)
            calculateX(&titleFrame, contentLimitRect)
            titleFrame.origin.y = 0
            imageFrame.origin.y = titleFrame.maxY + spacing
        case .left:
            calculateY(&imageFrame, contentLimitRect)
            calculateY(&titleFrame, contentLimitRect)
            imageFrame.origin.x = 0
            titleFrame.origin.x = imageFrame.maxX + spacing
        case .right:
            calculateY(&imageFrame, contentLimitRect)
            calculateY(&titleFrame, contentLimitRect)
            titleFrame.origin.x = 0
            imageFrame.origin.x = titleFrame.maxX + spacing
        }
        imageFrame.origin.x += (contentLimitRect.origin.x + imageEdgeInsets.left)
        imageFrame.origin.y += (contentLimitRect.origin.y + imageEdgeInsets.top)
        titleFrame.origin.x += (contentLimitRect.origin.x + titleEdgeInsets.left)
        titleFrame.origin.y += (contentLimitRect.origin.y + titleEdgeInsets.top)
    }
    /**
     * 根据所有内容加间距尺寸 计算出 image和title的整体位置
     */
    func calculateTempContentRect(_ imageAndTitleTotalSize: CGSize) -> CGRect {
        var result: CGRect = CGRect(origin: .zero, size: imageAndTitleTotalSize)
        calculateX(&result, bounds)
        calculateY(&result, bounds)
        return result
    }
}
// MARK: - Position
extension Button {
    /**
     * 根据contentHorizontalAlignment 计算出 相对X
     */
    func calculateX(_ inner: inout CGRect, _ outer: CGRect) {
        switch self.contentHorizontalAlignment {
        case .left, .fill, .leading:
            inner.origin.x = 0
        case .right, .trailing:
            inner.origin.x = outer.size.width - inner.size.width
        case .center:
            inner.origin.x = (outer.size.width - inner.size.width) / 2
        @unknown default:
            break
        }
    }
    /**
     * 根据contentVerticalAlignment 计算出 相对Y
     */
    func calculateY(_ inner: inout CGRect, _ outer: CGRect) {
        switch self.contentVerticalAlignment {
        case .top, .fill:
            inner.origin.y = 0
        case .bottom:
            inner.origin.y = outer.size.height - inner.size.height
        case .center:
            inner.origin.y = (outer.size.height - inner.size.height) / 2
        @unknown default:
            break
        }
    }
}
// MARK: - Size
extension Button {
    /**
     * contentHorizontalAlignment、contentVerticalAlignment为 fill时 需要重新适配imageTotalSize、titleTotalSize
     */
    // swiftlint:disable cyclomatic_complexity
    func adjustImageAndTitleTotalSize(_ imageTotalSize: inout CGSize, _ titleTotalSize: inout CGSize, _ contentLimitSize: CGSize) {
        guard isImageViewShowing else { return }
        let spacing = calculateSpacingBetweenImageAndTitle()
        if self.contentHorizontalAlignment == .fill {
            switch self.imagePosition {
            case .top, .bottom:
                imageTotalSize.width = contentLimitSize.width
                titleTotalSize.width = contentLimitSize.width
            case .left, .right:
                // 同时显示图片和 label 的情况下，图片按本身宽度显示，剩余空间留给 label
                if isImageViewShowing && isTitleLabelShowing {
                    titleTotalSize.width = contentLimitSize.width - spacing - imageTotalSize.width
                } else if isImageViewShowing {
                    imageTotalSize.width = contentLimitSize.width
                } else if isTitleLabelShowing {
                    titleTotalSize.width = contentLimitSize.width
                }
            }
        }
        if self.contentVerticalAlignment == .fill {
            switch self.imagePosition {
            case .top, .bottom:
                // 同时显示图片和 label 的情况下，图片高度按本身大小显示，剩余空间留给 label
                if isImageViewShowing && isTitleLabelShowing {
                    titleTotalSize.height = contentLimitSize.height - spacing - imageTotalSize.height
                } else if isImageViewShowing {
                    imageTotalSize.height = contentLimitSize.height
                } else if isTitleLabelShowing {
                    titleTotalSize.height = contentLimitSize.height
                }
            case .left, .right:
                imageTotalSize.height = contentLimitSize.height
                titleTotalSize.height = contentLimitSize.height
            }
        }
    }
    /**
     * 根据imageTotalSize 和 titleTotalSize
     * 得出 加上所有间距和内缩 总共的Size
     */
    func calculateImageAndTitleTotalSize(_ imageTotalSize: CGSize, _ titleTotalSize: CGSize) -> CGSize {
        let spacing = calculateSpacingBetweenImageAndTitle()
        var result: CGSize = .zero
        switch self.imagePosition {
        case .top, .bottom:
            // 图片和文字上下排版时，宽度以文字或图片的最大宽度为最终宽度
            result.width = max(imageTotalSize.width, titleTotalSize.width)
            result.height = imageTotalSize.height + titleTotalSize.height + spacing
        case .left, .right:
            // 图片和文字水平排版时，高度以文字或图片的最大高度为最终高度
            result.height = max(imageTotalSize.height, titleTotalSize.height)
            result.width = imageTotalSize.width + titleTotalSize.width + spacing
        }
        return result + contentEdgeInsets
    }
}
extension Button {
    /**
     * 返回合适的 TitleSize
     */
    func calculateTitleSize(_ size: CGSize, limitWidth: Bool = false) -> CGSize {
        var result: CGSize = self.titleLabel?.sizeThatFits(size) ?? .zero
        if limitWidth {
            result.width = min(result.width, size.width)
        }
        result.height = min(result.height, size.height)
        return result
    }
    /**
    * 返回合适的 ImageSize
    */
    func calculateImageSize(_ size: CGSize, currentImage: UIImage) -> CGSize {
        var result: CGSize
        if let imageView = self.imageView, imageView.image != nil {
            result = imageView.sizeThatFits(size)
        } else {
            result = currentImage.size
        }
        if size.width != .greatestFiniteMagnitude {
            result.width = min(result.width, size.width)
        }
        if size.height != .greatestFiniteMagnitude {
            result.height = min(result.height, size.height)
        }
        return result
    }
}
// MARK: -
extension Button {
    var isImageViewShowing: Bool {
        self.currentImage != nil
    }
    var isTitleLabelShowing: Bool {
        self.currentTitle != nil || self.currentAttributedTitle != nil
    }
    func calculateSpacingBetweenImageAndTitle() -> CGFloat {
        // 如果图片或文字某一者没显示，则这个 spacing 不考虑进布局
        isImageViewShowing && isTitleLabelShowing ? self.spacingBetweenImageAndTitle : 0
    }
}
