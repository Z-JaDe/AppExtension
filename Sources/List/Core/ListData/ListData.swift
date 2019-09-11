//
//  ListData.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public struct ListData<Section: Diffable, Item: Diffable & Equatable>: CollectionProtocol {
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
        }).filter({$0.1.isEmpty == false})
        return ListData(value)
    }

    public var itemCount: Int {
        return self.value.flatMap({$0.items}).count
    }
    public func exchange(_ item1: Item, _ item2: Item) -> ListData {
        var listData = self
        for (offset: sectionIndex, element: (section: _, items: items)) in self.enumerated() {
            for (itemIndex, item) in items.enumerated() {
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
extension ListData {
    public func compactMapToSectionModels() -> [SectionModelItem<Section, Item>] {
        return compactMap(ListData.mapToSectionModel)
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
        return SectionModelItem(element.0, items)
    }
}
