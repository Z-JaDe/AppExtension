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
        self.reloadData(self.dataArray)
    }
    /// ZJaDe: 重新刷新 传入 listData
    public func reloadData(_ listData: ListDataType?) {
        self.reloadData(listData?.updateInfo())
    }
    /// ZJaDe: 重新刷新 传入 listUpdateInfo
    public func reloadData(_ listUpdateInfo: ListUpdateInfoType?) {
        if let listUpdateInfo = listUpdateInfo {
            self.changeListDataInfo(listUpdateInfo)
        }
    }
}
extension ListDataUpdateProtocol where Section: Equatable & InitProtocol {
    // TODO: Async/Await 出来后需优化
    /// ZJaDe: 重新刷新 返回 ListUpdateInfoType
    public func reloadData(section: Section? = nil, _ itemArray: [Item]?, isRefresh: Bool, _ closure: ((ListUpdateInfo<ListDataType>) -> (ListUpdateInfo<ListDataType>))? = nil) {
        let _itemArray = itemArray ?? []
        var newData = self.dataArray
        if isRefresh {
            newData.reset(section: section, items: _itemArray)
        } else if _itemArray.count > 0 {
            newData.append(section: section, items: _itemArray)
        }
        let result = newData.updateInfo()
        self.reloadData(closure?(result) ?? result)
    }
}
// MARK: - Deprecated
extension ListDataUpdateProtocol {
    @available(*, deprecated, message: "请使用reloadData")
    public func reloadDataWithInfo(_ closure: (ListDataType) -> ListUpdateInfoType?) {
        self.reloadData(closure(self.dataArray))
    }
    @available(*, deprecated, message: "请使用reloadData")
    public func reloadDataWithInfo(_ closure: (ListDataType) -> ListDataType?) {
        self.reloadData(closure(self.dataArray))
    }
}
