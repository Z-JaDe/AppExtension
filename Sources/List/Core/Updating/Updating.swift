//
//  Updating.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol Updating: class {
    associatedtype Target
    var target: Target { get }
    init(_ target: Target)

    var isInHierarchy: Bool { get }
    func performBatch(animated: Bool, updates: @escaping () -> Void, completion: @escaping (Bool) -> Void)

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
extension Updating where Target: UIView {
    public var isInHierarchy: Bool {
        return target.window != nil
    }
}
