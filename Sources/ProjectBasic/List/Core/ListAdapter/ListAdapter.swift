//
//  ListAdapter.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//下面两个协议，是为了内部 检测 是否实现了对应的协议。AdapterItemType后面都是可选协议，实现了就能用，不实现也不报错
public protocol _AdapterItemType: AdapterItemType & CanSelectedStateDesignable & HiddenStateDesignable & EnabledStateDesignable {}
public protocol _AdapterSectionType: AdapterSectionType {}

open class ListAdapter<DataSource: SectionedDataSourceType>: ListAdapterType
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

    // MARK: -
    let dataInfoSubject: ReplaySubject<ListDataInfoType> = ReplaySubject.create(bufferSize: 1)
    var dataInfo: ListDataInfoType?
    // MARK: -
    var _rxDataSource: DataSource?
    ///子类重写
    public var rxDataSource: DataSource {
        _rxDataSource!
    }
    open func bindingDataSource(_ dataSource: DataSource) {
        self._rxDataSource = dataSource
    }
    // MARK: -
    open var isEnabled: Bool? {
        didSet {
            if let isEnabled = self.isEnabled, isEnabled != oldValue {
                (self as? EnabledStateDesignable)?.updateEnabledState(isEnabled)
            }
        }
    }
}
extension ListAdapter: DisposeBagProtocol {}
extension ListAdapter: ListDataUpdateProtocol {
    public var dataArray: ListDataType {
        self.dataInfo?.data ?? .init()
    }
    public func changeListDataInfo(_ newData: ListDataInfoType) {
        self.dataInfo = newData
        self.dataInfoSubject.onNext(newData)
    }
    /// 将dataArray转信号
    func dataArrayObservable() -> Observable<ListDataInfoType> {
        self.dataInfoSubject.asObservable()
            .delay(.milliseconds(100), scheduler: MainScheduler.asyncInstance)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
    }
}
