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
        let tableView = TableView(frame: frame, style: self.style)
        if self.style == .grouped && tableView.tableHeaderView == nil {
            let view = UIView()
            view.height = 1
            tableView.tableHeaderView = view
        }
        return tableView
    }
}
open class AdapterTableViewController: ListViewController<TableView> {
    // MARK: - RefreshListProtocol
    open var networkPage: Int = 0
    /// 默认值若有变化 子类可重写
    open var limit: UInt? = 20

    public lazy private(set) var adapter: UITableAdapter = self.loadAdapter()
    func loadAdapter() -> UITableAdapter {
        UITableAdapter()
    }

    /// ZJaDe: view加载之前设置有效
    public var style: UITableView.Style = .plain

    open override func createView(_ frame: CGRect) -> TableView {
        let tableView = TableView(frame: frame, style: self.style)
        if self.style == .grouped && tableView.tableHeaderView == nil {
            let view = UIView()
            view.height = 1
            tableView.tableHeaderView = view
        }
        return tableView
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        adapterViewInit()
    }

    func adapterViewInit() {
        if self.adapter.tableView == nil {
            adapter.tableViewInit(self.rootView)
        }
    }
}
extension AdapterTableViewController: RefreshListProtocol {
    public var parser: ResultParser<AdapterTableViewController> {
        ResultParser(self) { [weak self] in
            self?.adapter.dataSource.snapshot().numberOfItems ?? 0
        }
    }
}
