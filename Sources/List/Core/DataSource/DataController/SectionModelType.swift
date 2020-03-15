//
//  SectionModelItem.swift
//  List
//
//  Created by Apple on 2020/1/13.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

struct SectionModelSnapshot<Section, Item> {
    var model: Section
    var items: [Item]

    init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
}

public protocol SectionModelType: Hashable {
    associatedtype Section: Hashable
    associatedtype Item: Hashable, AdapterItemCompatible
    var section: Section {get}
    var items: [Item] {get}
    init(original: Self, items: [Item])
}

public struct SectionModelItem<Section: Hashable, Item: Hashable & AdapterItemCompatible>: SectionModelType {
    public var section: Section
    public var items: [Item]
    public init(_ section: Section, _ items: [Item]) {
        self.section = section
        self.items = items
    }
    public init(original: Self, items: [Item]) {
        self.init(original.section, items)
    }
}
