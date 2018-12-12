//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

class UITableProxy: NSObject, UITableViewDelegate {
    weak var adapter: TableAdapterDelegate!
    init(_ adapter: TableAdapterDelegate) {
        self.adapter = adapter
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.heightForRow(at: indexPath)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return adapter.heightForRow(at: indexPath)
    }
    // MARK: -
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return adapter.heightForHeader(in: section)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return adapter.heightForFooter(in: section)
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return adapter.viewForHeader(in: section)
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return adapter.viewForFooter(in: section)
    }
    // MARK: -
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return adapter.editActionsForRowAt(at: indexPath)
    }
    // MARK: -
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return adapter.shouldHighlightItem(at: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adapter.didSelectItem(at: indexPath)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        adapter.didDeselectItem(at: indexPath)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        adapter.willDisplay(cell: cell, at: indexPath)

    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        adapter.didEndDisplaying(cell: cell, at: indexPath)
    }
}
