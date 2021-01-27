//
//  ListAdapterType.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/29.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol AdapterSectionType: InitProtocol {}
public protocol AdapterItemType: AdapterItemCompatible & Equatable {}

public protocol ListAdapterType: class where Section: AdapterSectionType, Item: AdapterItemType {
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
