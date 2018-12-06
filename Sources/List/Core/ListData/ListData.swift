//
//  ListData.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public struct ListData<Section: Diffable, Item: Diffable>: CollectionProtocol {
    public typealias Element = (section: Section, items: [Item])
    public var value: ContiguousArray<Element>
    public init<C: Swift.Collection>(_ elements: C) where C.Element == Element {
        self.value = ContiguousArray(elements)
    }

    public func map<U: Diffable>(_ transform: (Item) throws -> U) rethrows -> ListData<Section, U> {
        let value = try self.value.lazy.map({($0.section, try $0.items.map(transform))})
        return ListData<Section, U>(value)
    }
    public func filter(_ transform: (Item) throws -> Bool) rethrows -> ListData {
        let value = try self.value.lazy.map({
            ($0.section, try $0.items.filter(transform))
        }).filter({$0.1.count > 0})
        return ListData(value)
    }

    public var itemCount: Int {
        return self.value.flatMap({$0.items}).count
    }
}
