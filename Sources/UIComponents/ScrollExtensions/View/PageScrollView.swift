//
//  PageScrollView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
/** ZJaDe:
    这个类不会自动计算 items的位置和尺寸还有contentSize
    不会
 */
public class PageScrollView<ItemView>: MultipleItemScrollView<ItemView> where ItemView: UIView {
    public var cacheCells: Set<ItemView> = Set()
    public var visibleCells: Set<ItemView> = Set()
    /// ZJaDe: 布局
    public override func layoutAllCells() {
        layoutCellsSize(self._cellArr, self.length)
        layoutCellsOrigin(self._cellArr, self._cellArr.first?.leading ?? 0)
    }
    // MARK: -
    /// ZJaDe: 根据offSet查找cell
    open override func getCell(_ offSet: CGFloat) -> ItemView? {
        for cell in self.visibleCells {
            let segmentLayoutCell = self.createLayoutCell(cell)
            if segmentLayoutCell.leading <= offSet && segmentLayoutCell.trailing > offSet {
                return cell
            }
        }
        return nil
    }
}
extension PageScrollView {
    // MARK: 下面几个方法只移除但是不更新布局
    /// ZJaDe: 移除最后一个
    func removeLast() -> ItemView? {
        guard let last = _cellArr.last?.view else {
            return nil
        }
        remove(last)
        return last
    }
    /// ZJaDe: 移除第一个
    func removeFirst() -> ItemView? {
        guard let first = _cellArr.first?.view else {
            return nil
        }
        remove(first)
        return first
    }
    /// ZJaDe: 移除一个itemView
    func remove(_ itemView: ItemView) {
        itemView.removeFromSuperview()
        _cellArr.removeAll(where: {$0.view == itemView})
        removeItemViewFromSuperview(itemView)
        self.visibleCells.remove(itemView)
        self.cacheCells.insert(itemView)
    }
}
extension PageScrollView {
    /// ZJaDe: cell快出现时 配置数据
    func add(_ cell: ItemView, offSet: CGFloat, isToRight: Bool) {
        if isToRight {
            self.append(cell, originLocation: offSet)
        } else {
            self.insertFirst(cell, originLocation: offSet)
        }
    }
    /// ZJaDe: 左边插入一个itemView
    private func insertFirst(_ itemView: ItemView, originLocation: CGFloat) {
        let cell = createLayoutCell(itemView)

        _cellArr.insert(cell, at: 0)
        self.insertSubview(itemView, at: 0)
        self.visibleCells.insert(itemView)

        layoutCellsSize([cell], self.length)
        layoutCellsOrigin([cell], originLocation)
    }
    /// ZJaDe: 右边插入一个itemView
    private func append(_ itemView: ItemView, originLocation: CGFloat) {
        let cell = createLayoutCell(itemView)

        _cellArr.append(cell)
        self.addSubview(itemView)
        self.visibleCells.insert(itemView)

        layoutCellsSize([cell], self.length)
        layoutCellsOrigin([cell], originLocation)
    }
}
