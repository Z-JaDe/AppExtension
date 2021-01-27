//
//  SectionData.swift
//  AppExtension
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public struct SectionData<Section, Item> {
    public let section: Section
    public internal(set) var items: [Item]
    public init<C: Swift.Collection>(_ section: Section, _ elements: C) where C.Element == Item {
        self.section = section
        self.items = Array(elements)
    }
    public func map<U>(_ transform: (Item) throws -> U) rethrows -> SectionData<Section, U> {
        SectionData<Section, U>(self.section, try self.items.map(transform))
    }
    public func filter(_ transform: (Item) throws -> Bool) rethrows -> SectionData {
        SectionData(self.section, try self.items.filter(transform))
    }
}
