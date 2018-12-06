//
//  TableItemModel.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/8/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class TableItemModel: ListItemModel, TableCellConfigProtocol {

    open func getCellClsName() -> String {
        return self.cellFullName
    }
    // MARK: - cell
    public weak var bufferPool: BufferPool?
    /// 这方法返回的是contentCell, 实际内容的cell
    public func createCell(isTemp: Bool) -> TableItemCell {
        let result: DynamicTableItemCell
        let cellName = self.getCellClsName()
        // 如果缓存池有, 就pop出来使用, 这个缓存池是单例, 针对所有的tableView
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
    public func getCell() -> TableItemCell? {
        return _cell
    }
    private func createCellIfNil() {
        if _cell == nil {
            let cell = createCell(isTemp: false)
            _cell = cell as? DynamicTableItemCell
        }
    }
    // MARK: -
    /// ZJaDe: 手动释放
    private var _cell: DynamicTableItemCell? {
        didSet {
            guard let _cell = _cell else {
                return
            }
            _cell.isEnabled = self.isEnabled
            _cell.isSelected = self.isSelected
            _cell.didLayoutSubviewsClosure = {[weak self] (cell) -> Void in
                guard let `self` = self else { return }
                guard let cell = cell as? TableItemCell else {return}
                guard let cellState = try? cell.cellState.value() else {return}
                switch cellState {
                case .didAppear:
                    cell.updateHeight(self, {})
                case .prepare, .willAppear, .didDisappear: break
                }
            }
        }
    }
    open override var isEnabled: Bool? {
        didSet {
            _cell?.isEnabled = self.isEnabled
        }
    }
    public override var isSelected: Bool {
        didSet {
            _cell?.isSelected = self.isSelected
        }
    }
    open override func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        if let cell = _cell {
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
        _cell?.didSelectItem()
    }
    open override func updateEnabledState(_ isEnabled: Bool) {
        _cell?.refreshEnabledState(isEnabled)
    }
    // MARK: -
    public private(set) var tempCellHeight: CGFloat = 0
    public func changeTempCellHeight(_ newValue: CGFloat) {
        self.tempCellHeight = newValue
    }

    public func createCell(in tableView: UITableView) -> UITableViewCell {
        let reuseIdentifier: String = SNTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? SNTableViewCell
        //        logDebug("\(item)创建一个cell")
        /// ZJaDe: 初始化_cell，并且_cell持有tableView弱引用
        createCellIfNil()
        self.getCell()!._tableView = tableView
        return cell!
    }
    public func willAppear(in cell: UITableViewCell) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        // ZJaDe: SNTableViewCell对_cell引用
        cell.contentItem = _cell
        _cell?.willAppear()
        if _cell == nil {
            logError("cell为空，需检查错误")
        }
        //        logDebug("\(item)将要显示")
    }
    public func didDisappear(in cell: UITableViewCell) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        _cell?.didDisappear()
        // ZJaDe: 释放SNTableViewCell对_cell的持有
        cell.contentItem = nil
        //讲contentCell加入到缓存池
        if let item = _cell {
            bufferPool?.push(item)
        }
        cleanReference()
    }
    func cleanReference() {
        // ZJaDe: 释放model对_cell的持有
        _cell?._model = nil
        _cell = nil
    }
}
