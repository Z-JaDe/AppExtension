//
//  AnyTableAdapterItem.swift
//  ProjectBasic
//
//  Created by ZJaDe on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

// MARK: -
public typealias AnyTableAdapterItemValue = AnyObject & HiddenStateDesignable & SelectedStateDesignable & TableAdapterItemHashable
public struct AnyTableAdapterItem {
    public typealias Value = AnyTableAdapterItemValue
    public let value: Value
    public init(_ value: Value) {
        self.value = value
    }
}
extension AnyTableAdapterItem: HiddenStateDesignable {
    public var isHidden: Bool {
        get { value.isHidden }
        nonmutating set {
            var value = self.value
            value.isHidden = newValue
        }
    }
}
extension AnyTableAdapterItem: SelectedStateDesignable {
    public var isSelected: Bool {
        get { value.isSelected }
        nonmutating set {
            var value = self.value
            value.isSelected = newValue
        }
    }
}
