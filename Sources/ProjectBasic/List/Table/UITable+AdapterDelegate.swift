//
//  UITable+AdapterDelegate.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import UIKit

/** ZJaDe:
 因为heightForRow方法在reloadData的时候会全调用一遍，所以计算高度的逻辑应该放在createCell中
 但是有时候height是重设时不会走createCell，所以当height为resetLayout时，即使在heightForRow方法中也要计算
 */
extension UITableAdapter: TableAdapterDelegate {
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard dataController.indexPathCanBound(indexPath) else {
            return 0.1
        }
        let item = dataController[indexPath]
        if item.value.cellHeightLayoutType == .resetLayout {
            item.value.calculateCellHeight(tableView!, wait: true)
        }
        let height = item.value.tempCellHeight
        return height > 0 ? height : Space.cellDefaultHeight
    }
    // MARK: -
    public func heightForHeader(in section: Int) -> CGFloat {
        guard dataController.sectionIndexCanBound(section) else {
            return 0.1
        }
        let sectionModel = dataController[section].section
        return sectionModel.headerView.viewHeight(self.tableView!.width)
    }

    public func heightForFooter(in section: Int) -> CGFloat {
        guard dataController.sectionIndexCanBound(section) else {
            return 0.1
        }
        let sectionModel = dataController[section].section
        return sectionModel.footerView.viewHeight(self.tableView!.width)
    }

    public func viewForHeader(in section: Int) -> UIView? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        let sectionModel = dataController[section].section
        return sectionModel.headerView
    }

    public func viewForFooter(in section: Int) -> UIView? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        let sectionModel = dataController[section].section
        return sectionModel.footerView
    }

    public func willDisplay(cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        let itemModel = dataController[indexPath]
        itemModel.value.willAppear(in: cell)
        if let itemCell = itemModel.value.getCell() {
            delegate?.didDisplay(item: itemCell)
            if let isEnabled = self.isEnabled {
                itemCell.refreshEnabledState(isEnabled)
            }
        }
    }
    public func didEndDisplaying(cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        if let itemModel = (cell.contentItem as? DynamicTableItemCell)?._model {
            if let itemCell = itemModel.getCell() {
                itemModel.didDisappear(in: cell)
                delegate?.didEndDisplaying(item: itemCell)
            }
        } else if let itemModel = cell.contentItem as? StaticTableItemCell {
            if let itemCell = itemModel.getCell() {
                itemModel.didDisappear(in: cell)
                delegate?.didEndDisplaying(item: itemCell)
            }
        }
    }

    public func shouldHighlightItem(at indexPath: IndexPath) -> Bool {
        if let result = delegate?.shouldHighlightItem(at: indexPath) {
            return result
        }
        let item = dataController[indexPath].value.getCell()
        return item?.checkShouldHighlight() ?? true
    }

    public func didSelectItem(at indexPath: IndexPath) {
        _didSelectItem(at: indexPath)
        delegate?.didSelectItem(at: indexPath)
    }

    public func didDeselectItem(at indexPath: IndexPath) {
        _didDeselectItem(at: indexPath)
        delegate?.didDeselectItem(at: indexPath)
    }
    // MARK: -
    public func editActionsForRowAt(at indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let result = delegate?.editActionsForRowAt(at: indexPath) {
            return result
        }
        return nil
    }
}
extension UITableAdapter {
    internal func createCell(in tableView: UITableView, for indexPath: IndexPath, item: TableAdapterItemCompatible) -> UITableViewCell {
        if item.value.cellHeightLayoutType.isNeedLayout {
            item.value.calculateCellHeight(tableView, wait: true)
        }
        return item.value.createCell(in: tableView, for: indexPath)
    }
    internal func _didSelectItem(at indexPath: IndexPath) {
        let item = dataController[indexPath]
        self.checkCanSelected(item) {[weak self] (isCanSelected) in
            guard let `self` = self else { return }
            if isCanSelected {
                self.whenItemSelected(item)
            } else {
                if self.autoDeselectRow {
                    self.tableView?.deselectRow(at: indexPath, animated: true)
                }
            }
        }
        item.didSelectItem()
    }
    internal func _didDeselectItem(at indexPath: IndexPath) {
        let item = dataController[indexPath]
        whenItemUnSelected(item)
    }
}
