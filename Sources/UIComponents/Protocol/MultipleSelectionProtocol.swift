//
//  MultipleSelectionProtocol.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/11.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol MultipleSelectionProtocol: class {
    associatedtype SelectItemType
    typealias SelectedItemArrayType = [SelectItemType]
    /// ZJaDe: 存储选中的cell
    var selectedItemArray: SelectedItemArrayType {get set}
    /// ZJaDe: 找到item对应的下标
    func index(_ item: SelectItemType) -> Int?
    /// ZJaDe: 最大选中的item数量
    var maxSelectedCount: UInt? {get}
    /// ZJaDe: 检查是否可以被选中 返回一个闭包
    var checkCanSelectedClosure: ((SelectItemType, @escaping (Bool)->Void)->Void)? {get set}
    /// ZJaDe: 检查是否可以被选中
    func checkCanSelected(_ item: SelectItemType, _ closure: @escaping (Bool) -> Void)
    /// ZJaDe: 更新item选中状态
    func updateSelectState(_ item: SelectItemType, _ isSelected: Bool)
    /// ZJaDe: 主动更改将item的选中状态改成未选中状态
    func changeSelectState(_ isSelected: Bool, _ item: SelectItemType)
}
extension MultipleSelectionProtocol {
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
    private func checkCanSelected() -> Bool {
        guard let maxSelectedCount = self.maxSelectedCount else {
            return true
        }
        return maxSelectedCount > 0
    }
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
        if let maxCount = self.maxSelectedCount, maxCount > 0 {
            while self.selectedItemArray.count > maxCount {
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
    public func updateSelectState(_ item: SelectItemType, _ isSelected: Bool) {
        var item = item
        item.isSelected = isSelected
    }
}
