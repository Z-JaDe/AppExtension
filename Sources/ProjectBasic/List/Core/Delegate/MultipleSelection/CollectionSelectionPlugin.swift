//
//  CollectionSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class CollectionSelectionPlugin: ListSelectionPlugin<CollectionViewDataSource>, UICollectionViewDelegate {

    override func updateAllowsSelection() {
        guard let dataSource = dataSource else { return }
        dataSource.collectionView?.allowsSelection = true
        dataSource.collectionView?.allowsMultipleSelection = true
    }
    // MARK: MultipleSelectionProtocol
    override func updateUISelectState(_ indexPath: IndexPath) {
        if useUIKitSectionLogic {
            guard let dataSource = dataSource else { return }
            guard let isSelected = dataSource.checkIsSelected(indexPath) else { return }
            if isSelected {
                dataSource.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: [])
            } else {
                dataSource.collectionView?.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay(cellIsSelected: cell.isSelected, indexPath: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let isSelected = dataSource?.checkIsSelected(indexPath) else { return }
        if isSelected {
            changeSelectState(indexPath: indexPath, false)
        } else {
            changeSelectState(indexPath: indexPath, true)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeSelectState(indexPath: indexPath, false)
    }
}
