//
//  TableViewUpdating.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

public extension UITableView {
    func createUpdating(_ animation: UITableView.RowAnimation) -> TableViewUpdating {
        return TableViewUpdating(self, animation)
    }
}

public struct TableViewUpdating {
    private weak var tableView: UITableView?
    public var animation: UITableView.RowAnimation
    private var animated: Bool {
        animation == .none
    }
    public init(_ target: UITableView, _ animation: UITableView.RowAnimation) {
        self.tableView = target
        self.animation = animation
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
}
extension TableViewUpdating: Updating {
    public var isInHierarchy: Bool {
        tableView?.window != nil
    }
    // MARK: -
    public func performBatch(updates: (() -> Void)?, completion: @escaping (Bool) -> Void) {
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
    // MARK: -
    public func insertItems(at indexPaths: [IndexPath]) {
        tableView?.insertRows(at: indexPaths, with: animation)
    }
    public func deleteItems(at indexPaths: [IndexPath]) {
        tableView?.deleteRows(at: indexPaths, with: animation)
    }
    public func reloadItems(at indexPaths: [IndexPath]) {
        tableView?.reloadRows(at: indexPaths, with: animation)
    }
    public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        tableView?.moveRow(at: indexPath, to: newIndexPath)
    }
    // MARK: -
    public func insertSections(_ sections: IndexSet) {
        tableView?.insertSections(sections, with: animation)
    }
    public func deleteSections(_ sections: IndexSet) {
        tableView?.deleteSections(sections, with: animation)
    }
    public func reloadSections(_ sections: IndexSet) {
        tableView?.reloadSections(sections, with: animation)
    }
    public func moveSection(_ section: Int, toSection newSection: Int) {
        tableView?.moveSection(section, toSection: newSection)
    }
    // MARK: -
    public func reload(completion: @escaping () -> Void) {
        tableView?.reloadData()
        completion()
    }
}
