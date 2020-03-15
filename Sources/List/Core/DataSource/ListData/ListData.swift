//
//  ListData.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public struct ListData<Section, Item>: CollectionProtocol {
    public typealias Element = SectionData<Section, Item>
    public var value: ContiguousArray<Element>
    public init<C: Swift.Collection>(_ elements: C) where C.Element == Element {
        self.value = ContiguousArray(elements)
    }
    public func map<U>(_ transform: (Item) throws -> U) rethrows -> ListData<Section, U> {
        let value = try self.value.lazy.map({try $0.map(transform)})
        return ListData<Section, U>(value)
    }
    public func filter(_ transform: (Item) throws -> Bool) rethrows -> ListData {
        let value = try self.value.lazy.map({try $0.filter(transform)})
            .filter({$0.items.isEmpty == false})
        return ListData(value)
    }

    public var itemCount: Int {
        self.value.map({$0.items.count}).reduce(0, +)
    }
}
extension ListData: ExpressibleByArrayLiteral {
    public init() {
        self.init([])
    }
    public init(_ element: (Section, [Item])) {
        self.init(CollectionOfOne(element).map(Element.init))
    }
    public init(arrayLiteral elements: (Section, [Item])...) {
        self.init(elements.map(Element.init))
    }
    public static func += (lhs: inout ListData, rhs: (Section, [Item])) {
        lhs.append(Element(rhs.0, rhs.1))
    }
    public static func += (lhs: inout ListData, rhs: Element) {
        lhs.append(rhs)
    }
}
extension ListData where Item: Equatable {
    public func move(_ item1: Item, _ item2: Item) -> ListData {
        var listData = self
        for (offset: sectionIndex, element: section) in self.enumerated() {
            for (itemIndex, item) in section.items.enumerated() {
                if item == item1 {
                    listData[sectionIndex].items.remove(at: itemIndex)
                }
                if item == item2 {
                    listData[sectionIndex].items.insert(item1, at: itemIndex)
                }
            }
        }
        return listData
    }
}
