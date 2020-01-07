//
//  TableSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class TableSelectionPlugin: NSObject, UITableViewDelegate, MultipleSelectionProtocol {

    /// ZJaDe: 是否使用UITableView自带的选中逻辑
    public var useUIKitSectionLogic: Bool = true {
        didSet { updateAllowsSelection() }
    }

    weak var adapter: UITableAdapter?
    public init(_ adapter: UITableAdapter) {
        self.adapter = adapter
        super.init()
        updateAllowsSelection()
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
    }
    func updateAllowsSelection() {
        adapter?.autoDeselectRow = !useUIKitSectionLogic
        adapter?.tableView?.allowsSelection = true
        adapter?.tableView?.allowsMultipleSelection = true
    }
    // MARK: MultipleSelectionProtocol
    public typealias SelectItemType = UITableAdapter.Item
    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        if useUIKitSectionLogic {
            guard let adapter = adapter else { return }
            guard let indexPath = adapter.dataController.indexPath(with: item) else { return }
            if isSelected {
                adapter.tableView?.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            } else {
                adapter.tableView?.deselectRow(at: indexPath, animated: true)
            }
        }
        item.isSelected = isSelected
    }
    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if useUIKitSectionLogic {
            Async.main {
                guard let adapter = self.adapter else { return }
                guard adapter.dataController.indexPathCanBound(indexPath) else { return }
                let itemSelected = adapter.dataController[indexPath].isSelected
                if itemSelected && !cell.isSelected {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else if !itemSelected && cell.isSelected {
                    tableView.deselectRow(at: indexPath, animated: false)
                }
            }
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        if adapter.dataController[indexPath].isSelected {
            whenItemUnSelected(&adapter.dataController[indexPath])
            if useUIKitSectionLogic {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } else {
            whenItemSelected(&adapter.dataController[indexPath])
        }
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        whenItemUnSelected(&adapter.dataController[indexPath])
    }
}
