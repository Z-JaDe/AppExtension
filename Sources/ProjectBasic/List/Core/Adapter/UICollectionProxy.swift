//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension UICollectionProxy {
    var dataController: UICollectionAdapter.DataSource.DataControllerType {
        adapter.dataSource.dataController
    }
    func collectionSection(at section: Int) -> CollectionSection? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        return dataController[section].section
    }
    func collectionCellItem(at indexPath: IndexPath) -> UICollectionAdapter.Item? {
        guard dataController.indexPathCanBound(indexPath) else {
            return nil
        }
        return dataController[indexPath]
    }
}

open class UICollectionProxy: NSObject, UICollectionViewDelegate {
    public private(set) weak var adapter: UICollectionAdapter!
    public init(_ adapter: UICollectionAdapter) {
        self.adapter = adapter
    }
    // MARK: - Managing the Selected Cells
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if adapter.autoDeselectRow {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.cellDidSelected()
    }
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.cellDidDeselected()
    }
    // MARK: - Managing Cell Highlighting
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let item = collectionCellItem(at: indexPath) else { return true }
        return item.cellShouldHighlight()
    }
    // MARK: - Tracking the Addition and Removal of Views
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.cellWillAppear(in: cell)
    }
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? InternalCollectionViewCell {
            cell.contentItem?.didDisappear()
        }
    }
}
