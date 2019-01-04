//
//  UICollection+AdapterDelegate.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import UIKit
extension UICollectionAdapter: CollectionAdapterDelegate {
    public func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNCollectionViewCell else {
            return
        }
        let itemModel = self.dataController[indexPath]
        itemModel.willAppear(in: cell)
        if let itemCell = itemModel.getCell() {
            delegate?.didDisplay(item: itemCell)
            if let isEnabled = self.isEnabled {
                itemCell.refreshEnabledState(isEnabled)
            }
        }
    }
    public func didEndDisplaying(cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNCollectionViewCell else {
            return
        }
        if let itemModel = (cell.contentItem as? DynamicCollectionItemCell)?._model {
            if let itemCell = itemModel.getCell() {
                delegate?.didEndDisplaying(item: itemCell)
            }
            itemModel.didDisappear(in: cell)
            //        } else if let itemModel = cell.contentItem as? StaticCollectionViewCell {
            //            if let itemCell = itemModel.getCell() {
            //                delegate?.didEndDisplaying(item: itemCell)
            //            }
            //            itemModel.didDisappear(in: cell)
        }
    }

    public func shouldHighlightItem(at indexPath: IndexPath) -> Bool {
        if let result = delegate?.shouldHighlightItem(at: indexPath) {
            return result
        }
        let item = self.dataController[indexPath].getCell()
        return item?.checkShouldHighlight() ?? true
    }
    public func didSelectItem(at indexPath: IndexPath) {
        _didSelectItem(at: indexPath)
        delegate?.didSelectItem(at: indexPath)
    }
    public func didDeselectItem(at indexPath: IndexPath) {
        _didDeselectItem(at: indexPath)
        delegate?.didSelectItem(at: indexPath)
    }
}
extension UICollectionAdapter {
    internal func _didSelectItem(at indexPath: IndexPath) {
        let item = self.dataController[indexPath]
        self.checkCanSelected(item) {[weak self] (isCanSelected) in
            guard let `self` = self else { return }
            if isCanSelected {
                self.whenItemSelected(item)
            } else {
                if self.autoDeselectRow {
                    self.collectionView?.deselectItem(at: indexPath, animated: true)
                }
            }
        }
        item.didSelectItem()
    }
    internal func _didDeselectItem(at indexPath: IndexPath) {
        let item = self.dataController[indexPath]
        whenItemUnSelected(item)
    }

}
