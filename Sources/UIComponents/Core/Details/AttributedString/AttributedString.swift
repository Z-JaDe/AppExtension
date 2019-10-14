//
//  AttributedString.swift
//  AppExtension
//
//  Created by Apple on 2019/10/14.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public struct AttributedString {
    typealias T = NSMutableAttributedString
    private var _value: T
    private var _valueForWriting: T {
        mutating get {
            if !isKnownUniquelyReferenced(&_value) {
                // swiftlint:disable force_cast
                _value = _value.mutableCopy() as! T
            }
            return _value
        }
    }

    public init(_ value: String = "") {
        self._value = NSMutableAttributedString(string: value)
    }
    public init(_ value: NSAttributedString?) {
        guard let value = value else {
            self._value = T()
            return
        }
        if let value = value as? T {
            self._value = value
        } else {
            // swiftlint:disable force_cast
            self._value = value.mutableCopy() as! T
        }
    }
    public var string: String {
        self._value.string
    }
    public func finalize() -> NSAttributedString {
        return _value.copy() as! NSAttributedString
    }
    public var defaultRange: NSRange {
        NSRange(location: 0, length: self._value.length)
    }
}
extension AttributedString {
    public mutating func append(_ attrString: AttributedString) {
        _valueForWriting.append(attrString._value)
    }
    public mutating func setAttribute(_ key: NSAttributedString.Key, value: Any?, range: NSRange?) {
        let range = range ?? defaultRange
        if let value = value {
            _valueForWriting.addAttribute(key, value: value, range: range)
        } else {
            _valueForWriting.removeAttribute(key, range: range)
        }
    }
    public mutating func paragraphStyle(_ style: NSParagraphStyle?, range: NSRange? = nil) {
        setAttribute(.paragraphStyle, value: style, range: range)
    }
    public mutating func setParagraphStyleAttr<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, T>, _ value: T, _ range: NSRange?) {
        let range = range ?? defaultRange
        self._valueForWriting.enumerateAttribute(.paragraphStyle, in: range, options: []) { (_style, _, _) in
            let style: NSMutableParagraphStyle = {
                switch _style {
                case let style as NSMutableParagraphStyle:
                    return style
                case let style as NSParagraphStyle:
                    // swiftlint:disable force_cast
                    return style.mutableCopy() as! NSMutableParagraphStyle
                default:
                    // swiftlint:disable force_cast
                    return NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
                }
            }()
            if style[keyPath: keyPath] == value {return}
            style[keyPath: keyPath] = value
            self.paragraphStyle(style, range: range)
        }
    }
}
