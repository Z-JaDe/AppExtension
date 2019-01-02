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

#if canImport(RxSwift)
typealias MultipleSelection = RxMultipleSelectionProtocol
#else
typealias MultipleSelection = MultipleSelectionProtocol
#endif

open class ListAdapter<DataSourceType: SectionedDataSourceType>:
    ListAdapterType,
    EnabledStateDesignable,
    DisposeBagProtocol,
    MultipleSelection
where DataSourceType.S.Item: AdapterItemType, DataSourceType.S.Section: AdapterSectionType {
    public typealias DataSource = DataSourceType
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
    /// ZJaDe: 是否自动改回未选中
    open var autoDeselectRow = true
    // MARK: - MultipleSelectionProtocol
    public typealias SelectItemType = Item
    public var selectedItemArray: [SelectItemType] = []
    #if canImport(RxSwift)
    public let selectedItemArraySubject: PublishSubject<SelectedItemArrayType> = PublishSubject()
    #endif
    public var maxSelectedCount: UInt? = 0
    public var checkCanSelectedClosure: ((SelectItemType, @escaping (Bool) -> Void) -> Void)?
    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
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
extension ListAdapter {
    public func model(at indexPath: IndexPath) throws -> Item {
        return try self.dataController.model(at: indexPath) as! Item
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
