//
//  TableViewController.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
open class NormalTableViewController: ListViewController<TableView> {
    /// ZJaDe: view加载之前设置有效
    public var style: UITableView.Style = .plain

    open override func createView(_ frame: CGRect) -> TableView {
        TableView(frame: frame, style: self.style)
    }
}
open class AdapterTableViewController: ListViewController<TableView> {
    // MARK: - RefreshListProtocol
    open var networkPage: Int = 0
    /// 默认值若有变化 子类可重写
    open var limit: UInt? = 20

    public private(set) lazy var dataSource: TableViewDataSource = TableViewDataSource(tableView: self.rootView)
    public private(set) lazy var listProxy: UITableProxy = UITableProxy(dataSource)

    /// ZJaDe: view加载之前设置有效
    public var style: UITableView.Style = .plain
    open override func createView(_ frame: CGRect) -> TableView {
        TableView(frame: frame, style: self.style)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.dataSource = self.dataSource
        self.rootView.delegate = self.listProxy
    }
}
extension AdapterTableViewController: RefreshListProtocol {
    public var parser: ResultParser<AdapterTableViewController> {
        ResultParser(self) { [weak self] in
            self?.dataSource.snapshot().numberOfItems ?? 0
        }
    }
}
