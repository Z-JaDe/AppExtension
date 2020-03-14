//
//  CollectionItemModel.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class CollectionItemModel: ListItemModel {
    public var cellSize: CGSize?
    // MARK: - cell
    public weak var bufferPool: BufferPool?
    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicCollectionItemCell? {
        didSet {
            _weakContentCell?.isEnabled = self.isEnabled
        }
    }
    func getCell() -> DynamicCollectionItemCell? {
        _weakContentCell
    }
    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { getCell()?.isSelected = self.isSelected }
    }
    open func didSelectItem() {
        getCell()?.didSelectItem()
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet { getCell()?.isEnabled = self.isEnabled }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        getCell()?.refreshEnabledState(isEnabled)
    }
}
