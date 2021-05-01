//
//  TableSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class TableSelectionPlugin: ListSelectionPlugin<TableViewDataSource>, UITableViewDelegate {

    override func updateAllowsSelection() {
        guard let dataSource = dataSource else { return }
        dataSource.autoDeselectRow = !useUIKitSectionLogic
        dataSource.tableView?.allowsSelection = true
        dataSource.tableView?.allowsMultipleSelection = true
    }
    // MARK: MultipleSelectionProtocol
    override func updateUISelectState(_ indexPath: IndexPath) {
        guard useUIKitSectionLogic else { return }
        guard let dataSource = dataSource else { return }
        guard let isSelected = dataSource.checkIsSelected(indexPath) else { return }
        if isSelected {
            dataSource.tableView?.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            dataSource.tableView?.deselectRow(at: indexPath, animated: true)
        }
    }
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay(cellIsSelected: cell.isSelected, indexPath: indexPath)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let isSelected = dataSource?.checkIsSelected(indexPath) else { return }
        if isSelected {
            changeSelectState(indexPath: indexPath, false)
        } else {
            changeSelectState(indexPath: indexPath, true)
        }
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        changeSelectState(indexPath: indexPath, false)
    }
}
