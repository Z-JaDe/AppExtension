//
//  CollectionSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class CollectionSelectionPlugin: NSObject, UICollectionViewDelegate, MultipleSelectionProtocol {

    /// ZJaDe: 是否使用UICollectionView自带的选中逻辑
    public var useUIKitSectionLogic: Bool = true {
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
    public typealias SelectItemType = UICollectionAdapter.Item
    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        if useUIKitSectionLogic {
            guard let adapter = adapter else { return }
            guard let indexPath = adapter.dataController.indexPath(with: item) else { return }
            if isSelected {
                adapter.collectionView?.selectItem(at: indexPath, animated: true, scrollPosition: [])
            } else {
                adapter.collectionView?.deselectItem(at: indexPath, animated: true)
            }
        }
        item.isSelected = isSelected
    }
    // MARK: UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if useUIKitSectionLogic {
            Async.main {
                guard let adapter = self.adapter else { return }
                guard adapter.dataController.indexPathCanBound(indexPath) else { return }
                let itemSelected = adapter.dataController[indexPath].isSelected
                if itemSelected && !cell.isSelected {
                    collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                } else if !itemSelected && cell.isSelected {
                    collectionView.deselectItem(at: indexPath, animated: false)
                }
            }
        }
    }
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
