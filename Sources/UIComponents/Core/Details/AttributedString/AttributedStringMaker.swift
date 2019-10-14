//
//  AttributedStringMaker.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public struct AttributedStringMaker {
    var attrStr: AttributedString
    init(_ value: AttributedString) {
        self.attrStr = value
    }
    init(_ value: String = "") {
        self.attrStr = AttributedString(value)
    }
    init(_ value: NSAttributedString?) {
        self.attrStr = AttributedString(value)
    }
    public func finalize() -> NSAttributedString {
        self.attrStr.finalize()
    }
    fileprivate var defaultRange: NSRange {
        self.attrStr.defaultRange
    }
}
extension AttributedStringMaker {
    public var string: String {
        return self.attrStr.string
    }
    public func then(_ closure: (inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }
}
extension AttributedStringMaker {
    mutating func _setAttribute(_ key: NSAttributedString.Key, value: Any?, range: NSRange?) {
        self.attrStr.setAttribute(key, value: value, range: range)
    }
    mutating func _paragraphStyle(_ style: NSParagraphStyle?, range: NSRange? = nil) {
        self.attrStr.setAttribute(.paragraphStyle, value: style, range: range)
    }
    mutating func _setParagraphStyleAttr<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, T>, _ value: T, _ range: NSRange?) {
        self.attrStr.setParagraphStyleAttr(keyPath, value, range)
    }
}

extension AttributedStringMaker {
    public static func + (left: AttributedStringMaker, right: AttributedStringMakerProtocol) -> AttributedStringMaker {
        var attrStr = left.attrStr
        attrStr.append(right.createMaker().attrStr)
        return AttributedStringMaker(attrStr)
    }
    public static func += (left: inout AttributedStringMaker, right: AttributedStringMakerProtocol) {
        left.attrStr.append(right.createMaker().attrStr)
    }
}
