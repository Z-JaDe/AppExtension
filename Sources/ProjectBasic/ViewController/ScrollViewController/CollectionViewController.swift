//
//  CollectionViewController.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
open class NormalCollectionViewController: ListViewController<CollectionView> {
    open override func createView(_ frame: CGRect) -> CollectionView {
        let layout = UICollectionViewFlowLayout()
        return CollectionView(frame: frame, collectionViewLayout: layout)
    }
}
open class AdapterCollectionViewController: ListViewController<CollectionView> {
    // MARK: - RefreshListProtocol
    open var networkPage: Int = 0
    /// 默认值若有变化 子类可重写
    open var limit: UInt? = 20

    public lazy private(set) var adapter: UICollectionAdapter = UICollectionAdapter()

    open override func createView(_ frame: CGRect) -> CollectionView {
        let layout = UICollectionViewFlowLayout()
        return CollectionView(frame: frame, collectionViewLayout: layout)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        if self.adapter.collectionView == nil {
            adapter.collectionViewInit(self.rootView)
        }
    }
}
extension AdapterCollectionViewController: RefreshListProtocol {
    public var parser: ResultParser<AdapterCollectionViewController> {
        ResultParser(self) { [weak self] in
            self?.adapter.dataSource.snapshot().numberOfItems ?? 0
        }
    }
}
