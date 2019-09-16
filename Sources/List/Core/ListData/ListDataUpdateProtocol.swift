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
    typealias ListDataType = ListData<Section, Item>
    typealias ListDataInfoType = ListDataInfo<ListDataType>

    var dataArray: ListDataType {get}
    func changeListDataInfo(_ newData: ListDataInfoType)
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
    /// ZJaDe: 重新刷新 传入 listDataInfo
    public func reloadData(_ listDataInfo: ListDataInfoType?) {
        if let listDataInfo = listDataInfo {
            self.changeListDataInfo(listDataInfo)
        }
    }
}
extension ListDataUpdateProtocol where Section: Equatable & InitProtocol {
    // TODO: Async/Await 出来后需优化
    /// ZJaDe: 重新刷新 返回 ListDataInfoType
    public func reloadData(section: Section? = nil, _ itemArray: [Item]?, isRefresh: Bool, _ closure: ((ListDataInfo<ListDataType>) -> (ListDataInfo<ListDataType>))? = nil) {
        let _itemArray = itemArray ?? []
        var newData = self.dataArray
        if isRefresh {
            newData.reset(section: section, items: _itemArray)
        } else if _itemArray.isEmpty == false {
            newData.append(section: section, items: _itemArray)
        }
        let result = newData.updateInfo()
        self.reloadData(closure?(result) ?? result)
    }
}
