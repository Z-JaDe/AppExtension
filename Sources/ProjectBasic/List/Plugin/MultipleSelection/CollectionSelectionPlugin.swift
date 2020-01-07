//
//  CollectionSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class CollectionSelectionPlugin: NSObject, UICollectionViewDelegate, MultipleSelectionProtocol {
    public typealias SelectItemType = UICollectionAdapter.Item

    /// ZJaDe: 是否使用UICollectionView自带的选中逻辑
    public var useUIKitSectionLogic: Bool = false {
        didSet { updateAllowsSelection() }
    }

    weak var adapter: UICollectionAdapter?
    public init(_ adapter: UICollectionAdapter) {
        self.adapter = adapter
        super.init()
        updateAllowsSelection()
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
    }
    func updateAllowsSelection() {
        adapter?.autoDeselectRow = !useUIKitSectionLogic
        adapter?.collectionView?.allowsSelection = true
        adapter?.collectionView?.allowsMultipleSelection = true
    }
    // MARK: MultipleSelectionProtocol
    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        adapter?.changeSelectState(isSelected, item)
    }
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        if adapter.dataController[indexPath].isSelected {
            whenItemUnSelected(&adapter.dataController[indexPath])
        } else {
            whenItemSelected(&adapter.dataController[indexPath])
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        whenItemUnSelected(&adapter.dataController[indexPath])
    }
}
extension UICollectionAdapter {
    fileprivate func changeSelectState(_ isSelected: Bool, _ item: CollectionItemModel) {
        guard let indexPath = self.dataController.indexPath(with: item) else { return }
        if isSelected {
            self.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: [])
        } else {
            self.collectionView?.deselectItem(at: indexPath, animated: true)
        }
        item.isSelected = isSelected
    }
}
