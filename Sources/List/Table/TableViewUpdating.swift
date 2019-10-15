//
//  TableViewUpdating.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

private var updaterKey: UInt8 = 0
extension UITableView {
    public var updater: Updater {
        associatedObject(&updaterKey, createIfNeed: Updater(TableViewUpdating(self)))
    }
}

private struct TableViewUpdating: Updating {
    private weak var tableView: UITableView?
    fileprivate init(_ target: UITableView) {
        self.tableView = target
    }
    var isInHierarchy: Bool {
        tableView?.window != nil
    }
    // MARK: - 
    func performBatch(animated: Bool, updates: (() -> Void)?, completion: @escaping (Bool) -> Void) {
        let updates = updates ?? {}
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
        guard let tableView = tableView else { return }
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
    func insertItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView?.insertRows(at: indexPaths, with: animation)
    }
    func deleteItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView?.deleteRows(at: indexPaths, with: animation)
    }
    func reloadItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView?.reloadRows(at: indexPaths, with: animation)
    }
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableView?.moveRow(at: indexPath, to: newIndexPath)
    }
    // MARK: -
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tableView?.insertSections(sections, with: animation)
    }
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tableView?.deleteSections(sections, with: animation)
    }
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        tableView?.reloadSections(sections, with: animation)
    }
    func moveSection(_ section: Int, toSection newSection: Int) {
        tableView?.moveSection(section, toSection: newSection)
    }
    // MARK: -
    func reload(completion: @escaping () -> Void) {
        tableView?.reloadData()
        completion()
    }
}
