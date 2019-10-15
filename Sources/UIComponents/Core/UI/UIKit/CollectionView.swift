//
//  CollectionView.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class CollectionView: UICollectionView {

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.backgroundColor = Color.clear
    }

}
