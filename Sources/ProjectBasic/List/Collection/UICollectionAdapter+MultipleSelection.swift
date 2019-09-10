//
//  UICollectionAdapter+MultipleSelection.swift
//  AppExtension
//
//  Created by Apple on 2019/9/10.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension UICollectionAdapter: MultipleSelectionProtocol {
    public typealias SelectItemType = Item
    public func changeSelectState(_ isSelected: Bool, _ item: CollectionItemModel) {
        guard let indexPath = self.dataController.indexPath(with: item) else {
            return
        }
        if isSelected {
            self.collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self._didSelectItem(at: indexPath)
        } else {
            self.collectionView?.deselectItem(at: indexPath, animated: false)
            self._didDeselectItem(at: indexPath)
        }
    }

    func allowsSelection(_ collectionView: UICollectionView) {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
    }
}

extension UICollectionAdapter {
    func _didSelectItem(at indexPath: IndexPath) {
        let item = self.dataController[indexPath]
        self.checkCanSelected(item) {[weak self] (isCanSelected) in
            guard let self = self else { return }
            if isCanSelected != false {
                self.whenItemSelected(&self.dataController[indexPath])
            } else {
                if self.autoDeselectRow {
                    self.collectionView?.deselectItem(at: indexPath, animated: true)
                }
            }
        }
        item.didSelectItem()
    }
    func _didDeselectItem(at indexPath: IndexPath) {
        whenItemUnSelected(&dataController[indexPath])
    }
}
