//
//  TableViewUpdating.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

open class TableViewUpdating: Updating {
    public unowned let tableView: UITableView
    public var target: UITableView {
        return tableView
    }
    required public init(_ target: UITableView) {
        self.tableView = target
    }
    // MARK: - 
    open func performBatch(animated: Bool, updates: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        if animated {
            _performBatchUpdates(updates, completion: completion)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            _performBatchUpdates(updates) { (result) in
                CATransaction.commit()
                completion(result)
            }
        }
    }
    private func _performBatchUpdates(_ updates: () -> Void, completion: @escaping (Bool) -> Void) {
        if #available(iOS 11.0, tvOS 11.0, *) {
            tableView.performBatchUpdates(updates, completion: completion)
        } else {
            tableView.beginUpdates()
            updates()
            tableView.endUpdates()
            completion(true)
        }
    }
    // MARK: -
    open func insertItems(at indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    open func deleteItems(at indexPaths: [IndexPath]) {
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    open func reloadItems(at indexPaths: [IndexPath]) {
        tableView.reloadRows(at: indexPaths, with: .automatic)
    }
    open func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableView.moveRow(at: indexPath, to: newIndexPath)
    }
    // MARK: -
    open func insertSections(_ sections: IndexSet) {
        tableView.insertSections(sections, with: .automatic)
    }
    open func deleteSections(_ sections: IndexSet) {
        tableView.deleteSections(sections, with: .automatic)
    }
    open func reloadSections(_ sections: IndexSet) {
        tableView.reloadSections(sections, with: .automatic)
    }
    open func moveSection(_ section: Int, toSection newSection: Int) {
        tableView.moveSection(section, toSection: newSection)
    }
    // MARK: -
    open func reload(completion: @escaping () -> Void) {
        tableView.reloadData()
        completion()
    }
}
