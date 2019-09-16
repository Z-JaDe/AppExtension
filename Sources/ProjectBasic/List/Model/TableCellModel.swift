//
//  TableCellModel.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

open class TableCellModel: ListItemModel {

    weak var _cell: UITableViewCell?

    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { _cell?.isSelected = self.isSelected }
    }
    public var canSelected: Bool = false
    open func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        closure(self.canSelected)
    }
    open func didSelectItem() {
        (_cell as? CellSelectedStateDesignable)?.didSelectItem()
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet {
            var cell = _cell as? EnabledStateDesignable
            cell?.isEnabled = self.isEnabled
        }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        (_cell as? EnabledStateDesignable)?.refreshEnabledState(isEnabled)
    }
    // MARK: -
    open func bindingCellData(_ cell: UITableViewCell) {
    }
    // MARK: -
    open func updateHeight(_ closure: (() -> Void)? = nil) {
    }
}
extension TableCellModel: TableCellConfigProtocol {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = _createCell(in: tableView, for: indexPath, getCellClsName())
        self._cell = cell
        return cell
    }
    func willAppear(in cell: UITableViewCell) {
        bindingCellData(cell)
    }
    func didDisappear(in cell: UITableViewCell) {
    }
    func shouldHighlight() -> Bool {
        true
    }
}
extension TableCellModel: TableCellHeightProtocol {
    public func setNeedResetCellHeight() {
        _setNeedResetCellHeight()
    }

    /// ZJaDe: 计算高度
    public func calculateCellHeight(_ tableView: UITableView, wait: Bool) {
        let tableViewWidth = tableView.bounds.size.width
        if tableViewWidth <= 0 { return }
        /*************** 获取tempCell，并赋值 ***************/
        let cell = self.getTempCell(getCellClsName(), tableView: tableView)
        self.bindingCellData(cell)
        /*************** 计算高度 ***************/
        let itemCellWidth = cell.getItemCellWidth(tableView)
        let cellHeight = cell.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight)
    }
}
extension TableCellModel {
    // MARK: -
    private static var tempCells: [String: UITableViewCell] = [:]
    func getTempCell(_ cellName: String, tableView: UITableView) -> UITableViewCell {
        if let cell = TableCellModel.tempCells[cellName] {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellName)
            return cell!
        }
    }
}

extension UITableViewCell {
    func getItemCellWidth(_ tableView: UITableView) -> CGFloat {
        tableView.getItemCellWidth(accessoryView, accessoryType)
    }
    /*************** 计算TableViewCell高度 ***************/
    func layoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        let result: CGFloat
        if let height = self.frameLayoutHeight(contentWidth) {
            result = height
        } else {
            result = self.autoLayoutHeight(contentWidth)
        }
        return result.ceilToNearest(increment: 1)
    }
    /*************** 计算TableViewCell高度 ***************/
    private func frameLayoutHeight(_ contentWidth: CGFloat) -> CGFloat? {
        let viewWidth = contentWidth
        let viewHeight = self.calculateFrameHeight(viewWidth)
        return viewHeight > 0 ? viewHeight : nil
    }
    open dynamic func calculateFrameHeight(_ width: CGFloat) -> CGFloat {
        0
    }
    private func autoLayoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        self.calculateAutoLayoutHeight(contentWidth)
    }
}
