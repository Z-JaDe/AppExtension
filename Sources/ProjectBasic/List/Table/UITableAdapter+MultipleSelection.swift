//
//  UITableAdapter+MultipleSelection.swift
//  AppExtension
//
//  Created by Apple on 2019/9/10.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension UITableAdapter: MultipleSelectionProtocol {
    public typealias SelectItemType = Item
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

    func allowsSelection(_ tableView: UITableView) {
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
    }
}
extension UITableAdapter {
    func _didSelectItem(at indexPath: IndexPath) {
        let item = dataController[indexPath]
        self.checkCanSelected(item) {[weak self] (isCanSelected) in
            guard let self = self else { return }
            if let isCanSelected = isCanSelected {
                self.updateIsCanSelectedState(indexPath: indexPath)(isCanSelected)
            } else if let value = item.value as? CanSelectedStateDesignable {
                value.checkCanSelected(self.updateIsCanSelectedState(indexPath: indexPath))
            }
        }
        (item.value as? CellSelectedStateDesignable)?.didSelectItem()
    }
    private func updateIsCanSelectedState(indexPath: IndexPath) -> (Bool) -> Void {
        return {[weak self] (isCanSelected) in
            guard let self = self else { return }
            if isCanSelected {
                self.whenItemSelected(&self.dataController[indexPath])
            } else {
                if self.autoDeselectRow {
                    self.tableView?.deselectRow(at: indexPath, animated: true)
                }
            }
        }
    }
    func _didDeselectItem(at indexPath: IndexPath) {
        whenItemUnSelected(&dataController[indexPath])
    }
}
