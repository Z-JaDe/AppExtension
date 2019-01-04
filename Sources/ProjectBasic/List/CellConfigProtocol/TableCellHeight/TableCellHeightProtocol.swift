//
//  TableCellHeightProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/** ZJaDe:
 使用item来存储高度
 如果改成用tableView根据indexPath来存储高度，刷新时需要清空高度缓存，不可取
 */
protocol TableCellHeightProtocol: TableCellConfigProtocol, AssociatedObjectProtocol {
    func calculateCellHeight(_ tableView: UITableView, wait: Bool)
    func updateHeight(_ closure: (() -> Void)?)
}

extension TableCellHeightProtocol {
    /// ZJaDe: 计算高度
    public func calculateCellHeight(_ tableView: UITableView, wait: Bool) {
        let tableViewWidth = tableView.width
        if tableViewWidth <= 0 { return }
        /*************** 获取tempCell，并赋值 ***************/
        let item: TableItemCell = self.createCell(isTemp: true)
        /*************** 计算高度 ***************/
        let itemCellWidth = item.getItemCellWidth(tableView)
        let cellHeight = item.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight + item.insetVerticalSpace())
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
