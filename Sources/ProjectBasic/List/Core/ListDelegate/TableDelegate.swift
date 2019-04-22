//
//  TableDelegate.swift
//  List
//
//  Created by 郑军铎 on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

protocol TableAdapterDelegate: _ListDelegate {
    func willDisplay(cell: UITableViewCell, at indexPath: IndexPath)
    func didEndDisplaying(cell: UITableViewCell, at indexPath: IndexPath)

    func editActionsForRowAt(at indexPath: IndexPath) -> [UITableViewRowAction]?

    func heightForRow(at indexPath: IndexPath) -> CGFloat

    func heightForHeader(in section: Int) -> CGFloat
    func heightForFooter(in section: Int) -> CGFloat
    func viewForHeader(in section: Int) -> UIView?
    func viewForFooter(in section: Int) -> UIView?
}

public protocol TableViewDelegate: _ListDelegate {
    func didDisplay(item: TableItemCell)
    func didEndDisplaying(item: TableItemCell)
    func editActionsForRowAt(at indexPath: IndexPath) -> [UITableViewRowAction]?
}
extension TableViewDelegate {
    public func didDisplay(item: TableItemCell) {

    }
    public func didEndDisplaying(item: TableItemCell) {

    }

    public func editActionsForRowAt(at indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }
}
