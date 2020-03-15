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
    func tableSection(at section: Int) -> TableSection? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        return dataController[section].section
    }
    func tableCellItem(at indexPath: IndexPath) -> AnyTableAdapterItem.Value? {
        guard dataController.indexPathCanBound(indexPath) else {
            return nil
        }
        return dataController[indexPath].value
    }
}

open class UITableProxy: NSObject, UITableViewDelegate {
    public private(set) weak var adapter: UITableAdapter!
    public init(_ adapter: UITableAdapter) {
        self.adapter = adapter
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = tableCellItem(at: indexPath) as? TableCellHeightProtocol else {
            return UITableView.automaticDimension
        }
        if item.cellHeightLayoutType == .resetLayout {
            item.calculateCellHeight(tableView, wait: true)
        }
        let height = item.tempCellHeight
        return height > 0 ? height : 0.1
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionModel = tableSection(at: section) else { return 0.1 }
        return sectionModel.headerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionModel = tableSection(at: section) else { return 0.1 }
        return sectionModel.footerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section) else { return nil }
        return sectionModel.headerView
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section) else { return nil }
        return sectionModel.footerView
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let item = tableCellItem(at: indexPath) as? TableCellOfLife else { return true }
        return item.cellShouldHighlight()
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if adapter.autoDeselectRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let item = tableCellItem(at: indexPath) as? TableCellOfLife else { return }
        item.cellDidSelected()
    }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) as? TableCellOfLife else { return }
        item.cellDidDeselected()
    }
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) as? TableCellOfLife else { return }
        item.cellWillAppear(in: cell)
    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? InternalTableViewCell {
            cell.contentItem?.didDisappear()
        }
    }
}
