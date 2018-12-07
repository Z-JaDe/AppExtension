//
//  StaticTableItemCell.swift
//  SNKit_ZJMax
//
//  Created by 郑军铎 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class StaticTableItemCell: TableItemCell, AdapterItemType {

    open var canSelected: Bool = false
    public func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        closure(self.canSelected)
    }

    private var _indexPath: IndexPath?
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
        let cell = _createCell(in: tableView, for: indexPath)
        //        let item = self.cell()
        //        logDebug("\(item)创建一个cell")
        /// ZJaDe: tableView弱引用
        self._tableView = tableView
        return cell
    }
    public func willAppear(in cell: UITableViewCell) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        cell.contentItem = self
        self.willAppear()
        //        logDebug("\(item)将要显示")
    }
    public func didDisappear(in cell: UITableViewCell) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        self.didDisappear()
        cell.contentItem = nil
    }
    public func createCell(isTemp: Bool) -> TableItemCell {
        return self
    }
    public func recycleCell(_ cell: TableItemCell) {}
    public func getCell() -> TableItemCell? {
        return self
    }
}
extension StaticTableItemCell: TableCellHeightProtocol {
    public var indexPath: IndexPath? {
        return _indexPath
    }
    func setNewIndexPath(_ newValue: IndexPath) {
        _indexPath = newValue
    }
    public func updateHeight(_ closure: (() -> Void)? = nil) {
        self.updateHeight(self, closure)
    }
}
