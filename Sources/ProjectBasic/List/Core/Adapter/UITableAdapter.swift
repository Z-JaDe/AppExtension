//
//  UITableAdapter.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/10.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class UITableAdapter: NSObject {
    public weak private(set) var tableView: UITableView?
    public var dataSource: TableViewDataSource!

    func tableViewInit(_ tableView: UITableView) {
        self.tableView = tableView

        dataSourceDefaultInit(tableView)
        tableView.dataSource = dataSource
    }
    /// ZJaDe: 设置自定义的代理时，需要注意尽量使用UITableProxy或者它的子类，这样会自动实现一些默认配置
    public lazy var tableProxy: UITableProxy = UITableProxy(self)
    open func dataSourceDefaultInit(_ tableView: UITableView) {
        dataSource = TableViewDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            item.createCell(in: tableView, for: indexPath)
        })
    }
}

extension AnyTableAdapterItem {
    fileprivate func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        if let _item = self.base as? TableCellHeightProtocol {
            if _item.cellHeightLayoutType.isNeedLayout {
                _item.calculateCellHeight(tableView, wait: true)
            }
        }
        return self.base.createCell(in: tableView, for: indexPath)
    }
}
