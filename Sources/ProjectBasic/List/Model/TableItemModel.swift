//
//  TableItemModel.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/8/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class TableItemModel: ListItemModel {
    // MARK: - cell
    public weak var bufferPool: BufferPool?

    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicTableItemCell?
    var _contentCell: DynamicTableItemCell? {
        didSet {
            guard let cell = _contentCell else {
                return
            }
            cell.isEnabled = self.isEnabled
            cell.isSelected = self.isSelected
            cell.didLayoutSubviewsClosure = {[weak self] (cell) -> Void in
                self?.updateHeight()
            }
        }
    }
    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { getCell()?.isSelected = self.isSelected }
    }
    public var canSelected: Bool = false
    open func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        if let cell = getCell() {
            cell.checkCanSelected({ (isCanSelected) in
                closure(isCanSelected ?? self.canSelected)
            })
        } else {
            closure(self.canSelected)
        }
    }
    open func didSelectItem() {
        getCell()?.didSelectItem()
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet { getCell()?.isEnabled = self.isEnabled }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        getCell()?.refreshEnabledState(isEnabled)
    }
}
extension DynamicTableItemCell: DynamicModelCell {}
extension TableItemModel: CreateCellUseModel {
    /// 这方法返回的是contentCell, 实际内容的cell
    func createCell(isTemp: Bool) -> DynamicTableItemCell {
        let cellName = self.getCellClsName()
        // 如果缓存池有, 就pop出来使用
        let result: DynamicTableItemCell = bufferPool.createView(cellName)
        result.isTempCell = isTemp
        return result
    }
    func recycleCell(_ cell: DynamicTableItemCell) {
        bufferPool?.push(cell)
        cleanCellReference()
    }
}
extension TableItemModel: TableCellConfigProtocol {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell: InternalTableViewCell = _createCell(in: tableView, for: indexPath, InternalTableViewCell.reuseIdentifier) as! InternalTableViewCell
        //        logDebug("\(item)创建一个cell")
        /// ZJaDe: 初始化cell，并且cell持有tableView弱引用
        createCellIfNil()
        self.getCell()!._tableView = tableView
        return cell
    }
    func willAppear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        // ZJaDe: InternalTableViewCell对cell引用
        let item = _contentCell!
        cell.contentItem = item
        cellDidInHierarchy()
        item.willAppear()
        //        logDebug("\(item)将要显示")
    }
    func didDisappear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        let item = getCell()
        item?.didDisappear()
        // ZJaDe: 释放InternalTableViewCell对cell的持有
        cell.contentItem = nil
        // 将contentCell加入到缓存池
        if let item = item {
            recycleCell(item)
        }
    }
    func shouldHighlight() -> Bool {
        getCell()?.shouldHighlight() ?? true
    }
}
extension TableItemModel: TableCellHeightProtocol {
    public func updateHeight(_ closure: (() -> Void)? = nil) {
        self.getCell()?.updateHeight(self, closure)
    }
    public func setNeedResetCellHeight() {
        _setNeedResetCellHeight()
    }

    /// ZJaDe: 计算高度
    public func calculateCellHeight(_ tableView: UITableView, wait: Bool) {
        let tableViewWidth = tableView.bounds.size.width
        if tableViewWidth <= 0 { return }
        /*************** 获取tempCell，并赋值 ***************/
        let item = self.createCell(isTemp: true)
        item.setModel(self)
        /*************** 计算高度 ***************/
        let itemCellWidth = item.getItemCellWidth(tableView)
        let cellHeight = item.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight + item.insetVerticalSpace())
        /*************** cell回收 ***************/
        self.recycleCell(item)
    }
}
