//
//  ListDataUpdateProtocol+Tablw.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension ListDataUpdateProtocol where Section: Equatable & InitProtocol, Item == AnyTableAdapterItem {
    /// ZJaDe: 重新刷新 返回 ListData
    public func reloadList(section: Section? = nil, _ itemArray: [TableItemModel]?, isRefresh: Bool, _ completion: (() -> Void)? = nil) {
        let _itemArray: [AnyTableAdapterItem] = itemArray?.map(AnyTableAdapterItem.model) ?? []
        var newData = self.dataArray
        if isRefresh {
            newData.reset(section: section, items: _itemArray)
        } else if _itemArray.isNotEmpty {
            newData.append(section: section, items: _itemArray)
        }
        self.reloadData(newData, completion)
    }
}

// MARK: -
extension ListDataUpdateProtocol where Item == AnyTableAdapterItem {
    /// ZJaDe: 重新刷新cell
    public func reloadData(_ listCellData: ListData<Section, StaticTableItemCell>?) {
        self.reloadData(listCellData?.map(AnyTableAdapterItem.cell))
    }
    /// ZJaDe: 重新刷新cell
    public func reloadData(_ listModelData: ListData<Section, TableItemModel>?) {
        self.reloadData(listModelData?.map(AnyTableAdapterItem.model))
    }
}

public extension ListBuilder where Item == AnyTableAdapterItem {
    static func buildBlock(_ content: _Component<StaticTableItemCell>...) -> Components {
        return Components(content.map(SectionData.init))
    }
    static func buildBlock(_ content: _Component<TableItemModel>...) -> Components {
        return Components(content.map(SectionData.init))
    }
}

extension SectionData where Item == AnyTableAdapterItem {
    public init<C: Swift.Collection>(_ section: Section, _ elements: C) where C.Element == StaticTableItemCell {
        self.init(section, elements.map(AnyTableAdapterItem.cell))
    }
    public init<C: Swift.Collection>(_ section: Section, _ elements: C) where C.Element == TableItemModel {
        self.init(section, elements.map(AnyTableAdapterItem.model))
    }
}
