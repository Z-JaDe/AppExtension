//
//  TableSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class TableSelectionPlugin: NSObject, UITableViewDelegate, MultipleSelectionProtocol {
    public typealias SelectItemType = UITableAdapter.Item

    /// ZJaDe: 是否使用UITableView自带的选中逻辑
    public var useUIKitSectionLogic: Bool = false {
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
    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        adapter?.changeSelectState(isSelected, item)
    }
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        if adapter.dataController[indexPath].isSelected {
            whenItemUnSelected(&adapter.dataController[indexPath])
        } else {
            whenItemSelected(&adapter.dataController[indexPath])
        }
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        whenItemUnSelected(&adapter.dataController[indexPath])
    }
}
extension UITableAdapter {
    fileprivate func changeSelectState(_ isSelected: Bool, _ item: AnyTableAdapterItem) {
        guard let indexPath = self.dataController.indexPath(with: item) else {
            return
        }
        if isSelected {
            self.tableView?.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        } else {
            self.tableView?.deselectRow(at: indexPath, animated: true)
        }
        item.isSelected = isSelected
    }
}
