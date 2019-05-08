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
        & SelectedStateDesignable & CanSelectedStateDesignable
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
// MARK: - CanSelectedStateDesignable & SelectedStateDesignable
extension AnyTableAdapterItem: SelectedStateDesignable & CanSelectedStateDesignable {
    public func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        value.checkCanSelected(closure)
    }
    public func didSelectItem() {
        value.didSelectItem()
    }
    public var isSelected: Bool {
        get { return value.isSelected }
        set { value.isSelected = newValue }
    }
    public var canSelected: Bool {
        get { return value.canSelected }
        set { value.canSelected = newValue }
    }
}
// MARK: - CreateTableCellrotocol
extension AnyTableAdapterItem: CreateTableCellrotocol {
    public func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        return self.value.createCell(in: tableView, for: indexPath)
    }
}
