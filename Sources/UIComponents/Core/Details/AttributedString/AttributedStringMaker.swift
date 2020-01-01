//
//  AttributedStringMaker.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
//为了防止链式写法不断写时拷贝，使用class
public class AttributedStringMaker {
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
        self.attrStr.string
    }
}
extension AttributedStringMaker {
    public func then(_ closure: (AttributedStringMaker) -> Void) -> Self {
        closure(self)
        return self
    }
    @discardableResult
    func _setAttribute(_ key: NSAttributedString.Key, value: Any?, range: NSRange?) -> Self {
        self.attrStr.setAttribute(key, value: value, range: range)
        return self
    }
    @discardableResult
    func _paragraphStyle(_ style: NSParagraphStyle?, range: NSRange? = nil) -> Self {
        self.attrStr.setAttribute(.paragraphStyle, value: style, range: range)
        return self
    }
    @discardableResult
    func _setParagraphStyleAttr<T: Equatable>(_ keyPath: ReferenceWritableKeyPath<NSMutableParagraphStyle, T>, _ value: T, _ range: NSRange?) -> Self {
        self.attrStr.setParagraphStyleAttr(keyPath, value, range)
        return self
    }
}

extension AttributedStringMaker {
    public static func + (left: AttributedStringMaker, right: AttributedStringMakerProtocol) -> AttributedStringMaker {
        var attrStr = left.attrStr
        attrStr.append(right.createMaker().attrStr)
        return AttributedStringMaker(attrStr)
    }
    public static func += (left: inout AttributedStringMaker, right: AttributedStringMakerProtocol) {
        // swiftlint:disable shorthand_operator
        left = left + right
    }
}
