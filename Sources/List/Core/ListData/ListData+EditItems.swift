//
//  ListDataUpdateProtocol+EditItems.swift
//  List
//
//  Created by 郑军铎 on 2018/6/8.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

private enum ListDataUpdateEditType {
    case reset
    case append
    case insert(Int)
}
extension ListData where Section: Equatable & InitProtocol {
    public mutating func reset(section: Section? = nil, items: [Item]) {
        self = reseting(section: section, items: items)
    }
    public mutating func append(section: Section? = nil, items: [Item]) {
        self = appending(section: section, items: items)
    }
    public mutating func insert(section: Section? = nil, items: [Item], at index: Int) {
        self = inserting(section: section, items: items, at: index)
    }
    // MARK: -
    public func reseting(section: Section? = nil, items: [Item]) -> ListData {
        return edit(.reset, section, items)
    }
    public func appending(section: Section? = nil, items: [Item]) -> ListData {
        return edit(.append, section, items)
    }
    public func inserting(section: Section? = nil, items: [Item], at index: Int) -> ListData {
        return edit(.insert(index), section, items)
    }
    // MARK: -
    private func edit(_ editType: ListDataUpdateEditType, _ section: Section?, _ items: [Item]) -> ListData {
        var newData = self
        var sectionIndex: Int?
        let section: Section = section ?? newData.last?.section ?? Section()
        var newItems: [Item]
        if let index = newData.index(where: {$0.section == section}) {
            newItems = newData[index].items
            sectionIndex = index
        } else {
            newItems = [Item]()
        }
        // ZJaDe:
        switch editType {
        case .reset:
            newItems = items
        case .append:
            newItems += items
        case .insert(let index):
            newItems.insert(contentsOf: items, at: index)
        }
        if let sectionIndex = sectionIndex {
            newData[sectionIndex] = (section, newItems)
        } else {
            newData.append((section, newItems))
        }
        return newData
    }
}
extension ListData where Item: Equatable {
    public mutating func delete(items: [Item]) {
        self = deleteing(items: items)
    }
    public func deleteing(items: [Item]) -> ListData {
        return self.filter({!items.contains($0)})
    }
}
