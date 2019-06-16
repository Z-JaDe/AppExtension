//
//  SectionModelData.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/24.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import DifferenceKit

public typealias Diffable = Differentiable
public typealias DiffableSection = DifferentiableSection
public typealias SectionModelItem = ArraySection

public protocol SectionModelType: DiffableSection {
    associatedtype Section
    typealias Item = Collection.Element
    var section: Section {get}
    var items: [Item] {get}
    init(original: Self, items: [Item])
}

extension SectionModelItem: SectionModelType {
    public typealias Section = Model
    public var section: Section {
        return self.model
    }
    public var items: [Item] {
        return self.elements
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
