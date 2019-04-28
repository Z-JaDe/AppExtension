//
//  CollectionDelegate.swift
//  List
//
//  Created by 郑军铎 on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

protocol CollectionAdapterDelegate: class {
    func didSelectItem(at indexPath: IndexPath)
    func didDeselectItem(at indexPath: IndexPath)
    func shouldHighlightItem(at indexPath: IndexPath) -> Bool

    func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath)
    func didEndDisplaying(cell: UICollectionViewCell, at indexPath: IndexPath)
}

public protocol CollectionViewDelegate: class {
    func didSelectItem(at indexPath: IndexPath)
    func didDeselectItem(at indexPath: IndexPath)
    func shouldHighlightItem(at indexPath: IndexPath) -> Bool

    func didDisplay(item: CollectionItemCell)
    func didEndDisplaying(item: CollectionItemCell)
}
extension CollectionViewDelegate {
    public func didSelectItem(at indexPath: IndexPath) { }
    public func didDeselectItem(at indexPath: IndexPath) { }
    public func shouldHighlightItem(at indexPath: IndexPath) -> Bool { return true }

    public func didDisplay(item: CollectionItemCell) { }
    public func didEndDisplaying(item: CollectionItemCell) { }
}
