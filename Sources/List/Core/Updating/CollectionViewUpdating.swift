//
//  CollectionViewUpdating.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

open class CollectionViewUpdating: Updating {
    public unowned let collectionView: UICollectionView
    public var target: UICollectionView {
        return collectionView
    }
    required public init(_ target: UICollectionView) {
        self.collectionView = target
    }
    // MARK: -
    open func performBatch(animated: Bool, updates: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        if animated {
            collectionView.performBatchUpdates(updates, completion: completion)
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            collectionView.performBatchUpdates({
                updates()
            }, completion: { result in
                CATransaction.commit()
                completion(result)
            })
        }
    }
    // MARK: -
    open func insertItems(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }
    open func deleteItems(at indexPaths: [IndexPath]) {
        collectionView.deleteItems(at: indexPaths)
    }
    open func reloadItems(at indexPaths: [IndexPath]) {
        collectionView.reloadItems(at: indexPaths)
    }
    open func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        collectionView.moveItem(at: indexPath, to: newIndexPath)
    }
    // MARK: -
    // MARK: -
    open func insertSections(_ sections: IndexSet) {
        collectionView.insertSections(sections)
    }
    open func deleteSections(_ sections: IndexSet) {
        collectionView.deleteSections(sections)
    }
    open func reloadSections(_ sections: IndexSet) {
        collectionView.reloadSections(sections)
    }
    open func moveSection(_ section: Int, toSection newSection: Int) {
        collectionView.moveSection(section, toSection: newSection)
    }
    // MARK: -
    open func reload(completion: @escaping () -> Void) {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        completion()
    }
}
