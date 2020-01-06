//
//  TableMultipleSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class TableMultipleSelectionPlugin: NSObject, UITableViewDelegate, MultipleSelectionProtocol {
    public typealias SelectItemType = UITableAdapter.Item

    weak var adapter: UITableAdapter?
    public init(_ adapter: UITableAdapter) {
        self.adapter = adapter
        adapter.autoDeselectRow = false
        adapter.tableView?.allowsMultipleSelection = true
        adapter.tableView?.allowsSelection = true
        super.init()
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)            
        }
    }
    // MARK: MultipleSelectionProtocol
    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        adapter?.changeSelectState(isSelected, item)
    }
    // MARK: UITableViewDelegate
    @objc
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        whenItemSelected(&adapter.dataController[indexPath])
    }
    @objc
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        whenItemUnSelected(&adapter.dataController[indexPath])
    }
}
extension UITableAdapter {
    public func changeSelectState(_ isSelected: Bool, _ item: AnyTableAdapterItem) {
        guard let indexPath = self.dataController.indexPath(with: item) else {
            return
        }
        if isSelected {
            self.tableView?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            _didSelectItem(at: indexPath)
        } else {
            self.tableView?.deselectRow(at: indexPath, animated: false)
            _didDeselectItem(at: indexPath)
        }
    }
}
