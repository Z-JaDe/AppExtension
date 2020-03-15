//
//  TableCellModel.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

open class TableCellModel: ListItemModel {

    weak var _weakCell: UITableViewCell?
    func getCell() -> UITableViewCell? {
        return _weakCell
    }

    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { getCell()?.setSelected(self.isSelected, animated: true) }
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool = true {
        didSet {
            if var cell = getCell() as? EnabledStateDesignable {
                if cell.isEnabled != isEnabled {
                    cell.isEnabled = isEnabled
                }
            }
        }
    }
    // MARK: -
    open func bindingCellData(_ cell: UITableViewCell) {
    }
    // MARK: -
    open func updateHeight(_ closure: (() -> Void)? = nil) {
    }
}
