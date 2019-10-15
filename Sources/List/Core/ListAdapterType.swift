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
    var rxDataSource: DataSource { get }
}
extension ListAdapterType {
    public var dataController: DataSource.DataControllerType {
        rxDataSource.dataController
    }
}
