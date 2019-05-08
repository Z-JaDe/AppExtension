//
//  ListDataUpdateProtocol+Tablw.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension ListDataUpdateProtocol where Item == AnyTableAdapterItem {
    /// ZJaDe: 重新刷新cell
    public func reloadData(_ listCellData: ListData<Section, StaticTableItemCell>?) {
        self.reloadData(listCellData?.map({.cell($0)}))
    }
    /// ZJaDe: 重新刷新cell
    public func reloadData(_ listModelData: ListData<Section, TableItemModel>?) {
        self.reloadData(listModelData?.map({.model($0)}))
    }
}
extension ListDataUpdateProtocol where Section: Equatable & InitProtocol, Item == AnyTableAdapterItem {
    /// ZJaDe: 重新刷新 返回 ListUpdateInfoType
    public func reloadData(section: Section? = nil, _ itemArray: [TableItemModel]?, isRefresh: Bool, _ closure: ((ListUpdateInfo<ListDataType>) -> (ListUpdateInfo<ListDataType>))? = nil) {
        let _itemArray: [AnyTableAdapterItem] = itemArray?.map({.model($0)}) ?? []
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
extension ListData where Item: StaticTableItemCell, Section == TableSection {
    public func updateInfo() -> TableListUpdateInfo {
        return self.map({.cell($0)}).updateInfo()
    }
}


// MARK: - Deprecated
extension ListDataUpdateProtocol where Item == AnyTableAdapterItem {
    @available(*, deprecated, message: "请使用reloadData(listCellData:ListData)")
    public func reloadData(_ closure: () -> ListData<Section, StaticTableItemCell>?) {
        self.reloadData(closure())
    }
}
