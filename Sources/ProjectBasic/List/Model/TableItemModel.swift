//
//  TableItemModel.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class TableItemModel: ListItemModel {
    // MARK: - cell
    public weak var bufferPool: BufferPool?

    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicTableItemCell? {
        didSet {
            guard let cell = _weakContentCell else { return }
            cell.isEnabled = self.isEnabled
            cell.isSelected = self.isSelected
            cell.didLayoutSubviewsClosure = {[weak self] _ in
                self?.updateHeight()
            }
        }
    }
    func getCell() -> DynamicTableItemCell? {
        _weakContentCell
    }
    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet {
            if getCell()?.isSelected != isSelected {
                getCell()?.isSelected = self.isSelected
            }
        }
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet {
            if getCell()?.isEnabled != isEnabled {
                getCell()?.isEnabled = self.isEnabled
            }
        }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        getCell()?.refreshEnabledState(isEnabled)
    }
}
extension TableItemModel: CellSelectedStateDesignable {
    public func didSelectItem() {
        getCell()?.didSelectItem()
    }
}
