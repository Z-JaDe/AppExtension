//
//  SectionedDataSource.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/8/24.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import UIKit

open class CollectionViewDataSource<S: SectionModelType>: SectionedDataSource<S>, UICollectionViewDataSource {
    public typealias ConfigureCell = (CollectionViewDataSource<S>, UICollectionView, IndexPath, S.Item) -> UICollectionViewCell
    public typealias ConfigureSupplementaryView = (CollectionViewDataSource<S>, UICollectionView, String, IndexPath) -> UICollectionReusableView
    public typealias MoveItem = (CollectionViewDataSource<S>, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void
    public typealias CanMoveItemAtIndexPath = (CollectionViewDataSource<S>, IndexPath) -> Bool

    open var configureCell: ConfigureCell = { _, _, _, _ in fatalError("You must set cellFactory") } {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var configureSupplementaryView: ConfigureSupplementaryView? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    open var moveItem: MoveItem = { _, _, _ in () } {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var canMoveItemAtIndexPath: ((CollectionViewDataSource<S>, IndexPath) -> Bool)? {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }

    #if os(iOS)
    public typealias IndexTitles = (CollectionViewDataSource<S>) -> [String]?
    public typealias IndexPathForIndexTitle = (CollectionViewDataSource<S>, _ title: String, _ index: Int) -> IndexPath
    open var indexTitles: IndexTitles = { _ in nil } {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    open var indexPathForIndexTitle: IndexPathForIndexTitle = { _, _, index in IndexPath(row: index, section: 0) } {
        didSet {
            #if DEBUG
            ensureNotMutatedAfterBinding()
            #endif
        }
    }
    #endif

    // UICollectionViewDataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataController._data.count
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard dataController.sectionIndexCanBound(section) else { return 0 }
        return dataController._data[section].items.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        precondition(dataController.indexPathCanBound(indexPath))
        return configureCell(self, collectionView, indexPath, dataController[indexPath])
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        configureSupplementaryView!(self, collectionView, kind, indexPath)
    }

    open func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        guard let canMoveItem = canMoveItemAtIndexPath?(self, indexPath) else {
            return false
        }
        return canMoveItem
    }

    open func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let source = dataController[sourceIndexPath]
        let destination = dataController[destinationIndexPath]
        dataController.move(sourceIndexPath, target: destinationIndexPath)
        self.didMoveItem?(source, destination)
        self.moveItem(self, sourceIndexPath, destinationIndexPath)
    }

    #if os(iOS)
    open func indexTitles(for collectionView: UICollectionView) -> [String]? {
        indexTitles(self)
    }

    open func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        indexPathForIndexTitle(self, title, index)
    }
    #endif

    open override func responds(to aSelector: Selector!) -> Bool {
        if aSelector == #selector(UICollectionViewDataSource.collectionView(_:viewForSupplementaryElementOfKind:at:)) {
            return configureSupplementaryView != nil
        } else {
            return super.responds(to: aSelector)
        }
    }
}
