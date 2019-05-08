//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class UITableProxy: NSObject, UITableViewDelegate {
    public private(set) weak var adapter: TableAdapterDelegate!
    public init(_ adapter: TableAdapterDelegate) {
        self.adapter = adapter
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.heightForRow(at: indexPath)
    }
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.heightForRow(at: indexPath)
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adapter.heightForHeader(in: section)
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return adapter.heightForFooter(in: section)
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adapter.viewForHeader(in: section)
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return adapter.viewForFooter(in: section)
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return adapter.editActionsForRowAt(at: indexPath)
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return adapter.shouldHighlightItem(at: indexPath)
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adapter.didSelectItem(at: indexPath)
    }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        adapter.didDeselectItem(at: indexPath)
    }
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        adapter.willDisplay(cell: cell, at: indexPath)

    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        adapter.didEndDisplaying(cell: cell, at: indexPath)
    }
}
