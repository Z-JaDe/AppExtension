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

    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        adapterViewInit()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        adapterViewInit()
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        adapterViewInit()
    }

    func adapterViewInit() {
        if self.rootView.updater.isInHierarchy && self.adapter.collectionView == nil {
            adapter.collectionViewInit(self.rootView)
        }
    }
    override func loadAdapter() -> UICollectionAdapter {
        let adapter = UICollectionAdapter()
        return adapter
    }
}
