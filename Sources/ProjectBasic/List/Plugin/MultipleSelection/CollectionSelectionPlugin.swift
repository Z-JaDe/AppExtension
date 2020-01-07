//
//  CollectionSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class CollectionSelectionPlugin: ListSelectionPlugin<UICollectionAdapter>, UICollectionViewDelegate {

    public override func configInit(_ adapter: UICollectionAdapter) {
        super.configInit(adapter)
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
    }
    override func updateAllowsSelection() {
        guard let adapter = adapter else { return }
        adapter.autoDeselectRow = !useUIKitSectionLogic
        adapter.collectionView?.allowsSelection = true
        adapter.collectionView?.allowsMultipleSelection = true
    }
    // MARK: MultipleSelectionProtocol
    override func updateUISelectState(_ indexPath: IndexPath) {
        if useUIKitSectionLogic {
            guard let adapter = adapter else { return }
            let isSelected = adapter.dataController[indexPath].isSelected
            if isSelected {
                adapter.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: [])
            } else {
                adapter.collectionView?.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplay(cellIsSelected: cell.isSelected, indexPath: indexPath)
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        if adapter.dataController[indexPath].isSelected {
            changeSelectState(false, indexPath)
        } else {
            changeSelectState(true, indexPath)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        changeSelectState(false, indexPath)
    }
}
