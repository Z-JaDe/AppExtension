//
//  TextView.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
extension TextView {
    public convenience init(text: String? = nil, placeholder: String = "", color: UIColor, font: UIFont) {
        self.init()
        self.text = text
        self.placeholder = placeholder
        self.textColor = color
        self.font = font
        setNeedsLayout()
    }
}
open class TextView: UITextView {
    open var placeholder = "" {
        didSet {setNeedsDisplay()}
    }
    open var placeholderColor = Color.placeholder {
        didSet {setNeedsDisplay()}
    }
    open var attributedPlaceholder: NSAttributedString? {
        didSet {setNeedsDisplay()}
    }
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
        if self.textColor == nil {
            self.textColor = Color.black
        }
        if self.font == nil {
            self.font = Font.thinh3
        }
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged(_: )), name: UITextView.textDidChangeNotification, object: self)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
    @objc private func textChanged(_ notification: Notification) {
        self.setNeedsDisplay()
    }
    // MARK: -
    public var contentSizeChanged: ((CGSize) -> Void)?
    open override var contentSize: CGSize {
        didSet {
            if contentSize != oldValue {
                self.contentSizeChanged?(self.contentSize)
            }
        }
    }
    // MARK: -
    open override var text: String! {
        didSet {setNeedsDisplay()}
    }
    open override func insertText(_ text: String) {
        super.insertText(text)
        self.setNeedsDisplay()
    }
    open override func deleteBackward() {
        super.deleteBackward()
        self.setNeedsDisplay()
    }
    open override var attributedText: NSAttributedString! {
        didSet {setNeedsDisplay()}
    }
    open override var textContainerInset: UIEdgeInsets {
        didSet {setNeedsDisplay()}

    }
    open override var font: UIFont? {
        didSet {setNeedsDisplay()}
    }
    open override var textAlignment: NSTextAlignment {
        didSet {setNeedsDisplay()}
    }
    // MARK: /*************** drawRect ***************/
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard self.text.isEmpty else {
            return
        }
        var attributedStr: NSAttributedString
        if let result = self.attributedPlaceholder {
            attributedStr = result
        } else {
            var attributes = [NSAttributedString.Key: Any]()
            attributes[.font] = self.font
            attributes[.foregroundColor] = self.placeholderColor
            if self.textAlignment != .left {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = self.textAlignment
                attributes[.paragraphStyle] = paragraph
            }
            attributedStr = NSAttributedString(string: self.placeholder, attributes: attributes)
        }
        let placeholderRect = self.placeholderRectForBounds(self.bounds)
        attributedStr.draw(in: placeholderRect)
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.text.isEmpty && (self.placeholder.isEmpty == false || self.attributedPlaceholder != nil) {
            setNeedsDisplay()
        }
    }
    open func placeholderRectForBounds(_ bounds: CGRect) -> CGRect {
        var rect = bounds.inset(by: self.textContainerInset)
        let padding = self.textContainer.lineFragmentPadding
        rect.origin.x += padding
        rect.size.width -= padding * 2.0
        return rect
    }
}
