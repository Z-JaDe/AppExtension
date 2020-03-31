//
//  ListSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/7.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class ListSelectionPlugin<Adapter: ListAdapterType>: NSObject {

    /// ZJaDe: 是否使用UIKit自带的选中逻辑
    public var useUIKitSectionLogic: Bool = true {
        didSet { updateAllowsSelection() }
    }

    weak var adapter: Adapter?
    public init(_ adapter: Adapter) {
        self.adapter = adapter
        super.init()
        configInit(adapter)
    }
    public func configInit(_ adapter: Adapter) {
        updateAllowsSelection()
    }
    func updateAllowsSelection() {
    }
    // MARK: MultipleSelectionProtocol
    internal func updateUISelectState(_ indexPath: IndexPath) {
    }
}
extension ListSelectionPlugin {
    func checkIsSelected(_ indexPath: IndexPath) -> Bool? {
        return adapter?.dataController.checkIsSelected(indexPath)
    }
}
extension ListSelectionPlugin where Adapter.Item: Equatable {
    func changeItemSelectedState(_ item: inout Adapter.Item, _ isSelected: Bool) {
        // TODO: 隐式推断类型
        if var _item = item as? SelectedStateDesignable {
            _item.isSelected = isSelected
            // swiftlint:disable force_cast
            item = _item as! Adapter.Item
        } else if let _item = item as? ListAdapterItem {
            if var _value = _item.value as? SelectedStateDesignable {
                _value.isSelected = isSelected
            }
        }
    }
    func willDisplay(cellIsSelected: Bool, indexPath: IndexPath) {
        guard useUIKitSectionLogic else { return }
        Async.main {
            guard let itemSelected = self.checkIsSelected(indexPath) else { return }
            if itemSelected {
                self.changeSelectState(true, indexPath)
            } else if itemSelected != cellIsSelected {
                self.updateUISelectState(indexPath)
            }
        }
    }
}
extension ListSelectionPlugin: MultipleSelectionProtocol where Adapter.Item: Equatable {
    public typealias SelectItemType = Adapter.Item
    public func updateSelectState(_ item: inout SelectItemType, _ isSelected: Bool) {
        changeItemSelectedState(&item, isSelected)
        updateSelectedItemArrayWhenSelectStateChanged(item, isSelected)
    }

    public func changeSelectState(_ isSelected: Bool, _ item: SelectItemType) {
        guard let indexPath = adapter?.dataController.indexPath(with: item) else { return }
        changeSelectState(isSelected, indexPath)
    }
    ///可以更新UIKit
    public func changeSelectState(_ isSelected: Bool, _ indexPath: IndexPath) {
        if isSelected {
            updateItemToSelected(indexPath: indexPath)
        } else {
            updateItemToUnSelected(indexPath: indexPath)
        }
        updateUISelectState(indexPath)
    }
    ///不会更新UIKit
    public func updateItemToSelected(indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        updateItemToSelected(&adapter.dataController[indexPath])
    }
    ///不会更新UIKit
    public func updateItemToUnSelected(indexPath: IndexPath) {
        guard let adapter = adapter else { return }
        updateItemToUnSelected(&adapter.dataController[indexPath])
    }
}
