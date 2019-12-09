//
//  UITableAdapter+MultipleSelection.swift
//  AppExtension
//
//  Created by Apple on 2019/9/10.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension UITableAdapter {
    public func changeSelectState(_ isSelected: Bool, _ item: AnyTableAdapterItem) {
        guard let indexPath = self.dataController.indexPath(with: item) else {
            return
        }
        if isSelected {
            self.tableView?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            _didSelectItem(at: indexPath)
        } else {
            self.tableView?.deselectRow(at: indexPath, animated: false)
            _didDeselectItem(at: indexPath)
        }
    }
}
extension UITableAdapter {
    func _didSelectItem(at indexPath: IndexPath) {
        if self.autoDeselectRow {
            self.tableView?.deselectRow(at: indexPath, animated: true)
        } else {
            dataController[indexPath].isSelected = true
        }
        let item = dataController[indexPath]
        (item.value as? CellSelectedStateDesignable)?.didSelectItem()
    }
    func _didDeselectItem(at indexPath: IndexPath) {
        dataController[indexPath].isSelected = false
    }
}
