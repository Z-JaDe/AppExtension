//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension UITableProxy {
    var dataController: UITableAdapter.DataSource.DataControllerType {
        adapter.dataSource.dataController
    }
    func tableCellItem(at indexPath: IndexPath) -> AnyTableAdapterItem.ValueType {
        return dataController[indexPath].value
    }
}

open class UITableProxy: NSObject, UITableViewDelegate {
    public private(set) weak var adapter: UITableAdapter!
    public init(_ adapter: UITableAdapter) {
        self.adapter = adapter
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard dataController.indexPathCanBound(indexPath) else {
            return 0.1
        }
        guard let item = tableCellItem(at: indexPath) as? TableCellHeightProtocol else {
            return UITableView.automaticDimension
        }
        if item.cellHeightLayoutType == .resetLayout {
            item.calculateCellHeight(tableView, wait: true)
        }
        let height = item.tempCellHeight
        return height > 0 ? height : 0.1
    }
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView(tableView, heightForRowAt: indexPath)
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard dataController.sectionIndexCanBound(section) else {
            return 0.1
        }
        let sectionModel = dataController[section].section
        return sectionModel.headerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard dataController.sectionIndexCanBound(section) else {
            return 0.1
        }
        let sectionModel = dataController[section].section
        return sectionModel.footerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        let sectionModel = dataController[section].section
        return sectionModel.headerView
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        let sectionModel = dataController[section].section
        return sectionModel.footerView
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let item = tableCellItem(at: indexPath) as? TableCellConfigProtocol else {
            return true
        }
        return item.shouldHighlight()
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adapter._didSelectItem(at: indexPath)
    }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        adapter._didDeselectItem(at: indexPath)
    }
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let item = tableCellItem(at: indexPath)
        if let item = item as? TableCellConfigProtocol {
            item.willAppear(in: cell)
        }
        if let isEnabled = self.adapter.isEnabled {
            (item as? EnabledStateDesignable)?.refreshEnabledState(isEnabled)
        }
    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? InternalTableViewCell {
            cell.contentItem?.didDisappear()
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
