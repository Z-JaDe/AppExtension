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
open class AdapterCollectionViewController: AdapterListViewController<CollectionView, UICollectionAdapter> {

    open override func createView(_ frame: CGRect) -> CollectionView {
        let layout = UICollectionViewFlowLayout()
        return CollectionView(frame: frame, collectionViewLayout: layout)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        adapterViewInit()
    }

    func adapterViewInit() {
        if self.adapter.collectionView == nil {
            adapter.collectionViewInit(self.rootView)
        }
    }

    override func loadAdapter() -> UICollectionAdapter {
        let adapter = UICollectionAdapter()
        return adapter
    }
}
