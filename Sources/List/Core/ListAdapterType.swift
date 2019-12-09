//
//  ListAdapterType.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol CellSelectedStateDesignable {
    func didSelectItem()
}

public typealias DataSourceSectionType = Diffable & InitProtocol
public typealias DataSourceItemType = Diffable

public protocol AdapterItemType: DataSourceItemType & SelectedStateDesignable & Equatable {}
public protocol AdapterSectionType: DataSourceSectionType {}

public protocol ListAdapterType {
    associatedtype DataSource: SectionedDataSourceType
    typealias Section = DataSource.S.Section
    typealias Item = DataSource.S.Item
    var dataSource: DataSource { get }
}
extension ListAdapterType {
    public var dataController: DataSource.DataControllerType {
        dataSource.dataController
    }
}
extension ListAdapterType {
    public func setListHooker<T>(_ target: AnyObject?, _ hooker: inout DelegateHooker<T>?, _ newV: inout T?, _ defaultV: T) {
        if let target = target {
            if let hooker = newV as? DelegateHooker<T> {
                hooker.transform(to: target)
            } else {
                setHooker(target, &hooker, defaultV)
                newV = hooker as? T
            }
        } else {
            if let hooker = newV as? DelegateHooker<T> {
                newV = hooker.defaultTarget
            } else if newV == nil {
                newV = defaultV
            }
            hooker = nil
        }
    }
    public func setHooker<T>(_ target: AnyObject?, _ hooker: inout DelegateHooker<T>?, _ defaultV: T) {
        if let target = target {
            hooker = DelegateHooker(defaultTarget: defaultV)
            hooker?.transform(to: target)
        } else {
            hooker = nil
        }
    }
}
