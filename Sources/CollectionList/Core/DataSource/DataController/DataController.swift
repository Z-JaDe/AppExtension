//
//  DataController.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public final class DataController<S: SectionModelType> {
    public init() {}
    public typealias I = S.Item
    typealias DataSnapshot = SectionModelSnapshot<S, I>
    internal var _data: [DataSnapshot] = []

    public var reloadDataCompletion: CallBackerNoParams = CallBackerNoParams()

    func move(_ source: IndexPath, target: IndexPath) {
        let sourceItem: I = self._data[source.section].items.remove(at: source.item)
        self._data[target.section].items.insert(sourceItem, at: target.item)
    }
}
extension DataController {
    public var sectionModels: [S] {
        _data.lazy.map { S(original: $0.model, items: $0.items) }
    }
    public func setSections(_ sections: [S]) {
        self._data = sections.map { DataSnapshot(model: $0, items: $0.items) }
    }
}
extension DataController {
    public subscript(section: Int) -> S {
        let data = self._data[section]
        return S(original: data.model, items: data.items)
    }
    public subscript(indexPath: IndexPath) -> I {
        get { self._data[indexPath.section].items[indexPath.item] }
        set(item) {
            var section = self._data[indexPath.section]
            section.items[indexPath.item] = item
            self._data[indexPath.section] = section
        }
    }
}
extension DataController {
    public func sectionIndexCanBound(_ sectionIndex: Int) -> Bool {
        _data.indexCanBound(sectionIndex)
    }
    public func indexPathCanBound(_ indexpath: IndexPath) -> Bool {
        guard _data.indexCanBound(indexpath.section) else { return false }
        guard _data[indexpath.section].items.indexCanBound(indexpath.row) else { return false }
        return true
    }
}
extension DataController where S.Item: Equatable {
    public func indexPath(with item: I) -> IndexPath? {
        for (section, sectionModel) in self._data.enumerated() {
            if let indexPath = sectionModel.items.enumerated().first(where: {$0.element == item}).map({IndexPath(row: $0.offset, section: section)}) {
                return indexPath
            }
        }
        return nil
    }
}
// MARK: -
extension DataController {
    public func checkIsSelected(_ indexPath: IndexPath) -> Bool? {
        guard indexPathCanBound(indexPath) else { return nil }
        let item = self[indexPath]
        if let _item = item.realItem as? SelectedStateDesignable {
            return _item.isSelected
        }
        return nil
    }
}
