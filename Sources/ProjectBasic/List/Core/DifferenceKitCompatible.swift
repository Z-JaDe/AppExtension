//
//  DifferenceKitCompatible.swift
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

extension SectionModelItem: SectionModelType where Element: AdapterItemCompatible {
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

// MARK: -
extension CollectionItemModel: Diffable {}
extension CollectionSection: Diffable {}
extension AnyTableAdapterItem: Diffable {}
extension TableSection: Diffable {}
// MARK: -
extension ListData where Section: Diffable, Item: Diffable & AdapterItemCompatible {
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
            if let item = item.realItem as? HiddenStateDesignable {
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
