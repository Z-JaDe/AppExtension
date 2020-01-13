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
extension ListSelectionPlugin where Adapter.Item: Equatable & SelectedStateDesignable {
    func willDisplay(cellIsSelected: Bool, indexPath: IndexPath) {
        if useUIKitSectionLogic {
            Async.main {
                guard let adapter = self.adapter else { return }
                guard adapter.dataController.indexPathCanBound(indexPath) else { return }
                let itemSelected = adapter.dataController[indexPath].isSelected
                if itemSelected {
                    self.changeSelectState(true, indexPath)
                } else if itemSelected != cellIsSelected {
                    self.updateUISelectState(indexPath)
                }
            }
        }
    }
}
extension ListSelectionPlugin: MultipleSelectionProtocol where Adapter.Item: Equatable & SelectedStateDesignable {
    public typealias SelectItemType = Adapter.Item
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
