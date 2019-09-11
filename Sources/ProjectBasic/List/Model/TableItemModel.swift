//
//  TableItemModel.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/8/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class TableItemModel: ListItemModel {

    open func getCellClsName() -> String {
        return self.cellFullName
    }
    // MARK: - cell
    public weak var bufferPool: BufferPool?

    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicTableItemCell?
    var _contentCell: DynamicTableItemCell? {
        didSet {
            guard let _contentCell = _contentCell else {
                return
            }
            _contentCell.isEnabled = self.isEnabled
            _contentCell.isSelected = self.isSelected
            _contentCell.didLayoutSubviewsClosure = {[weak self] (cell) -> Void in
                self?.updateHeight()
            }
        }
    }
    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { _contentCell?.isSelected = self.isSelected }
    }
    public var canSelected: Bool = false
    open func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        if let cell = _contentCell {
            cell.checkCanSelected({ (isCanSelected) in
                closure(isCanSelected ?? self.canSelected)
            })
        } else {
            closure(self.canSelected)
        }
    }
    open func didSelectItem() {
        _contentCell?.didSelectItem()
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet { _contentCell?.isEnabled = self.isEnabled }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        _contentCell?.refreshEnabledState(isEnabled)
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
        let cell = _createCell(in: tableView, for: indexPath)
        //        logDebug("\(item)创建一个cell")
        /// ZJaDe: 初始化_contentCell，并且_contentCell持有tableView弱引用
        createCellIfNil()
        self.getCell()!._tableView = tableView
        return cell
    }
    func willAppear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        // ZJaDe: InternalTableViewCell对_contentCell引用
        cell.contentItem = _contentCell!
        cellDidInHierarchy()
        _contentCell?.willAppear()
        //        logDebug("\(item)将要显示")
    }
    func didDisappear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        _contentCell?.didDisappear()
        let item = getCell()
        // ZJaDe: 释放InternalTableViewCell对_contentCell的持有
        cell.contentItem = nil
        // 将contentCell加入到缓存池
        if let item = item {
            recycleCell(item)
        }
    }
    func shouldHighlight() -> Bool {
        return getCell()?.shouldHighlight() ?? true
    }
}
extension TableItemModel: TableCellHeightProtocol {
    public func updateHeight(_ closure: (() -> Void)? = nil) {
        self._contentCell?.updateHeight(self, closure)
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
        item._model = self
        /*************** 计算高度 ***************/
        let itemCellWidth = item.getItemCellWidth(tableView)
        let cellHeight = item.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight + item.insetVerticalSpace())
        /*************** cell回收 ***************/
        self.recycleCell(item)
    }

}
