//
//  Updating.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

protocol Updating: class {
    var isInHierarchy: Bool { get }

    func performBatch(animated: Bool, updates: (() -> Void)?, completion: @escaping (Bool) -> Void)

    func insertItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func deleteItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func reloadItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath)

    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation)
    func moveSection(_ section: Int, toSection newSection: Int)

    func reload(completion: @escaping () -> Void)
}
