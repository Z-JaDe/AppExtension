//
//  TableViewUpdating.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

private var updaterKey: UInt8 = 0
extension UITableView {
    public var updater: Updater {
        return associatedObject(&updaterKey, createIfNeed: Updater(TableViewUpdating(self)))
    }
}

private class TableViewUpdating: Updating {
    private weak var tableView: UITableView?
    fileprivate init(_ target: UITableView) {
        self.tableView = target
    }
    var isInHierarchy: Bool {
        return tableView?.window != nil
    }
    // MARK: - 
    func performBatch(animated: Bool, updates: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
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
    func insertItems(at indexPaths: [IndexPath]) {
        tableView?.insertRows(at: indexPaths, with: .automatic)
    }
    func deleteItems(at indexPaths: [IndexPath]) {
        tableView?.deleteRows(at: indexPaths, with: .automatic)
    }
    func reloadItems(at indexPaths: [IndexPath]) {
        tableView?.reloadRows(at: indexPaths, with: .automatic)
    }
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableView?.moveRow(at: indexPath, to: newIndexPath)
    }
    // MARK: -
    func insertSections(_ sections: IndexSet) {
        tableView?.insertSections(sections, with: .automatic)
    }
    func deleteSections(_ sections: IndexSet) {
        tableView?.deleteSections(sections, with: .automatic)
    }
    func reloadSections(_ sections: IndexSet) {
        tableView?.reloadSections(sections, with: .automatic)
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
