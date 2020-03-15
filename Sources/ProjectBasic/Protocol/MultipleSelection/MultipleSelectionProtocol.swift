//
//  MultipleSelectionProtocol.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/11.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol MultipleSelectionProtocol: AssociatedObjectProtocol {
    associatedtype SelectItemType: Equatable
    var maxSelectedCount: MaxSelectedCount {get set}
    /// ZJaDe: 更新item选中状态 默认不能主动调用
    func updateSelectState(_ item: inout SelectItemType, _ isSelected: Bool)
    /// ZJaDe: 主动更改item的选中状态
    func changeSelectState(_ isSelected: Bool, _ item: SelectItemType)
}
private var selectedItemArrayKey: UInt8 = 0
private var selectedItemArrayChangedKey: UInt8 = 0
private var maxSelectedCountKey: UInt8 = 0
public extension MultipleSelectionProtocol {
    /// ZJaDe: 存储选中的cell
    private(set) var selectedItemArray: [SelectItemType] {
        get { associatedObject(&selectedItemArrayKey, createIfNeed: []) }
        set { setAssociatedObject(&selectedItemArrayKey, newValue) }
    }
    /// ZJaDe: 选中的cell改变时
    var selectedItemArrayChanged: CallBackerVoid<[SelectItemType]> {
        associatedObject(&selectedItemArrayChangedKey, createIfNeed: CallBackerVoid<[SelectItemType]>())
    }
    /// ZJaDe: 最大选中的item数量
    var maxSelectedCount: MaxSelectedCount {
        // ZJaDe: 使用MaxSelectedCount不使用UInt?的原因是 associated没法区分nil和0，用-1区分又不太优雅
        get { associatedObject(&maxSelectedCountKey) ?? 0 }
        set { setAssociatedObject(&maxSelectedCountKey, newValue) }
    }
}
extension MultipleSelectionProtocol {
    @inline(__always)
    func index(_ item: SelectItemType) -> Int? {
        self.selectedItemArray.firstIndex(of: item)
    }
    /// Item选中状态更新时，更新selectedItemArray
    public func updateSelectedItemArrayWhenSelectStateChanged(_ item: SelectItemType, _ isSelected: Bool) {
        if let index = self.index(item) {
            if !isSelected {
                self.selectedItemArray.remove(at: index)
            }
        } else {
            if isSelected {
                self.selectedItemArray.append(item)
            }
        }
        logDebug("\(self.selectedItemArray)")
        self.selectedItemArrayChanged.call(self.selectedItemArray)
    }
}
// MARK: -
extension MultipleSelectionProtocol where SelectItemType: SelectedStateDesignable {
    func updateSelectState(_ item: inout SelectItemType, _ isSelected: Bool) {
        updateSelectedItemArrayWhenSelectStateChanged(item, isSelected)
    }
}
// MARK: -
extension MultipleSelectionProtocol {
    /// ZJaDe: 当item未选中时做一些处理 默认不能主动调用
    public func updateItemToUnSelected(_ item: inout SelectItemType) {
        // 单选时不可以不选中
        if maxSelectedCount == 1 && self.selectedItemArray.count == 1 {
            return
        }
        updateSelectState(&item, false)
    }
    /// ZJaDe: 当item选中时做一些处理 默认不能主动调用
    public func updateItemToSelected(_ item: inout SelectItemType) {
        updateSelectState(&item, true)
        // 选中时，取消选中第一个
        if let count = maxSelectedCount.count {
            while self.selectedItemArray.count > count, let first = self.selectedItemArray.first {
                changeSelectState(false, first)
            }
        }
    }
}
// MARK: -
extension MultipleSelectionProtocol {
    /// ZJaDe: 主动更改items的选中状态
    public func changeSelectState(_ isSelected: Bool, _ items: [SelectItemType]) {
        for item in items {
            self.changeSelectState(isSelected, item)
        }
    }
}
