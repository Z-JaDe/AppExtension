//
//  TableCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public enum CellHeightLayoutType {
    case neverLayout
    case hasLayout
    case resetLayout

    var isNeedLayout: Bool {
        return self != .hasLayout
    }
}
public protocol TableCellConfigProtocol: CellConfigProtocol {
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func willAppear(in cell: UITableViewCell)
    func didDisappear(in cell: UITableViewCell)

    func createCell(isTemp: Bool) -> TableItemCell
    func recycleCell(_ cell: TableItemCell)
    func getCell() -> TableItemCell?

    var tempCellHeight: CGFloat {get}
    func changeTempCellHeight(_ newValue: CGFloat)
    func calculateCellHeight(_ tableView: UITableView, wait: Bool)

    func setNeedResetCellHeight()
}
extension TableCellConfigProtocol {
    func _createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String = SNTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SNTableViewCell
        return cell!
    }
    /// ZJaDe: 计算高度
    public func calculateCellHeight(_ tableView: UITableView, wait: Bool) {
        let tableViewWidth = tableView.width
        if tableViewWidth <= 0 { return }
        /*************** 获取tempCell，并赋值 ***************/
        let item: TableItemCell = self.createCell(isTemp: true)
        let itemCellWidth = self.getItemCellWidth(tableView, item) - item.insets.left - item.insets.right
        /*************** 计算高度 ***************/
        let cellHeight = item.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight + item.insetSpace())
        /*************** cell回收 ***************/
        self.recycleCell(item)
    }

    var cellHeightLayoutType: CellHeightLayoutType {
        switch self.tempCellHeight {
        case 0:
            return .neverLayout
        case ..<0:
            return .resetLayout
        case _:
            return .hasLayout
        }
    }
    public func setNeedResetCellHeight() {
        changeTempCellHeight(-1)
    }
}

extension TableCellConfigProtocol {
    fileprivate func getItemCellWidth(_ tableView: UITableView, _ cell: TableItemCell) -> CGFloat {
        var contentViewWidth = tableView.width
        if let accessoryView = cell.accessoryView {
            contentViewWidth -= 16 + accessoryView.width
        } else {
            switch cell.accessoryType {
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
        return contentViewWidth
    }
}
extension TableItemCell {
    /*************** 计算TableViewCell高度 ***************/
    public func layoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        let result: CGFloat
        if let height = self.frameLayoutHeight(contentWidth) {
            result = height
        } else {
            result = self.autoLayoutHeight(contentWidth)
        }
        return result.ceilToNearest(increment: 1)
    }
    /*************** 计算TableViewCell高度 ***************/
    fileprivate func frameLayoutHeight(_ contentWidth: CGFloat) -> CGFloat? {
        let viewWidth = contentWidth - insets.left - insets.right
        let viewHeight = self.calculateFrameHeight(viewWidth)
        if viewHeight > 0 {
            return viewHeight
        } else {
            return nil
        }
    }
    fileprivate func autoLayoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        let constraint = self.widthAnchor.constraint(equalToConstant: contentWidth)
        constraint.priority = UILayoutPriority(rawValue: 999.1)
        constraint.isActive = true
        let _translates = self.translatesAutoresizingMaskIntoConstraints
        self.translatesAutoresizingMaskIntoConstraints = false
        let cellHeight = self.systemLayoutSizeFitting(CGSize(width: contentWidth, height: 0)).height

        constraint.isActive = false
        self.translatesAutoresizingMaskIntoConstraints = _translates

        return cellHeight
    }
}
