//
//  TableViewController.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class TableViewController: ListViewController<TableView, UITableAdapter> {
    /// ZJaDe: view加载之前调用有效
    public var style: UITableView.Style = .plain

    override func createView(_ frame: CGRect) -> TableView {
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
    private lazy var tableHeaderCell: CustomTableItemCell<UIView> = {
        let view = CustomTableItemCell()
        return view
    }()
    private lazy var tableFooterCell: CustomTableItemCell<UIView> = {
        let view = CustomTableItemCell()
        return view
    }()
    public var tableHeaderView: UIView? {
        get {return self.tableHeaderCell.customView}
        set {
            self.tableHeaderCell.customView = newValue
            if self.adapter.dataArray.count > 0 {
                self.adapter.updateData()
            }
        }
    }
    public var tableFooterView: UIView? {
        get {return self.tableFooterCell.customView}
        set {
            self.tableFooterCell.customView = newValue
            if self.adapter.dataArray.count > 0 {
                self.adapter.updateData()
            }
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        adapter.tableViewInit(self.sn_view)
    }

    override func loadAdapter() -> UITableAdapter {
        let adapter = UITableAdapter()
        adapter.insertSecionModelsClosure = {[weak self] (dataArray) in
            guard let `self` = self else { return dataArray }
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

    // MARK: - ResultParser
    public func parseCellArray(_ cellArray: [StaticTableItemCell]?, _ refresh: Bool) {
        parser.cellArray(cellArray, refresh)
    }
    public func parseModelArray(_ modelArray: [TableItemModel]?, _ refresh: Bool) {
        parser.modelArray(modelArray, refresh)
    }
}
