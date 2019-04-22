//
//  CollectionDelegate.swift
//  List
//
//  Created by 郑军铎 on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

protocol CollectionAdapterDelegate: _ListDelegate {
    func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath)
    func didEndDisplaying(cell: UICollectionViewCell, at indexPath: IndexPath)
}

public protocol CollectionViewDelegate: _ListDelegate {
    func didDisplay(item: CollectionItemCell)
    func didEndDisplaying(item: CollectionItemCell)
}
extension CollectionViewDelegate {
    public func didDisplay(item: CollectionItemCell) {

    }
    public func didEndDisplaying(item: CollectionItemCell) {

    }
}
