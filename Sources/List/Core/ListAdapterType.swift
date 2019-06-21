//
//  ListAdapterType.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol DataSourceSectiontype: Diffable {}
public protocol DataSourceItemtype: Diffable, Equatable {}
public protocol AdapterItemType: DataSourceItemtype & SelectedStateDesignable {}
public protocol AdapterSectionType: DataSourceSectiontype & InitProtocol & HiddenStateDesignable {}

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
extension ListAdapterType {
    public func model(at indexPath: IndexPath) throws -> Item {
        // swiftlint:disable force_cast
        return try self.dataController.model(at: indexPath) as! Item
    }
}
