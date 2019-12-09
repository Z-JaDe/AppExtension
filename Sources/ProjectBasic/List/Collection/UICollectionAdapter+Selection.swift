//
//  UICollectionAdapter+MultipleSelection.swift
//  AppExtension
//
//  Created by Apple on 2019/9/10.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension UICollectionAdapter {
    public func changeSelectState(_ isSelected: Bool, _ item: CollectionItemModel) {
        guard let indexPath = self.dataController.indexPath(with: item) else { return }
        if isSelected {
            self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: [])
            self._didSelectItem(at: indexPath)
        } else {
            self.collectionView?.deselectItem(at: indexPath, animated: true)
            self._didDeselectItem(at: indexPath)
        }
    }
}

extension UICollectionAdapter {
    func _didSelectItem(at indexPath: IndexPath) {
        if self.autoDeselectRow {
            self.collectionView?.deselectItem(at: indexPath, animated: true)
        } else {
            dataController[indexPath].isSelected = true
        }
        dataController[indexPath].didSelectItem()
    }
    func _didDeselectItem(at indexPath: IndexPath) {
        dataController[indexPath].isSelected = false
    }
}
