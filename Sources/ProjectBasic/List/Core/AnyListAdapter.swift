//
//  AnyAdapterItem.swift
//  ProjectBasic
//
//  Created by ZJaDe on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

// MARK: -

public struct AnyAdapterSection: Hashable {
    public typealias Element = Hashable & AnyObject
    public let value: AnyHashable
    init<V: Hashable>(_ value: V) {
        self.value = AnyHashable(value)
    }
    var anyBase: AnyObject {
        self.value.base as AnyObject
    }
}
public protocol AnyTableAdapterCompatible {
    var anyBase: AnyObject { get }
}
public struct AnyTableAdapterItem: Hashable, AnyTableAdapterCompatible {
    public typealias Element = Hashable & AnyObject & TableCellOfLife
    private let value: AnyHashable
    public init<V: Element>(_ value: V) {
        self.value = AnyHashable(value)
    }
    var base: TableCellOfLife {
        // swiftlint:disable force_cast
        self.value.base as! TableCellOfLife
    }
    public var anyBase: AnyObject {
        self.value.base as AnyObject
    }
}
public struct AnyCollectionAdapterItem: Hashable, AnyTableAdapterCompatible {
    public typealias Element = Hashable & AnyObject & CollectionCellOfLife
    private let value: AnyHashable
    public init<V: Element>(_ value: V) {
        self.value = AnyHashable(value)
    }
    var base: CollectionCellOfLife {
        // swiftlint:disable force_cast
        self.value.base as! CollectionCellOfLife
    }
    public var anyBase: AnyObject {
        self.value.base as AnyObject
    }
}

public protocol ListViewDataSource: AnyObject {
    associatedtype Section
    associatedtype Item: AnyTableAdapterCompatible
    func item(for indexPath: IndexPath) -> Item?
    func indexPath(for item: Item) -> IndexPath?
}
extension ListViewDataSource {
    public func checkIsSelected(_ indexPath: IndexPath) -> Bool? {
        guard let item = item(for: indexPath) else { return nil }
        if let item = item.anyBase as? SelectedStateDesignable {
            return item.isSelected
        }
        return nil
    }
}
