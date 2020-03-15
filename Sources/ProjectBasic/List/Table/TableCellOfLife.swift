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
protocol TableCellOfLife {
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func cellWillAppear(in cell: UITableViewCell)
    func cellDidDisAppear()
    func shouldHighlight() -> Bool
}
extension TableCellOfLife {
    @inline(__always)
    func _createCell<T: UITableViewCell>(in tableView: UITableView, for indexPath: IndexPath, _ reuseIdentifier: String) -> T {
        tableView.register(T.self, forCellReuseIdentifier: reuseIdentifier)
        // swiftlint:disable force_cast
        return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}
// MARK: -
extension TableItemModel: TableCellOfLife {
    typealias DynamicCell = DynamicTableItemCell
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
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
    func cellWillAppear(in cell: UITableViewCell) {
        guard let _cell = (cell as! InternalTableViewCell).contentItem as? DynamicCell else {
            assertionFailure("没获取到DynamicCell")
            return
        }
        _weakContentCell = _cell
        _cell.setModel(self)
        _cell.willAppear()
        _cell.changeCellStateToDidAppear()
    }
    func cellDidDisAppear() {
        guard let _cell = getCell() else {
            assertionFailure("DynamicCell提前释放了？")
            return
        }
        _cell.didDisappear()
        _cell.setModel(nil)
        _weakContentCell = nil
    }
    func shouldHighlight() -> Bool {
        getCell()?.shouldHighlight() ?? true
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
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
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
    func cellWillAppear(in cell: UITableViewCell) {
        self.willAppear()
        self.changeCellStateToDidAppear()
    }
    func cellDidDisAppear() {
        self.didDisappear()
    }
}
// MARK: -
extension TableCellModel: TableCellOfLife {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = cellInfo.reuseIdentifier
        return _createCell(in: tableView, for: indexPath, reuseIdentifier)
    }
    func cellWillAppear(in cell: UITableViewCell) {
        self._weakCell = cell
        bindingCellData(cell)
    }
    func cellDidDisAppear() {
        self._weakCell = nil
    }
    func shouldHighlight() -> Bool {
        true
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