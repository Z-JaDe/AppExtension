//
//  ListSelectionPlugin.swift
//  ProjectBasic
//
//  Created by Apple on 2020/1/7.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation

public class ListSelectionPlugin<DataSource: ListViewDataSource>: NSObject {

    /// ZJaDe: 是否使用UIKit自带的选中逻辑
    public var useUIKitSectionLogic: Bool = true {
        didSet { updateAllowsSelection() }
    }

    weak var dataSource: DataSource?
    public init(_ dataSource: DataSource) {
        self.dataSource = dataSource
        super.init()
        configInit(dataSource)
    }
    public func configInit(_ dataSource: DataSource) {
        updateAllowsSelection()
    }
    func updateAllowsSelection() {
    }
    // MARK: MultipleSelectionProtocol
    internal func updateUISelectState(_ indexPath: IndexPath) {
    }
}

extension ListSelectionPlugin where DataSource.Item: Equatable {
    func _setItemSelectedState(_ item: DataSource.Item, _ isSelected: Bool) {
        (item.anyBase as? SelectedStateDesignable)?.isSelected = isSelected
    }
    func willDisplay(cellIsSelected: Bool, indexPath: IndexPath) {
        guard useUIKitSectionLogic else { return }
        Async.main {
            guard let itemSelected = self.dataSource?.checkIsSelected(indexPath) else { return }
            if itemSelected {
                self.changeSelectState(indexPath: indexPath, true)
            } else if itemSelected != cellIsSelected {
                self.updateUISelectState(indexPath)
            }
        }
    }
}
extension ListSelectionPlugin: MultipleSelectionProtocol where DataSource.Item: Equatable {
    public typealias SelectItemType = DataSource.Item
    public func setSelectState(item: SelectItemType, _ isSelected: Bool) {
        _setItemSelectedState(item, isSelected)
        updateSelectedItemArrayWhenSelectStateChanged(item, isSelected)
    }

    public func changeSelectState(item: SelectItemType, _ isSelected: Bool) {
        guard let indexPath = dataSource?.indexPath(for: item) else { return }
        changeSelectState(indexPath: indexPath, isSelected)
    }
    /// 可以更新UIKit
    public func changeSelectState(indexPath: IndexPath, _ isSelected: Bool) {
        if isSelected {
            updateItemToSelected(indexPath: indexPath)
        } else {
            updateItemToUnSelected(indexPath: indexPath)
        }
        updateUISelectState(indexPath)
    }
    /// 不会更新UIKit
    public func updateItemToSelected(indexPath: IndexPath) {
        guard let item = dataSource?.item(for: indexPath) else { return }
        updateItemToSelected(item: item)
    }
    /// 不会更新UIKit
    public func updateItemToUnSelected(indexPath: IndexPath) {
        guard let item = dataSource?.item(for: indexPath) else { return }
        updateItemToUnSelected(item: item)
    }
}
