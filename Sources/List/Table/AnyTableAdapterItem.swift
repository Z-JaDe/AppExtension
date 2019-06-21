//
//  AnyTableAdapterItem.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public struct AnyTableAdapterItem {
    public typealias ValueType = AnyObject
        & HiddenStateDesignable
        & CellSelectedStateDesignable
        & CreateTableCellrotocol
    public var value: ValueType
    public init(_ value: ValueType) {
        self.value = value
    }
}
// MARK: - HiddenStateDesignable
extension AnyTableAdapterItem: HiddenStateDesignable {
    public var isHidden: Bool {
        get { return value.isHidden }
        set { value.isHidden = newValue }
    }
}
// MARK: - SelectedStateDesignable
extension AnyTableAdapterItem: CellSelectedStateDesignable {
    public var isSelected: Bool {
        get { return value.isSelected }
        set { value.isSelected = newValue }
    }
    public func didSelectItem() {
        value.didSelectItem()
    }
}
// MARK: - CreateTableCellrotocol
extension AnyTableAdapterItem: CreateTableCellrotocol {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return self.value.createCell(in: tableView, for: indexPath)
    }
}
