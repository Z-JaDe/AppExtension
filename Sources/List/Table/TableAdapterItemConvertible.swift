//
//  TableAdapterItemConvertible.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public struct TableAdapterItemConvertible {
    public typealias ValueType = AnyObject
        & HiddenStateDesignable
        & SelectedStateDesignable & CanSelectedStateDesignable
    public var value: ValueType
    public init(_ value: ValueType) {
        self.value = value
    }
}
// MARK: - HiddenStateDesignable
extension TableAdapterItemConvertible: HiddenStateDesignable {
    public var isHidden: Bool {
        get { return value.isHidden }
        set { value.isHidden = newValue }
    }
}
// MARK: - CanSelectedStateDesignable & SelectedStateDesignable
extension TableAdapterItemConvertible: SelectedStateDesignable & CanSelectedStateDesignable {
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
