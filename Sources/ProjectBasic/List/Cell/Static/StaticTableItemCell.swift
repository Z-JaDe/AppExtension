//
//  StaticTableItemCell.swift
//  SNKit_ZJMax
//
//  Created by ZJaDe on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class StaticTableItemCell: TableItemCell {

    open var canSelected: Bool = false
    public func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        closure(self.canSelected)
    }
    // MARK: -
    open override func configInit() {
        super.configInit()
        self.highlightedAnimation = .zoom

        self.didLayoutSubviewsClosure = { [weak self] (cell) -> Void in
            self?.updateHeight()
        }
    }

    // MARK: - CheckAndCatchParamsProtocol
    public var key: String = ""
    public var catchParamsErrorPrompt: String?
    public var catchParamsClosure: CatchParamsClosure?
    public var checkParamsClosure: CheckParamsClosure?
}
extension StaticTableItemCell: TableCellConfigProtocol {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell: InternalTableViewCell = _createCell(in: tableView, for: indexPath, InternalTableViewCell.reuseIdentifier) as! InternalTableViewCell
        //        let item = self.cell()
        //        logDebug("\(item)创建一个cell")
        /// ZJaDe: tableView弱引用
        self._tableView = tableView
        return cell
    }
    func willAppear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        cell.contentItem = self
        self.willAppear()
        //        logDebug("\(item)将要显示")
    }
    func didDisappear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        self.didDisappear()
        cell.contentItem = nil
    }
}
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
