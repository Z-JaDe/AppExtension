//
//  TableCellHeightProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/** ZJaDe:
 之前是用item来存储高度 现在改成用tableView根据indexPath来存储高度
 */
protocol TableCellHeightProtocol: TableCellConfigProtocol {
    var indexPath: IndexPath {get}
    func setNewIndexPath(_ newValue: IndexPath)
    func calculateCellHeight(_ tableView: UITableView, for indexPath: IndexPath, wait: Bool)
}

extension TableCellHeightProtocol {
    /// ZJaDe: 计算高度
    public func calculateCellHeight(_ tableView: UITableView, for indexPath: IndexPath, wait: Bool) {
        setNewIndexPath(indexPath)
        let tableViewWidth = tableView.width
        if tableViewWidth <= 0 { return }
        /*************** 获取tempCell，并赋值 ***************/
        let item: TableItemCell = self.createCell(isTemp: true)
        let itemCellWidth = item.getItemCellWidth(tableView)
        /*************** 计算高度 ***************/
        let cellHeight = item.layoutHeight(itemCellWidth)
        tableView.changeTempCellHeight(cellHeight + item.insetSpace(), for: indexPath)
        /*************** cell回收 ***************/
        self.recycleCell(item)
    }
}

extension TableItemCell {
    fileprivate func getItemCellWidth(_ tableView: UITableView) -> CGFloat {
        var contentViewWidth = tableView.width
        if let accessoryView = self.accessoryView {
            contentViewWidth -= 16 + accessoryView.width
        } else {
            switch self.accessoryType {
            case .none:
                contentViewWidth -= 0
            case .disclosureIndicator:
                contentViewWidth -= 34
            case .detailDisclosureButton:
                contentViewWidth -= 68
            case .checkmark:
                contentViewWidth -= 40
            case .detailButton:
                contentViewWidth -= 48
            }
        }
        if UIScreen.main.scale >= 3 && UIScreen.main.bounds.size.width >= 414 {
            contentViewWidth -= 4
        }
        return contentViewWidth - self.insets.left - self.insets.right
    }
}
