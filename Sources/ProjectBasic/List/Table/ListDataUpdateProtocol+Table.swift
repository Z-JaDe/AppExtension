//
//  ListDataUpdateProtocol+Tablw.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension ListDataUpdateProtocol where Section: Equatable & InitProtocol, Item == AnyTableAdapterItem {
    /// ZJaDe: 重新刷新 返回 ListDataInfo
    public func reloadData(section: Section? = nil, _ itemArray: [TableItemModel]?, isRefresh: Bool, _ closure: ((_ListDataInfo) -> (_ListDataInfo))? = nil) {
        let _itemArray: [AnyTableAdapterItem] = itemArray?.map({.model($0)}) ?? []
        var newData = self.dataArray
        if isRefresh {
            newData.reset(section: section, items: _itemArray)
        } else if _itemArray.isNotEmpty {
            newData.append(section: section, items: _itemArray)
        }
        let result = newData.createListInfo(updating)
        self.reloadData(closure?(result) ?? result)
    }
}
extension ListData where Item: StaticTableItemCell, Section == TableSection {
    public func createListInfo(_ updating: Updating) -> TableListDataInfo {
        self.map({.cell($0)}).createListInfo(updating)
    }
}

// MARK: -
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
public extension ListBuilder where T == (TableSection, [AnyTableAdapterItem]) {
    static func buildBlock(_ content: (TableSection, [StaticTableItemCell])...) -> [T] {
        return content.map {($0.0, $0.1.map({.cell($0)}))}
    }
    static func buildBlock(_ content: (TableSection, [TableItemModel])...) -> [T] {
        return content.map {($0.0, $0.1.map({.model($0)}))}
    }
}

//
//extension SectionData where Item == AnyTableAdapterItem {
//    public init<C: Swift.Collection>(_ section: Section, _ elements: C) where C.Element == StaticTableItemCell {
//        self.init(section, elements.map {.cell($0)})
//    }
//    public init<C: Swift.Collection>(_ section: Section, _ elements: C) where C.Element == TableItemModel {
//        self.init(section, elements.map {.model($0)})
//    }
//}
