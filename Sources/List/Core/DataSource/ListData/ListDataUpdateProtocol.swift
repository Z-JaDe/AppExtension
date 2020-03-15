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
    associatedtype Section
    associatedtype Item
    typealias _ListData = ListData<Section, Item>
    typealias _SectionData = _ListData.Element

    var dataArray: _ListData {get}
    func changeListData(_ newData: _ListData, _ completion: (() -> Void)?)
    func setNextUpdateMode(_ updateMode: UpdateMode)
}

extension ListDataUpdateProtocol {
    /// ZJaDe: 更新
    public func updateData() {
        self.reloadData(self.dataArray)
    }
    public func updateData(_ closure: (_ListData) -> _ListData) {
        self.reloadData(closure(dataArray))
    }
    /// ZJaDe: 重新刷新 传入 listData
    public func reloadData(_ listData: _ListData?, _ completion: (() -> Void)? = nil) {
        if let listData = listData {
            self.changeListData(listData, completion)
        }
    }
}
extension ListDataUpdateProtocol where Section: Equatable & InitProtocol {
    /// ZJaDe: 重新刷新 返回 ListData
    public func reloadList(section: Section? = nil, _ itemArray: [Item]?, isRefresh: Bool, _ completion: (() -> Void)? = nil) {
        let _itemArray = itemArray ?? []
        var newData = self.dataArray
        if isRefresh {
            newData.reset(section: section, items: _itemArray)
        } else if _itemArray.isEmpty == false {
            newData.append(section: section, items: _itemArray)
        }
        self.setNextUpdateMode(.everything)
        self.reloadData(newData, completion)
    }
}
