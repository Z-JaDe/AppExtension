//
//  TableItemModel.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class TableItemModel: ListItemModel {
    // MARK: - cell
    public weak var bufferPool: BufferPool?

    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicTableItemCell? {
        didSet {
            guard let cell = _weakContentCell else {
                return
            }
            cell.isEnabled = self.isEnabled
            cell.isSelected = self.isSelected
            cell.didLayoutSubviewsClosure = {[weak self] _ in
                self?.updateHeight()
            }
        }
    }
    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet {
            if getCell()?.isSelected != isSelected {
                getCell()?.isSelected = self.isSelected
            }
        }
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet {
            if getCell()?.isEnabled != isEnabled {
                getCell()?.isEnabled = self.isEnabled
            }
        }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        getCell()?.refreshEnabledState(isEnabled)
    }
}
extension TableItemModel: CellSelectedStateDesignable {
    public func didSelectItem() {
        getCell()?.didSelectItem()
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
        if cell.isTempCell == false {
            cleanCellReference()
        }
    }
}
extension TableItemModel: TableCellConfigProtocol {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell: InternalTableViewCell = _createCell(in: tableView, for: indexPath, InternalTableViewCell.reuseIdentifier) as! InternalTableViewCell
        //        logDebug("\(item)创建一个cell")
        /// ZJaDe: 初始化cell，并且cell持有tableView弱引用
        cell.tempContentItem = createCellIfNil()
        return cell
    }
    func willAppear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        cell.contentItem = cell.tempContentItem
        _weakContentCell?.willAppear()
    }
    func shouldHighlight() -> Bool {
        getCell()?.shouldHighlight() ?? true
    }
}
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
