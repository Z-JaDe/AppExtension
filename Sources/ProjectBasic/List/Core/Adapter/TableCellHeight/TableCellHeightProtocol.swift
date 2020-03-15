//
//  TableCellHeightProtocol.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public enum CellHeightLayoutType {
    case neverLayout
    case hasLayout
    case resetLayout

    var isNeedLayout: Bool {
        self != .hasLayout
    }
}

/** ZJaDe:
 使用item来存储高度
 如果改成用tableView根据indexPath来存储高度，刷新时需要清空高度缓存，不可取
 */
protocol TableCellHeightProtocol: AssociatedObjectProtocol {
    /// ZJaDe: 计算高度
    func calculateCellHeight(_ tableView: UITableView, wait: Bool)
    func updateHeight(_ closure: (() -> Void)?)
}
private var cellHeightKey: UInt8 = 0
extension TableCellHeightProtocol {
    var tempCellHeight: CGFloat {
        associatedObject(&cellHeightKey, createIfNeed: 0)
    }
    func changeTempCellHeight(_ newValue: CGFloat) {
        setAssociatedObject(&cellHeightKey, newValue)
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

    func _setNeedResetCellHeight() {
        self.changeTempCellHeight(-1)
    }
}
// MARK: -
extension TableItemModel: TableCellHeightProtocol {
    public func updateHeight(_ closure: (() -> Void)? = nil) {
        getCell()?.updateHeight(self, closure)
    }
    public func setNeedResetCellHeight() {
        _setNeedResetCellHeight()
    }

    /// ZJaDe: 计算高度
    public func calculateCellHeight(_ tableView: UITableView, wait: Bool) {
        let tableViewWidth = tableView.bounds.size.width
        if tableViewWidth <= 0 { return }
        /*************** 获取tempCell，并赋值 ***************/
        let item = self.getTempCell(tableView: tableView)
        item.setModel(self)
        /*************** 计算高度 ***************/
        let itemCellWidth = item.getItemCellWidth(tableView)
        let cellHeight = item.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight + item.insetVerticalSpace())
    }
}

// MARK: -
extension StaticTableItemCell: TableCellHeightProtocol {
    public func updateHeight(_ closure: (() -> Void)? = nil) {
        self.updateHeight(self, closure)
    }
    public func setNeedResetCellHeight() {
        _setNeedResetCellHeight()
    }

    public func calculateCellHeight(_ tableView: UITableView, wait: Bool) {
        let tableViewWidth = tableView.bounds.size.width
        if tableViewWidth <= 0 { return }
        /*************** 计算高度 ***************/
        let itemCellWidth = getItemCellWidth(tableView)
        let cellHeight = layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight + insetVerticalSpace())
    }
}
// MARK: -
extension TableCellModel: TableCellHeightProtocol {
    public func setNeedResetCellHeight() {
        _setNeedResetCellHeight()
    }

    /// ZJaDe: 计算高度
    public func calculateCellHeight(_ tableView: UITableView, wait: Bool) {
        let tableViewWidth = tableView.bounds.size.width
        if tableViewWidth <= 0 { return }
        /*************** 获取tempCell，并赋值 ***************/
        let cell = self.getTempCell(tableView: tableView)
        self.bindingCellData(cell)
        /*************** 计算高度 ***************/
        let itemCellWidth = cell.getItemCellWidth(tableView)
        let cellHeight = cell.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight)
    }
}
