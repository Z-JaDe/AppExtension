//
//  TableViewController.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/17.
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
open class AdapterTableViewController: AdapterListViewController<TableView, UITableAdapter> {
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

    // MARK: -
    private lazy var tableHeaderSection: TableSection = TableSection()
    private lazy var tableFooterSection: TableSection = TableSection()
    private lazy var tableHeaderCell: CustomTableItemCell<UIView> = CustomTableItemCell()
    private lazy var tableFooterCell: CustomTableItemCell<UIView> = CustomTableItemCell()
    public var tableHeaderView: UIView? {
        get { self.tableHeaderCell.customView }
        set {
            self.tableHeaderCell.customView = newValue
            if self.adapter.dataArray.isEmpty == false {
                self.adapter.updateData()
            }
        }
    }
    public var tableFooterView: UIView? {
        get { self.tableFooterCell.customView }
        set {
            self.tableFooterCell.customView = newValue
            if self.adapter.dataArray.isEmpty == false {
                self.adapter.updateData()
            }
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        adapter.tableViewInit(self.rootView)
    }

    override func loadAdapter() -> UITableAdapter {
        let adapter = UITableAdapter()
        adapter.insertSecionModels.register(on: self, key: "defaultHeaderAndFooter") { (self, dataArray) in
            var dataArray = dataArray
            if self.tableHeaderView != nil {
                dataArray.insert((self.tableHeaderSection, [.cell(self.tableHeaderCell)]), at: 0)
            }
            if self.tableFooterView != nil {
                dataArray.append((self.tableFooterSection, [.cell(self.tableFooterCell)]))
            }
            return dataArray
        }
        return adapter
    }
}
