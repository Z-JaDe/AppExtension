//
//  TableCellModel.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

open class TableCellModel: ListItemModel {

    weak var _weakCell: UITableViewCell? {
        didSet {
            guard let cell = _weakCell else {
                return
            }
            var temp = _weakCell as? EnabledStateDesignable
            temp?.isEnabled = self.isEnabled
            cell.isSelected = self.isSelected
        }
    }
    func getCell() -> UITableViewCell? {
        return _weakCell
    }

    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { getCell()?.setSelected(self.isSelected, animated: false) }
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet {
            var cell = getCell() as? EnabledStateDesignable
            cell?.isEnabled = self.isEnabled
        }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        (getCell() as? EnabledStateDesignable)?.refreshEnabledState(isEnabled)
    }
    // MARK: -
    open func bindingCellData(_ cell: UITableViewCell) {
    }
    // MARK: -
    open func updateHeight(_ closure: (() -> Void)? = nil) {
    }
}
extension TableCellModel: CellSelectedStateDesignable {
    public func didSelectItem() {
        (getCell() as? CellSelectedStateDesignable)?.didSelectItem()
    }
}
