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
    associatedtype Item: Diffable & Equatable
    typealias _ListData = ListData<Section, Item>
    typealias _ListDataInfo = ListDataInfo<_ListData>

    var dataArray: _ListData {get}
    var updating: Updating {get}
    func changeListDataInfo(_ newData: _ListDataInfo)
}
extension ListDataUpdateProtocol {
    public func createListInfo(_ newData: _ListData) -> _ListDataInfo {
        _ListDataInfo(data: newData, updating: updating)
    }
}
extension ListDataUpdateProtocol {
    /// ZJaDe: 更新
    public func updateData() {
        self.reloadData(self.dataArray)
    }
    /// ZJaDe: 重新刷新 传入 listData
    public func reloadData(_ listData: _ListData?) {
        self.reloadData(listData?.createListInfo(updating))
    }
    /// ZJaDe: 重新刷新 传入 listDataInfo
    public func reloadData(_ listDataInfo: _ListDataInfo?) {
        if let listDataInfo = listDataInfo {
            self.changeListDataInfo(listDataInfo)
        }
    }
    public func reloadData(_ closure: (_ListDataInfo) -> _ListDataInfo) {
        self.reloadData(closure(createListInfo(dataArray)))
    }
}
extension ListDataUpdateProtocol where Section: Equatable & InitProtocol {
    // TODO: Async/Await 出来后需优化
    /// ZJaDe: 重新刷新 返回 ListDataInfo
    public func reloadData(section: Section? = nil, _ itemArray: [Item]?, isRefresh: Bool, _ closure: ((_ListDataInfo) -> (_ListDataInfo))? = nil) {
        let _itemArray = itemArray ?? []
        var newData = self.dataArray
        if isRefresh {
            newData.reset(section: section, items: _itemArray)
        } else if _itemArray.isEmpty == false {
            newData.append(section: section, items: _itemArray)
        }
        let result = newData.createListInfo(updating)
        self.reloadData(closure?(result) ?? result)
    }
}
