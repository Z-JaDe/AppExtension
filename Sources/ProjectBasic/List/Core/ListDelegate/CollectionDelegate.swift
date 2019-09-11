//
//  CollectionDelegate.swift
//  List
//
//  Created by 郑军铎 on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol CollectionViewDelegate: class {
    func didSelectItem(at indexPath: IndexPath)
    func didDeselectItem(at indexPath: IndexPath)
    func shouldHighlightItem(at indexPath: IndexPath) -> Bool

    func didDisplay(cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    func didEndDisplaying(cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
}
extension CollectionViewDelegate {
    public func didSelectItem(at indexPath: IndexPath) { }
    public func didDeselectItem(at indexPath: IndexPath) { }
    public func shouldHighlightItem(at indexPath: IndexPath) -> Bool { return true }

    public func didDisplay(cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
    public func didEndDisplaying(cell: UICollectionViewCell, forItemAt indexPath: IndexPath) { }
}
