//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

class UICollectionProxy: NSObject, UICollectionViewDelegate {
    weak var adapter: CollectionAdapterDelegate!
    init(_ adapter: CollectionAdapterDelegate) {
        self.adapter = adapter
    }
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return adapter.shouldHighlightItem(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        adapter.didSelectItem(at: indexPath)
    }
    // MARK: -
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        adapter.didDeselectItem(at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        adapter.willDisplay(cell: cell, at: indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        adapter.didEndDisplaying(cell: cell, at: indexPath)
    }
}
