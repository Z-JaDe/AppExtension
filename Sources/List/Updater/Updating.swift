//
//  Updating.swift
//  ListAdapter
//
//  Created by 郑军铎 on 2019/11/23.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public enum UpdateMode {
    case everything
    case partial
}

public protocol Updating {
    var isInHierarchy: Bool { get }

    func performBatch(updates: (() -> Void)?, completion: @escaping (Bool) -> Void)

    func insertItems(at indexPaths: [IndexPath])
    func deleteItems(at indexPaths: [IndexPath])
    func reloadItems(at indexPaths: [IndexPath])
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath)

    func insertSections(_ sections: IndexSet)
    func deleteSections(_ sections: IndexSet)
    func reloadSections(_ sections: IndexSet)
    func moveSection(_ section: Int, toSection newSection: Int)

    func reload(completion: @escaping () -> Void)
}
