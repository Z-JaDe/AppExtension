//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension UICollectionProxy {
    func collectionCellItem(at indexPath: IndexPath) -> AnyCollectionAdapterItem? {
        adapter.dataSource.item(for: indexPath)
    }
}

open class UICollectionProxy: NSObject, UICollectionViewDelegate {
    public private(set) weak var adapter: UICollectionAdapter!
    public init(_ adapter: UICollectionAdapter) {
        self.adapter = adapter
    }
    // MARK: - Managing the Selected Cells
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if adapter.dataSource.autoDeselectRow {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.base.cellDidSelected()
    }
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.base.cellDidDeselected()
    }
    // MARK: - Managing Cell Highlighting
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let item = collectionCellItem(at: indexPath) else { return true }
        return item.base.cellShouldHighlight()
    }
    // MARK: - Tracking the Addition and Removal of Views
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.base.cellWillAppear(in: cell)
    }
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? InternalCollectionViewCell {
            cell.contentItem?.didDisappear()
        }
    }
}
