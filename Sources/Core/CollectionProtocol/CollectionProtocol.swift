//
//  CollectionProtocol.swift
//  Codable
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol CollectionProtocol: RandomAccessCollection,
    RangeReplaceableCollection,
    MutableCollection,
    ExpressibleByArrayLiteral {
    associatedtype Element
    var value: ContiguousArray<Element> {get set}
    init<C: Swift.Collection>(_ changesets: C) where C.Element == Element
}
extension CollectionProtocol {
    public var startIndex: Int {
        return value.startIndex
    }
    public var endIndex: Int {
        return value.endIndex
    }
    public func index(after i: Int) -> Int {
        return value.index(after: i)
    }
    public subscript(position: Int) -> Element {
        get { return value[position] }
        set { value[position] = newValue }
    }

    public mutating func replaceSubrange<C: Swift.Collection, R: RangeExpression>(_ subrange: R, with newElements: C) where C.Element == Element, R.Bound == Int {
        value.replaceSubrange(subrange, with: newElements)
    }
}
extension CollectionProtocol {
    public init() {
        self.init([])
    }
    public init(arrayLiteral elements: Element...) {
        self.init(elements)
    }
}
