//
//  ListAdapter.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

open class ListAdapter<DataSource: SectionedDataSourceType>:
    ListAdapterType,
    EnabledStateDesignable,
    DisposeBagProtocol,
    MultipleSelectionProtocol
where DataSource.S.Item: AdapterItemType, DataSource.S.Section: AdapterSectionType {
    public typealias Section = DataSource.S.Section
    public typealias Item = DataSource.S.Item

    public init() {
        self.configInit()
    }
    public func configInit() {

    }
    deinit {
        logDebug("\(type(of: self))->\(self)注销")
    }
    /// ZJaDe: 缓存池
    let bufferPool: BufferPool = BufferPool()
    /// ZJaDe: 是否自动改回未选中，子类实现相关逻辑
    public var autoDeselectRow = true
    // MARK: - MultipleSelectionProtocol
    public typealias SelectItemType = Item
    open func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        jdAbstractMethod()
    }

    // MARK: - ListDataUpdateProtocol
    let listUpdateInfoSubject: ReplaySubject<ListUpdateInfoType> = ReplaySubject.create(bufferSize: 1)
    var lastListDataInfo: ListUpdateInfoType = ListUpdateInfo(data: [])
    // MARK: -
    public lazy var rxDataSource: DataSource = self.loadRxDataSource()
    func loadRxDataSource() -> DataSource {
        jdAbstractMethod()
    }
    // MARK: -
    open var isEnabled: Bool? {
        didSet {
            if let isEnabled = self.isEnabled, isEnabled != oldValue {
                updateEnabledState(isEnabled)
            }
        }
    }
    open func updateEnabledState(_ isEnabled: Bool) {

    }
}

extension ListAdapter: ListDataUpdateProtocol {
    public var dataArray: ListDataType {
        return self.lastListDataInfo.data
    }
    public func changeListDataInfo(_ newData: ListUpdateInfoType) {
        self.lastListDataInfo = newData
        self.listUpdateInfoSubject.onNext(newData)
    }
    /// 将dataArray转信号
    func dataArrayObservable() -> Observable<ListUpdateInfoType> {
        return self.listUpdateInfoSubject.asObservable()
            .delay(0.1, scheduler: MainScheduler.asyncInstance)
            .throttle(0.3, scheduler: MainScheduler.instance)
    }
}
