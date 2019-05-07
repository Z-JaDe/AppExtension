//
//  AttributedStringMaker.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public struct AttributedStringMaker {
    public let text: String
    private let attrStr: NSMutableAttributedString
    public init(_ text: String) {
        self.text = text
        self.attrStr = NSMutableAttributedString(string: text)
    }
    public init(_ attrStr: NSAttributedString?) {
        guard let attrStr = attrStr else {
            self.text = ""
            self.attrStr = NSMutableAttributedString()
            return
        }
        self.text = attrStr.string
        if let attrStr = attrStr as? NSMutableAttributedString {
            self.attrStr = attrStr
        } else {
            // swiftlint:disable force_cast
            self.attrStr = attrStr.mutableCopy() as! NSMutableAttributedString
        }
    }

    private var defaultRange: NSRange {
        return NSRange(location: 0, length: self.attrStr.length)
    }
    public func attr() -> NSAttributedString {
        return self.attrStr.copy() as! NSAttributedString
    }
    // MARK: -
    public func color(_ color: UIColor?, range: NSRange? = nil) -> AttributedStringMaker {
        self.setAttribute(.foregroundColor, value: color, range: range)
        return self
    }
    public func font(_ font: UIFont?, range: NSRange? = nil) -> AttributedStringMaker {
        self.setAttribute(.font, value: font, range: range)
        return self
    }
    public func underLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> AttributedStringMaker {
        if let color = color {
            let underLineStyle: NSUnderlineStyle = NSUnderlineStyle.single
            self.setAttribute(.underlineStyle, value: NSNumber(value: underLineStyle.rawValue), range: range)
            self.setAttribute(.underlineColor, value: color, range: range)
        } else {
            self.setAttribute(.underlineStyle, value: nil, range: range)
            self.setAttribute(.underlineColor, value: nil, range: range)
        }
        return self
    }
    public func deleteLine(_ color: UIColor? = Color.gray, range: NSRange? = nil) -> AttributedStringMaker {
        if let color = color {
            let underLineStyle: NSUnderlineStyle = NSUnderlineStyle.single
            self.setAttribute(.strikethroughStyle, value: NSNumber(value: underLineStyle.rawValue), range: range)
            self.setAttribute(.strikethroughColor, value: color, range: range)
        } else {
            self.setAttribute(.underlineStyle, value: nil, range: range)
            self.setAttribute(.underlineColor, value: nil, range: range)
        }
        return self
    }
    public func kern(_ kern: Double?, range: NSRange? = nil) -> AttributedStringMaker {
        let value: NSNumber? = {
            if let kern = kern {return NSNumber(value: kern)}
            return nil
        }()
        self.setAttribute(.kern, value: value, range: range)
        return self
    }
    // MARK: paragraphStyle
    @discardableResult
    public func paragraphStyle(_ style: NSParagraphStyle?, range: NSRange? = nil) -> AttributedStringMaker {
        self.setAttribute(.paragraphStyle, value: style, range: range)
        return self
    }
    public func alignment(_ alignment: NSTextAlignment, range: NSRange? = nil) -> AttributedStringMaker {
        self.setParagraphStyleAttr(\.alignment, alignment, range)
        return self
    }
    public func lineSpacing(_ spacing: CGFloat, range: NSRange? = nil) -> AttributedStringMaker {
        self.setParagraphStyleAttr(\.lineSpacing, spacing, range)
        return self
    }
}
extension AttributedStringMaker {
    public func setAttribute(_ key: NSAttributedString.Key, value: Any?, range: NSRange?) {
        let range = range ?? defaultRange
        if let value = value {
            self.attrStr.addAttribute(key, value: value, range: range)
        } else {
            self.attrStr.removeAttribute(key, range: range)
        }
    }
    func setParagraphStyleAttr<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, T>, _ value: T, _ range: NSRange?) {
        let range = range ?? defaultRange
        self.attrStr.enumerateAttribute(.paragraphStyle, in: range, options: []) { (_style, _, _) in
            let style: NSMutableParagraphStyle
            if let _style = _style as? NSMutableParagraphStyle {
                style = _style
            } else if let _style = _style as? NSParagraphStyle {
                // swiftlint:disable force_cast
                style = _style.mutableCopy() as! NSMutableParagraphStyle
            } else {
                // swiftlint:disable force_cast
                let _mutableStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                style = _mutableStyle
            }
            if style[keyPath: keyPath] == value {return}
            style[keyPath: keyPath] = value
            self.paragraphStyle(style, range: range)
        }
    }
}
extension AttributedStringMaker {
    public static func += (left: inout AttributedStringMaker, right: AttributedStringMaker) {
        let attrStr: NSMutableAttributedString = left.attrStr
        attrStr.append(right.attrStr)
        left = AttributedStringMaker(attrStr)
    }
    public static func += (left: inout AttributedStringMaker, right: NSAttributedString) {
        let attrStr: NSMutableAttributedString = left.attrStr
        attrStr.append(right)
        left = AttributedStringMaker(attrStr)
    }
}
extension NSMutableAttributedString {
    /// ZJaDe: 两个属性字符串拼接
    public static func += (left: NSMutableAttributedString, right: AttributedStringMaker) {
        left.append(right.attr())
    }
    public static func += (left: NSMutableAttributedString, right: NSAttributedString) {
        left.append(right)
    }
}
// MARK: - UI
public protocol AttributedStringMakerProtocol: class {
    var attributedText: NSAttributedString? { get set }
}
extension AttributedStringMakerProtocol {
    public var attributedTextMaker: AttributedStringMaker? {
        get { return AttributedStringMaker(self.attributedText) }
        set { self.attributedText = newValue?.attr() }
    }
}
extension UILabel: AttributedStringMakerProtocol {}
extension UITextField: AttributedStringMakerProtocol {}

extension UITextView {
    public var attributedTextMaker: AttributedStringMaker? {
        get { return AttributedStringMaker(self.attributedText) }
        set { self.attributedText = newValue?.attr() }
    }
}
