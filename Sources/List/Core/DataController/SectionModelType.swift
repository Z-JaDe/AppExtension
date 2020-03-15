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

public protocol SectionModelType {
    associatedtype Section
    associatedtype Item: AdapterItemCompatible
    var section: Section {get}
    var items: [Item] {get}
    init(original: Self, items: [Item])
}
