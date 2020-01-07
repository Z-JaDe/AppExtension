//
//  AnyTableAdapterItem.swift
//  ProjectBasic
//
//  Created by ZJaDe on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

// MARK: -
public struct AnyTableAdapterItem {
    public typealias ValueType = AnyObject
        & HiddenStateDesignable
        & SelectedStateDesignable
        & TableAdapterItemDiffable
    //理论上 value应该可以写成let 但是编译器有问题
    public private(set) var value: ValueType
    public init(_ value: ValueType) {
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
