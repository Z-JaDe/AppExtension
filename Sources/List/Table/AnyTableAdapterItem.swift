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
        & SelectedStateDesignable
    //理论上 value应该可以写成let 但是编译器有问题
    public private(set) var value: ValueType
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
extension AnyTableAdapterItem: SelectedStateDesignable {
    public var isSelected: Bool {
        get { return value.isSelected }
        set { value.isSelected = newValue }
    }
}
