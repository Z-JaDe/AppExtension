//
//  ASKCollectionAdapter.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class UICollectionAdapter: NSObject {

    public private(set) weak var collectionView: UICollectionView?

    public var dataSource: CollectionViewDataSource!

    func collectionViewInit(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)

        dataSourceDefaultInit(collectionView)
        collectionView.dataSource = dataSource
    }

    open func dataSourceDefaultInit(_ collectionView: UICollectionView) {
        dataSource = CollectionViewDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            item.base.createCell(in: collectionView, at: indexPath)
        })
    }
}
