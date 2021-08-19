//
//  CollectionViewDataSource.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2021/5/1.
//  Copyright © 2021 ZJaDe. All rights reserved.
//

import UIKit

open class CollectionViewDataSource: UICollectionViewDiffableDataSource<AnyAdapterSection, AnyCollectionAdapterItem> {
    public init(collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, item in
            item.base.createCell(in: collectionView, at: indexPath)
        }
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)
    }

    public let reloadDataCompletion: CallBackerNoParams = CallBackerNoParams()

    public private(set) var collectionView: UICollectionView?
    public override init(collectionView: UICollectionView, cellProvider: @escaping UICollectionViewDiffableDataSource<AnyAdapterSection, AnyCollectionAdapterItem>.CellProvider) {
        super.init(collectionView: collectionView, cellProvider: cellProvider)
        self.collectionView = collectionView
    }

    open override func apply(_ snapshot: NSDiffableDataSourceSnapshot<AnyAdapterSection, AnyCollectionAdapterItem>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        super.apply(snapshot, animatingDifferences: animatingDifferences) {
            completion?()
            self.reloadDataCompletion.call()
        }
    }

    /// ZJaDe: 重新刷新 返回 ListData
    open func reloadData<Item: AnyCollectionAdapterItem.Element>(_ itemArray: [Item]?, isRefresh: Bool, _ completion: (() -> Void)? = nil) {
        reloadData(section: CollectionSection(), itemArray, isRefresh: isRefresh, completion)
    }
    open func reloadData<Section: Hashable, Item: AnyCollectionAdapterItem.Element>(section: Section, _ itemArray: [Item]?, isRefresh: Bool, _ completion: (() -> Void)? = nil) {
        var snapshot: NSDiffableDataSourceSnapshot<AnyAdapterSection, AnyCollectionAdapterItem>
        if isRefresh {
            snapshot = NSDiffableDataSourceSnapshot()
        } else {
            snapshot = self.snapshot()
        }
        if snapshot.indexOfSection(AnyAdapterSection(section)) == nil {
            snapshot.appendSections([AnyAdapterSection(section)])
        }
        if let itemArray = itemArray?.map(AnyCollectionAdapterItem.init) {
            snapshot.appendItems(itemArray, toSection: AnyAdapterSection(section))
        }
        apply(snapshot) {
            completion?()
        }
    }
}
extension CollectionViewDataSource: ListViewDataSource {
    public typealias Section = AnyAdapterSection
    public typealias Item = AnyCollectionAdapterItem

    public func item(for indexPath: IndexPath) -> AnyCollectionAdapterItem? {
        itemIdentifier(for: indexPath)
    }
}
