//
//  ListDataUpdateProtocol.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/11/13.--
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation

/// 更新数据源的协议
public protocol ListDataUpdateProtocol: class {
    associatedtype Section: Diffable
    associatedtype Item: Diffable
    typealias ListDataType = ListData<Section, Item>
    typealias ListUpdateInfoType = ListUpdateInfo<ListDataType>

    var dataArray: ListDataType {get}
    func changeListDataInfo(_ newData: ListUpdateInfoType)
}
extension ListDataUpdateProtocol {
    /// ZJaDe: 更新
    public func updateData() {
        self.reloadDataWithInfo({_ in nil})
    }
    /// ZJaDe: 重新刷新 返回 ListDataType
    public func reloadListData(_ closure: (ListDataType) -> ListDataType?) {
        self.reloadDataWithInfo({ (oldData) -> ListUpdateInfoType? in
            return closure(oldData).map(ListUpdateInfo.init)
        })
    }
    /// ZJaDe: 重新刷新 返回 ListUpdateInfoType
    public func reloadDataWithInfo(_ closure: (ListDataType) -> ListUpdateInfoType?) {
        if let newData = closure(self.dataArray) {
            self.changeListDataInfo(newData)
        }
    }
}
