//
//  TableItemModel.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class TableItemModel: ListItemModel {
    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicTableItemCell?
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
    public var isEnabled: Bool = true {
        didSet {
            if getCell()?.isEnabled != isEnabled {
                getCell()?.isEnabled = self.isEnabled
            }
        }
    }
}
