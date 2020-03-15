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
    // MARK: -
    /// 刷新器，局部刷新 完全刷新 如果为nil则使用默认的
    public var updater: Updater?
    /// UI刷新，一般不会变动 如果为nil则使用默认的
    public var updating: Updating?
    var tempUpdateMode: UpdateMode?
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
    ///设置下次刷新是否 reloadData
    public func setNextUpdateMode(_ updateMode: UpdateMode) {
        tempUpdateMode = updateMode
    }
}
extension ListData where Section: Hashable, Item: Hashable & AdapterItemCompatible {
    public func compactMapToSectionModels() -> [SectionModelItem<Section, Item>] {
        compactMap(ListData.mapToSectionModel)
    }
    /// 转成(组, model)类型信号
    /// 将ListDataType转换为SectionModelType
    static func mapToSectionModel(_ element: ListData.Element) -> SectionModelItem<Section, Item>? {
        if let section = element.section as? HiddenStateDesignable, section.isHidden {
            return nil
        }
        let items = element.items.filter({ (item) -> Bool in
            if let item = item.realItem as? HiddenStateDesignable {
                return item.isHidden != true
            } else {
                return true
            }
        })
        if items.isEmpty {
            return nil
        }
        return SectionModelItem(element.section, items)
    }
}
