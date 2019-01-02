//
//  DataController.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

struct SectionModelSnapshot<Section, Item: Diffable> {
    var model: Section
    var items: [Item]

    init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
}
public final class DataController<S: SectionModelType> {
    public typealias I = S.Item
    typealias DataSnapshot = SectionModelSnapshot<S, I>
    internal var _data: [DataSnapshot] = []

    internal var dataSet = false
    public let reloadDataCompletion: ReplaySubject<Void> = ReplaySubject.create(bufferSize: 1)


    func move(_ source: IndexPath, target: IndexPath) {
        let sourceSection: S = self[source.section]
        var sourceItems: [I] = sourceSection.items

        let sourceItem: I = sourceItems.remove(at: source.item)

        self._data[source.section] = DataSnapshot(model: sourceSection, items: sourceItems)

        let destinationSection: S = self[target.section]
        var destinationItems: [I] = destinationSection.items
        destinationItems.insert(sourceItem, at: target.item)

        self._data[target.section] = DataSnapshot(model: destinationSection, items: destinationItems)
    }
}
extension DataController {
    public var sectionModels: [S] {
        return _data.lazy.map { S(original: $0.model, items: $0.items) }
    }
    public func setSections(_ sections: [S]) {
        self._data = sections.map { DataSnapshot(model: $0, items: $0.items) }
    }
}
extension DataController: SectionedViewDataSourceType {
    public subscript(section: Int) -> S {
        let data = self._data[section]
        return S(original: data.model, items: data.items)
    }
    public subscript(indexPath: IndexPath) -> I {
        get { return self._data[indexPath.section].items[indexPath.item] }
        set(item) {
            var section = self._data[indexPath.section]
            section.items[indexPath.item] = item
            self._data[indexPath.section] = section
        }
    }
    public func model(at indexPath: IndexPath) throws -> Any {
        guard sectionIndexCanBound(indexPath.section) else {
            throw NSError(domain: "分区下标越界", code: 0, userInfo: nil)
        }
        guard indexPathCanBound(indexPath) else {
            throw NSError(domain: "下标越界", code: 0, userInfo: nil)
        }
        return self[indexPath]
    }
}
extension DataController {
    public func sectionIndexCanBound(_ sectionIndex: Int) -> Bool {
        return _data.indexCanBound(sectionIndex)
    }
    public func indexPathCanBound(_ indexpath: IndexPath) -> Bool {
        guard _data.indexCanBound(indexpath.section) else {
            return false
        }
        guard _data[indexpath.section].items.indexCanBound(indexpath.row) else {
            return false
        }
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
