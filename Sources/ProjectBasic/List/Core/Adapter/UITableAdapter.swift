//
//  UITableAdapter.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/10.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension DelegateHooker: UITableViewDelegate {}
open class UITableAdapter: NSObject {
    private var _delegateHooker: DelegateHooker<UITableViewDelegate>?
    public weak private(set) var tableView: UITableView?
    public var dataSource: TableViewDataSource!

    public func tableViewInit(_ tableView: UITableView) {
        self.tableView = tableView

        dataSourceDefaultInit(tableView)
        tableView.delegate = _delegateHooker ?? tableProxy
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
extension UITableAdapter { // Hooker
    private var delegateHooker: DelegateHooker<UITableViewDelegate> {
        if let hooker = _delegateHooker {
            return hooker
        }
        let hooker = DelegateHooker<UITableViewDelegate>(defaultTarget: tableProxy)
        self.tableView?.delegate = hooker
        _delegateHooker = hooker
        return hooker
    }
    public func transformDelegate(_ target: UITableViewDelegate?) {
        delegateHooker.transform(to: target)
    }
    public func setAddDelegate(_ target: UITableViewDelegate?) {
        delegateHooker.addTarget = target
    }
    public var delegatePlugins: [UITableViewDelegate] {
        get { delegateHooker.plugins }
        set { delegateHooker.plugins = newValue }
    }
}
extension UITableViewDelegate {
    func addIn(_ adapter: UITableAdapter) -> Self {
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
        return self
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
