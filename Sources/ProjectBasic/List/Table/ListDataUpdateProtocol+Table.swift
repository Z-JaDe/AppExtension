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
    public func reloadData(_ closure: () -> ListData<Section, StaticTableItemCell>?) {
        self.reloadListData({ (_) -> ListDataType? in
            return closure()?.map({.cell($0)})
        })
    }
}
extension ListData where Item: StaticTableItemCell, Section == TableSection {
    public func updateInfo() -> TableListUpdateInfo {
        return self.map({.cell($0)}).updateInfo()
    }
}
