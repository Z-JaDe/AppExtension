//
//  CollectionViewController.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
open class NormalCollectionViewController: ListViewController<JDCollectionView> {
    open override func createView(_ frame: CGRect) -> JDCollectionView {
        let layout = UICollectionViewFlowLayout()
        return JDCollectionView(frame: frame, collectionViewLayout: layout)
    }
}
open class AdapterCollectionViewController: AdapterListViewController<JDCollectionView, UICollectionAdapter> {

    open override func createView(_ frame: CGRect) -> JDCollectionView {
        let layout = UICollectionViewFlowLayout()
        return JDCollectionView(frame: frame, collectionViewLayout: layout)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        adapter.collectionViewInit(self.rootView)
    }

    override func loadAdapter() -> UICollectionAdapter {
        let adapter = UICollectionAdapter()
        return adapter
    }
}
