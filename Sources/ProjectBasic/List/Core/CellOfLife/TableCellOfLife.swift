//
//  TableCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
/**
 自己实现复用cell，willAppear和didDisappear需要代理里面调用，UITableAdapter默认已经调用
 */
public protocol TableCellOfLife {
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func cellWillAppear(in cell: UITableViewCell)
//    func cellDidDisAppear() ///cell消失时 有可能数据源已经丢失

}
extension TableCellOfLife {
    func _createCell<T: UITableViewCell>(in tableView: UITableView, for indexPath: IndexPath, _ reuseIdentifier: String) -> T {
        tableView.register(T.self, forCellReuseIdentifier: reuseIdentifier)
        // swiftlint:disable force_cast
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}
// MARK: -
extension TableItemModel: TableCellOfLife {
    typealias DynamicCell = DynamicTableItemCell
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = cellInfo.reuseIdentifier
        let cell: InternalTableViewCell = _createCell(in: tableView, for: indexPath, reuseIdentifier)
        guard let cls = NSClassFromString(cellInfo.clsName) as? DynamicCell.Type else {
            assertionFailure("Cell需要继承自DynamicCell")
            return UITableViewCell()
        }
        let itemCell: DynamicCell
        if let contentItem = cell.contentItem {
            if type(of: contentItem) == cls {
                itemCell = contentItem as! DynamicCell
            } else {
                assertionFailure("\(cellInfo.reuseIdentifier)注册了其他Cell?")
                itemCell = cls.init()
                cell.contentItem = itemCell
            }
        } else {
            itemCell = cls.init()
            cell.contentItem = itemCell
        }
        return cell
    }
    public func cellWillAppear(in cell: UITableViewCell) {
        guard let _cell = (cell as! InternalTableViewCell).contentItem as? DynamicCell else {
            assertionFailure("没获取到DynamicCell")
            return
        }
        _weakContentCell = _cell
        _cell.isEnabled = self.isEnabled
        _cell.isSelected = self.isSelected
        _cell.didLayoutSubviewsClosure = {[weak self] _ in
            self?.updateHeight()
        }
        _cell.setModel(self)
        _cell.willAppear()
        _cell.changeCellStateToDidAppear()
    }
    public func cellShouldHighlight() -> Bool {
        getCell()?.shouldHighlight() ?? true
    }
    public func cellDidSelected() {
        getCell()?.didSelectedItem()
    }
    public func cellDidDeselected() {
    }
}
private var tempItemCellsKey: UInt8 = 0
extension UITableView {
    fileprivate var tempItemCells: [String: TableItemModel.DynamicCell] {
        get { associatedObject(&tempItemCellsKey) ?? [:] }
        set { setAssociatedObject(&tempItemCellsKey, newValue) }
    }
}
extension TableItemModel {
    func getTempCell(tableView: UITableView) -> DynamicCell {
        let reuseIdentifier = cellInfo.reuseIdentifier
        if let cell = tableView.tempItemCells[reuseIdentifier] {
            return cell
        } else {
            guard let cls = NSClassFromString(cellInfo.clsName) as? DynamicCell.Type else {
                assertionFailure("Cell需要继承自DynamicCell")
                return DynamicCell()
            }
            let cell = cls.init()
            cell.isTempCell = true
            tableView.tempItemCells[reuseIdentifier] = cell
            return cell
        }
    }
}

// MARK: -
extension StaticTableItemCell: TableCellOfLife {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = classFullName
        let cell: InternalTableViewCell = _createCell(in: tableView, for: indexPath, reuseIdentifier)
        if let contentItem = cell.contentItem {
            if contentItem == self {
            } else {
                assertionFailure("\(self)注册了其他Cell?")
                cell.contentItem = self
            }
        } else {
            cell.contentItem = self
        }
        return cell
    }
    public func cellWillAppear(in cell: UITableViewCell) {
        self.willAppear()
        self.changeCellStateToDidAppear()
    }
    public func cellShouldHighlight() -> Bool {
        self.shouldHighlight()
    }
    public func cellDidSelected() {
        self.didSelectedItem()
    }
    public func cellDidDeselected() {
    }
}
// MARK: -
public protocol CellSelectedStateDesignable: AnyObject {
    func didSelectedItem()
}
extension TableCellModel: TableCellOfLife {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = cellInfo.reuseIdentifier
        return _createCell(in: tableView, for: indexPath, reuseIdentifier)
    }
    public func cellWillAppear(in cell: UITableViewCell) {
        _weakCell = cell
        if var cell = cell as? EnabledStateDesignable {
            cell.isEnabled = self.isEnabled
        }
        cell.isSelected = self.isSelected
        bindingCellData(cell)
    }
    public func cellShouldHighlight() -> Bool {
        true
    }
    public func cellDidSelected() {
        (getCell() as? CellSelectedStateDesignable)?.didSelectedItem()
    }
    public func cellDidDeselected() {
    }
}
private var tempCellsKey: UInt8 = 0
extension UITableView {
    fileprivate var tempCells: [String: UITableViewCell] {
        get { associatedObject(&tempCellsKey) ?? [:] }
        set { setAssociatedObject(&tempCellsKey, newValue) }
    }
}
extension TableCellModel {
    func getTempCell(tableView: UITableView) -> UITableViewCell {
        let reuseIdentifier = cellInfo.reuseIdentifier
        if let cell = tableView.tempCells[reuseIdentifier] {
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)!
            tableView.tempCells[reuseIdentifier] = cell
            return cell
        }
    }
}
