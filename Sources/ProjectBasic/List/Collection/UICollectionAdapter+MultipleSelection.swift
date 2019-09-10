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
