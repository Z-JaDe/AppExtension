//
//  CollectionViewUpdating.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func createUpdating(animated: Bool) -> CollectionViewUpdating {
        return CollectionViewUpdating(self, animated: animated)
    }
}

public struct CollectionViewUpdating {
    private weak var collectionView: UICollectionView?
    public var animated: Bool
    public init(_ target: UICollectionView, animated: Bool) {
        self.collectionView = target
        self.animated = animated
    }
}
extension CollectionViewUpdating: Updating {
    public var isInHierarchy: Bool {
        collectionView?.window != nil
    }
    // MARK: -
    public func performBatch(updates: (() -> Void)?, completion: @escaping (Bool) -> Void) {
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
    public func insertItems(at indexPaths: [IndexPath]) {
        collectionView?.insertItems(at: indexPaths)
    }
    public func deleteItems(at indexPaths: [IndexPath]) {
        collectionView?.deleteItems(at: indexPaths)
    }
    public func reloadItems(at indexPaths: [IndexPath]) {
        collectionView?.reloadItems(at: indexPaths)
    }
    public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {
        collectionView?.moveItem(at: indexPath, to: newIndexPath)
    }
    // MARK: -
    // MARK: -
    public func insertSections(_ sections: IndexSet) {
        collectionView?.insertSections(sections)
    }
    public func deleteSections(_ sections: IndexSet) {
        collectionView?.deleteSections(sections)
    }
    public func reloadSections(_ sections: IndexSet) {
        collectionView?.reloadSections(sections)
    }
    public func moveSection(_ section: Int, toSection newSection: Int) {
        collectionView?.moveSection(section, toSection: newSection)
    }
    // MARK: -
    public func reload(completion: @escaping () -> Void) {
        collectionView?.reloadData()
        collectionView?.collectionViewLayout.invalidateLayout()
        completion()
    }
}
