//
//  MultipleSelectionProtocol.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/11.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol MultipleSelectionProtocol: AssociatedObjectProtocol {
    associatedtype SelectItemType
    /// ZJaDe: 找到item对应的下标
    func index(_ item: SelectItemType) -> Int?
    /// ZJaDe: 检查是否可以被选中
    func checkCanSelected(_ item: SelectItemType, _ closure: @escaping (Bool) -> Void)
    /// ZJaDe: 更新item选中状态
    func updateSelectState(_ item: SelectItemType, _ isSelected: Bool)
    /// ZJaDe: 主动更改item的选中状态
    func changeSelectState(_ isSelected: Bool, _ item: SelectItemType)
}
private var selectedItemArrayKey: UInt8 = 0
private var selectedItemArrayChangedKey: UInt8 = 0
private var maxSelectedCountKey: UInt8 = 0
private var checkCanSelectedClosureKey: UInt8 = 0
public extension MultipleSelectionProtocol {
    /// ZJaDe: 存储选中的cell
    private var selectedItemArray: [SelectItemType] {
        get {return associatedObject(&selectedItemArrayKey, createIfNeed: [])}
        set {setAssociatedObject(&selectedItemArrayKey, newValue)}
    }
    /// ZJaDe: 选中的cell改变时
    var selectedItemArrayChanged: CallBack<[SelectItemType]>? {
        get {return associatedObject(&selectedItemArrayChangedKey)}
        set {setAssociatedObject(&selectedItemArrayChangedKey, newValue)}
    }
    /// ZJaDe: 最大选中的item数量，小于0代表不限制，0代表不可选中
    var maxSelectedCount: Int {
        get {return associatedObject(&maxSelectedCountKey) ?? 0}
        set {setAssociatedObject(&maxSelectedCountKey, newValue)}
    }
    /// ZJaDe: 检查是否可以被选中 返回一个闭包
    var checkCanSelectedClosure: ((SelectItemType, @escaping (Bool) -> Void) -> Void)? {
        get {return associatedObject(&checkCanSelectedClosureKey)}
        set {setAssociatedObject(&checkCanSelectedClosureKey, newValue)}
    }
}
// MARK: -
extension MultipleSelectionProtocol {
    /// ZJaDe: 当item未选中时做一些处理 默认不能主动调用
    public func whenItemUnSelected(_ item: SelectItemType) {
        if let index = self.index(item) {
            self.selectedItemArray.remove(at: index)
        }
        updateSelectState(item, false)
    }
    /// ZJaDe: 当item选中时做一些处理 默认不能主动调用
    public func whenItemSelected(_ item: SelectItemType) {
        if self.index(item) == nil {
            self.selectedItemArray.append(item)
        }
        updateSelectState(item, true)
        if maxSelectedCount > 0 {
            while self.selectedItemArray.count > maxSelectedCount {
                let first = self.selectedItemArray.first!
                changeSelectState(false, first)
            }
        }
    }
}
extension MultipleSelectionProtocol where SelectItemType: Equatable {
    public func index(_ item: SelectItemType) -> Int? {
        return self.selectedItemArray.index(of: item)
    }
}
// MARK: - UpdateSelectState
extension MultipleSelectionProtocol where SelectItemType: SelectedStateDesignable {
    public func updateSelectState(_ item: SelectItemType, _ isSelected: Bool) {
        var item = item
        item.isSelected = isSelected
        logDebug("\(self.selectedItemArray)")
        self.selectedItemArrayChanged?(self.selectedItemArray)
    }
}
// MARK: - CanSelected
extension MultipleSelectionProtocol {
    private func checkCanSelected() -> Bool {
        guard maxSelectedCount < 0 else {
            return true
        }
        return maxSelectedCount > 0
    }
    public func checkCanSelected(_ item: SelectItemType, _ closure: @escaping (Bool) -> Void) {
        guard checkCanSelected() else {
            closure(false)
            return
        }
        if let checkCanSelectedClosure = self.checkCanSelectedClosure {
            checkCanSelectedClosure(item, closure)
            return
        }
        closure(true)
    }
}
extension MultipleSelectionProtocol where SelectItemType: CanSelectedStateDesignable {
    public func checkCanSelected(_ item: SelectItemType, _ closure: @escaping (Bool) -> Void) {
        guard checkCanSelected() else {
            closure(false)
            return
        }
        if let checkCanSelectedClosure = self.checkCanSelectedClosure {
            checkCanSelectedClosure(item, closure)
            return
        }
        item.checkCanSelected(closure)
    }
}
