//
//  CollectionViewUpdating.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
private var updaterKey: UInt8 = 0
extension UICollectionView {
    public var updater: Updater {
        return associatedObject(&updaterKey, createIfNeed: Updater(CollectionViewUpdating(self)))
    }
}
private struct CollectionViewUpdating: Updating {
    private weak var collectionView: UICollectionView?
    fileprivate init(_ target: UICollectionView) {
        self.collectionView = target
    }
    var isInHierarchy: Bool {
        return collectionView?.window != nil
    }
    // MARK: -
    func performBatch(animated: Bool, updates: (() -> Void)?, completion: @escaping (Bool) -> Void) {
        guard let collectionView = collectionView else { return }
        if animated {
            collectionView.performBatchUpdates(updates, completion: completion)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            collectionView.performBatchUpdates({
                updates?()
            }, completion: { result in
                CATransaction.commit()
                completion(result)
            })
        }
    }
    // MARK: -
    func insertItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        collectionView?.insertItems(at: indexPaths)
    }
    func deleteItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        collectionView?.deleteItems(at: indexPaths)
    }
    func reloadItems(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        collectionView?.reloadItems(at: indexPaths)
    }
    func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        collectionView?.moveItem(at: indexPath, to: newIndexPath)
    }
    // MARK: -
    // MARK: -
    func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        collectionView?.insertSections(sections)
    }
    func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        collectionView?.deleteSections(sections)
    }
    func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        collectionView?.reloadSections(sections)
    }
    func moveSection(_ section: Int, toSection newSection: Int) {
        collectionView?.moveSection(section, toSection: newSection)
    }
    // MARK: -
    func reload(completion: @escaping () -> Void) {
        collectionView?.reloadData()
        collectionView?.collectionViewLayout.invalidateLayout()
        completion()
    }
}
