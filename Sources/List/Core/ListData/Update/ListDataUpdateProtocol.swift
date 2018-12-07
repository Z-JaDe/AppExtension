//
//  ListDataUpdateProtocol.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/11/13.--
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// 更新数据源的协议
public protocol ListDataUpdateProtocol: class {
    associatedtype Section: Diffable
    associatedtype Item: Diffable
    typealias ListDataType = ListData<Section, Item>
    typealias ListUpdateInfoType = ListUpdateInfo<ListDataType>

    var listUpdateInfoSubject: ReplaySubject<ListUpdateInfoType> {get}
    var lastListDataInfo: ListUpdateInfoType {get set}
}
extension ListDataUpdateProtocol {
    public var dataArray: ListDataType {
        return self.lastListDataInfo.data
    }
}
extension ListDataUpdateProtocol {
    /// ZJaDe: 更新
    public func updateData() {
        self.reloadDataWithInfo({_ in nil})
    }
    /// ZJaDe: 重新刷新 返回 ListDataType
    public func reloadListData(_ closure: (ListDataType) -> ListDataType?) {
        self.reloadDataWithInfo({ (oldData) -> ListUpdateInfo<ListDataType>? in
            return closure(oldData).map(ListUpdateInfo.init)
        })
    }
    /// ZJaDe: 重新刷新 返回 ListUpdateInfo<ListDataType>
    public func reloadDataWithInfo(_ closure: (ListDataType) -> ListUpdateInfo<ListDataType>?) {
        if let newData = closure(self.dataArray) {
            self.lastListDataInfo = newData
        }
    }
    /// 将dataArray转信号
    public func dataArrayObservable() -> Observable<ListUpdateInfoType> {
        return self.listUpdateInfoSubject.asObservable()
            .delay(0.1, scheduler: MainScheduler.asyncInstance)
            .throttle(0.3, scheduler: MainScheduler.instance)
    }
}

extension ListDataUpdateProtocol where Item == TableAdapterItemCompatible {
    /// ZJaDe: 重新刷新cell
    public func reloadData(_ closure: () -> ListData<Section, StaticTableItemCell>?) {
        self.reloadListData({ (_) -> ListDataType? in
            return closure()?.map({.cell($0)})
        })
    }

}
