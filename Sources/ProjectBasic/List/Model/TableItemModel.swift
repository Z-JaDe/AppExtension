//
//  TableItemModel.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/8/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension AnyTableAdapterItem {
    public var model: TableItemModel? {
        return self.value as? TableItemModel
    }
    public static func model(_ value: TableItemModel) -> AnyTableAdapterItem {
        return AnyTableAdapterItem(value)
    }
}
extension TableItemModel: TableAdapterItemDiffable {
    public func isEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let source = source.model else {
            return false
        }
        return self == source
    }
    public func isContentEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let source = source.model else {
            return false
        }
        return self.isContentEqual(to: source)
    }
}

open class TableItemModel: ListItemModel {

    open func getCellClsName() -> String {
        return self.cellFullName
    }
    // MARK: - cell
    public weak var bufferPool: BufferPool?

    /// ZJaDe: 手动释放
    private var _contentCell: DynamicTableItemCell? {
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
    open override var isEnabled: Bool? {
        didSet { _contentCell?.isEnabled = self.isEnabled }
    }
    public override var isSelected: Bool {
        didSet { _contentCell?.isSelected = self.isSelected }
    }
    open override func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        if let cell = _contentCell {
            cell.checkCanSelected({ (isCanSelected) in
                if let result = isCanSelected {
                    closure(result)
                } else {
                    super.checkCanSelected(closure)
                }
            })
        } else {
            super.checkCanSelected(closure)
        }
    }
    public override func didSelectItem() {
        _contentCell?.didSelectItem()
    }
    open override func updateEnabledState(_ isEnabled: Bool) {
        _contentCell?.refreshEnabledState(isEnabled)
    }
}
extension TableItemModel {
    /// 这方法返回的是contentCell, 实际内容的cell
    func createCell(isTemp: Bool) -> TableItemCell {
        let result: DynamicTableItemCell
        let cellName = self.getCellClsName()
        // 如果缓存池有, 就pop出来使用
        if let cell: DynamicTableItemCell = bufferPool?.pop(cellName) {
            result = cell
        } else {
            // 如果缓存池没有这个类型的cell
            // swiftlint:disable force_cast
            let cls: DynamicTableItemCell.Type = NSClassFromString(cellName) as! DynamicTableItemCell.Type
            result = cls.init()
        }
        result.isTempCell = isTemp
        result._model = self
        return result
    }
    func recycleCell(_ cell: TableItemCell) {
        bufferPool?.push(cell)
    }
    func getCell() -> TableItemCell? {
        return _contentCell
    }
    private func createCellIfNil() {
        guard _contentCell == nil else {
            return
        }
        let cell = createCell(isTemp: false)
        _contentCell = cell as? DynamicTableItemCell
    }
    func cleanReference() {
        // ZJaDe: 释放model对_contentCell的持有
        _contentCell?._model = nil
        _contentCell = nil
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
        cell.contentItem = _contentCell
        _contentCell?.willAppear()
        if _contentCell == nil {
            logError("cell为空，需检查错误")
        }
        //        logDebug("\(item)将要显示")
    }
    func didDisappear(in cell: UITableViewCell) {
        guard let cell = cell as? InternalTableViewCell else {
            return
        }
        _contentCell?.didDisappear()
        // ZJaDe: 释放InternalTableViewCell对_contentCell的持有
        cell.contentItem = nil
        // 将contentCell加入到缓存池
        if let item = _contentCell {
            recycleCell(item)
        }
        cleanReference()
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
        let item: TableItemCell = self.createCell(isTemp: true)
        /*************** 计算高度 ***************/
        let itemCellWidth = item.getItemCellWidth(tableView)
        let cellHeight = item.layoutHeight(itemCellWidth)
        self.changeTempCellHeight(cellHeight + item.insetVerticalSpace())
        /*************** cell回收 ***************/
        self.recycleCell(item)
    }

}
