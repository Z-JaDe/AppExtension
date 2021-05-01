//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension UITableProxy {
    func tableSection(at section: Int) -> AnyAdapterSection? {
        let sections = adapter.dataSource.snapshot().sectionIdentifiers
        if  section <= 0 || sections.count <= section {
            return nil
        }
        return sections[section]
    }
    func tableCellItem(at indexPath: IndexPath) -> AnyTableAdapterItem? {
        adapter.dataSource.item(for: indexPath)
    }
}

open class UITableProxy: NSObject, UITableViewDelegate {
    public private(set) weak var adapter: UITableAdapter!
    public init(_ adapter: UITableAdapter) {
        self.adapter = adapter
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = tableCellItem(at: indexPath)?.base as? TableCellHeightProtocol else {
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
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return 0.1 }
        return sectionModel.headerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return 0.1 }
        return sectionModel.footerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return nil }
        return sectionModel.headerView
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return nil }
        return sectionModel.footerView
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let item = tableCellItem(at: indexPath) else { return true }
        return item.base.cellShouldHighlight()
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if adapter.dataSource.autoDeselectRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let item = tableCellItem(at: indexPath) else { return }
        item.base.cellDidSelected()
    }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) else { return }
        item.base.cellDidDeselected()
    }
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) else { return }
        item.base.cellWillAppear(in: cell)
    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? InternalTableViewCell {
            cell.contentItem?.didDisappear()
        }
    }
}
