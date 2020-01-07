//
//  MultipleSelectionProtocol.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/11.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol MultipleSelectionProtocol: AssociatedObjectProtocol {
    associatedtype SelectItemType
    var maxSelectedCount: MaxSelectedCount {get set}
    /// ZJaDe: 找到item对应的下标
    func index(_ item: SelectItemType) -> Int?
    /// ZJaDe: 更新item选中状态
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
extension MultipleSelectionProtocol where SelectItemType: Equatable {
    public func index(_ item: SelectItemType) -> Int? {
        self.selectedItemArray.firstIndex(of: item)
    }
}
// MARK: - UpdateSelectState
extension MultipleSelectionProtocol where SelectItemType: SelectedStateDesignable {
    public func updateSelectState(_ item: inout SelectItemType, _ isSelected: Bool) {
        item.isSelected = isSelected
        logDebug("\(self.selectedItemArray)")
        self.selectedItemArrayChanged.call(self.selectedItemArray)
    }
}
// MARK: -
extension MultipleSelectionProtocol {
    /// ZJaDe: 当item未选中时做一些处理 默认不能主动调用
    public func whenItemUnSelected(_ item: inout SelectItemType) {
        if let index = self.index(item) {
            self.selectedItemArray.remove(at: index)
        }
        updateSelectState(&item, false)
    }
    /// ZJaDe: 当item选中时做一些处理 默认不能主动调用
    public func whenItemSelected(_ item: inout SelectItemType) {
        if self.index(item) == nil {
            self.selectedItemArray.append(item)
        }
        updateSelectState(&item, true)
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
