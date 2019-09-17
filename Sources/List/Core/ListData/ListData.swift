//
//  ListData.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public struct ListData<Section: Diffable, Item: Diffable & Equatable>: CollectionProtocol {
    public typealias Element = SectionData<Section, Item>
    public var value: ContiguousArray<Element>
    public init<C: Swift.Collection>(_ elements: C) where C.Element == Element {
        self.value = ContiguousArray(elements)
    }
    public func map<U: Diffable>(_ transform: (Item) throws -> U) rethrows -> ListData<Section, U> {
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
    public func exchange(_ item1: Item, _ item2: Item) -> ListData {
        var listData = self
        for (offset: sectionIndex, element: section) in self.enumerated() {
            for (itemIndex, item) in section.items.enumerated() {
                if item == item1 {
                    listData[sectionIndex].items[itemIndex] = item2
                }
                if item == item2 {
                    listData[sectionIndex].items[itemIndex] = item1
                }
            }
        }
        return listData
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
    public static func +=(lhs: inout ListData, rhs: (Section, [Item])) {
        lhs.append(Element(rhs.0, rhs.1))
    }
    public static func +=(lhs: inout ListData, rhs: Element) {
        lhs.append(rhs)
    }
}
extension ListData {
    public func compactMapToSectionModels() -> [SectionModelItem<Section, Item>] {
        compactMap(ListData.mapToSectionModel)
    }
    /// 转成(组, model)类型信号
    /// 将ListDataType转换为SectionModelType
    static func mapToSectionModel(_ element: ListData.Element) -> SectionModelItem<Section, Item>? {
        if let section = element.section as? HiddenStateDesignable, section.isHidden {
            return nil
        }
        let items = element.items.filter({ (item) -> Bool in
            if let item = item as? HiddenStateDesignable {
                return item.isHidden != true
            } else {
                return true
            }
        })
        if items.isEmpty {
            return nil
        }
        return SectionModelItem(element.section, items)
    }
}
