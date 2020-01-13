//
//  SectionModelData.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/8/24.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import DifferenceKit

public typealias Diffable = Differentiable
public typealias DiffableSection = DifferentiableSection
public typealias SectionModelItem = ArraySection

extension SectionModelItem: SectionModelType {
    public typealias Section = Model
    public var section: Section {
        self.model
    }
    public var items: [Element] {
        self.elements
    }
    init(_ section: Model, _ items: [Element]) {
        self.init(model: section, elements: items)
    }
    public init(original: SectionModelItem<Model, Element>, items: [Element]) {
        self.init(source: original, elements: items)
    }
}
extension SectionModelItem {
    var nilIfHidden: SectionModelItem<Model, Item>? {
        if let section = self.section as? HiddenStateDesignable, section.isHidden {
            return nil
        }
        let items = self.items.filter({ (item) -> Bool in
            if let item = item as? HiddenStateDesignable {
                return item.isHidden != true
            } else {
                return true
            }
        })
        if items.isEmpty {
            return nil
        }
        return SectionModelItem(section, items)
    }
}

extension ListData where Section: Diffable, Item: Diffable {
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

extension SectionedDataSource where S: DiffableSection {
    public func dataChange(_ newValue: Element, _ updater: Updater) {
        #if DEBUG
        self._dataSourceBound = true
        #endif
        self.dataController.updateNewData(newValue, updater)
    }
}
extension DataController where S: DiffableSection {
    func updateNewData(_ newData: ListDataInfo<[S]>, _ updater: Updater) {
        updater.update(
            using: StagedChangeset<[S]>(source: self.sectionModels, target: newData.data),
            dataSetter: Updater.DataSetter(updating: newData.updating, interrupt: {$0.data.count > 100}, setData: setSections, completion: { (_) in
                newData._performCompletion()
                newData._infoRelease()
                self.reloadDataCompletion.call()
            })
        )
    }
}
