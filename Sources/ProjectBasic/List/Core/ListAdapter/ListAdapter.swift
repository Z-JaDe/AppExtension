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
    ListDataUpdateProtocol,
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

    // MARK: -
    public let listUpdateInfoSubject: ReplaySubject<ListUpdateInfoType> = ReplaySubject.create(bufferSize: 1)
    public var lastListDataInfo: ListUpdateInfoType = ListUpdateInfo(data: []) {
        didSet { self.listUpdateInfoSubject.onNext(self.lastListDataInfo) }
    }
    open func model(at indexPath: IndexPath) throws -> Item {
        return self.rxDataSource.dataController[indexPath]
    }
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
