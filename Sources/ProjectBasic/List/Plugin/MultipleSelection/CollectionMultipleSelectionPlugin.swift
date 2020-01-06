//
//  CollectionMultipleSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/6.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class CollectionMultipleSelectionPlugin: NSObject, UICollectionViewDelegate, MultipleSelectionProtocol {
    public typealias SelectItemType = UICollectionAdapter.Item

    weak var adapter: UICollectionAdapter?
    public init(_ adapter: UICollectionAdapter) {
        self.adapter = adapter
        adapter.autoDeselectRow = false
        adapter.collectionView?.allowsMultipleSelection = true
        adapter.collectionView?.allowsSelection = true
        super.init()
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
    }
    // MARK: MultipleSelectionProtocol
    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        adapter?.changeSelectState(isSelected, item)
    }
    // MARK: UITableViewDelegate
    @objc
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        whenItemSelected(&adapter.dataController[indexPath])
    }
    @objc
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        whenItemUnSelected(&adapter.dataController[indexPath])
    }
}
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
        item.isSelected = isSelected
    }
}
