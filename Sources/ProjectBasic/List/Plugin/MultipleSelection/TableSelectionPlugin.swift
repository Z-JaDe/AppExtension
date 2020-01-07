//
//  TableSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class TableSelectionPlugin: ListSelectionPlugin<UITableAdapter>, UITableViewDelegate {

    public override func configInit(_ adapter: UITableAdapter) {
        super.configInit(adapter)
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
    }
    override func updateAllowsSelection() {
        guard let adapter = adapter else { return }
        adapter.autoDeselectRow = !useUIKitSectionLogic
        adapter.tableView?.allowsSelection = true
        adapter.tableView?.allowsMultipleSelection = true
    }
    // MARK: MultipleSelectionProtocol
    override func updateUISelectState(_ indexPath: IndexPath) {
        if useUIKitSectionLogic {
            guard let adapter = adapter else { return }
            let isSelected = adapter.dataController[indexPath].isSelected
            if isSelected {
                adapter.tableView?.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            } else {
                adapter.tableView?.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay(cellIsSelected: cell.isSelected, indexPath: indexPath)
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        if adapter.dataController[indexPath].isSelected {
            changeSelectState(false, indexPath)
        } else {
            changeSelectState(true, indexPath)
        }
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        changeSelectState(false, indexPath)
    }
}
