//
//  ListAdapter.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

//下面两个协议，是为了内部 检测 是否实现了对应的协议。AdapterItemType后面都是可选协议，实现了就能用，不实现也不报错
public protocol _AdapterItemType: AdapterItemType & SelectedStateDesignable & HiddenStateDesignable & EnabledStateDesignable {}
public protocol _AdapterSectionType: AdapterSectionType {}

open class ListAdapter<DataSource: SectionedDataSourceType>
where DataSource.S.Item: AdapterItemType, DataSource.S.Section: AdapterSectionType {
    public typealias DataSource = DataSource
    public typealias Section = DataSource.S.Section
    public typealias Item = DataSource.S.Item
    public typealias _ListData = ListData<Section, Item>
    public init() {
        self.configInit()
    }
    public func configInit() {

    }
    deinit {
        logDebug("\(type(of: self))->\(self)注销")
    }
    /// ZJaDe: 是否自动改回未选中，子类实现相关逻辑
    public var autoDeselectRow = true

    var dataInfo: ListData<Section, Item>?
    public var dataSource: DataSource = DataSource() {
        didSet { dataSourceDefaultInit(dataSource) }
    }
    open func dataSourceDefaultInit(_ dataSource: DataSource) {
        dataSource.didMoveItem = { [weak self] (source, destination) in
            guard let self = self else { return }
            self.dataInfo = self.dataInfo?.move(source, destination)
        }
    }
    internal func dataChanged(_ completion: (() -> Void)?) {
    }
}
extension ListAdapter: DisposeBagProtocol {}
extension ListAdapter: ListAdapterType {
    public var dataArray: ListData<Section, Item> {
        self.dataInfo ?? .init()
    }
    public func changeListData(_ newData: _ListData, _ completion: (() -> Void)? = nil) {
        self.dataInfo = newData
        dataChanged(completion)
    }
}
