//
//  ListAdapterType.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol CellSelectedStateDesignable {
    func didSelectItem()
}

public protocol DataSourceSectionType: Diffable, InitProtocol {}
public protocol DataSourceItemType: Diffable, Equatable {}

public protocol AdapterItemType: DataSourceItemType & CellSelectedStateDesignable & SelectedStateDesignable {}
public protocol AdapterSectionType: DataSourceSectionType & HiddenStateDesignable {}

public protocol ListAdapterType {
    associatedtype DataSource: SectionedDataSourceType
    typealias Section = DataSource.S.Section
    typealias Item = DataSource.S.Item
    var rxDataSource: DataSource { get }
}
extension ListAdapterType {
    public var dataController: DataSource.DataControllerType {
        return rxDataSource.dataController
    }
}
