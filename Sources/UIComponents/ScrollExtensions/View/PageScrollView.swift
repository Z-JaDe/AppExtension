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
public class PageScrollView<CellView>: MultipleItemScrollView<CellView> where CellView: UIView {
    public var cacheCells: Set<CellView> = Set()
    public var visibleCells: Set<CellView> = Set()
    /// ZJaDe: 布局
    public override func layoutAllCells() {
        layoutCellsSize(self.layoutCells, self.length)
        layoutCellsOrigin(self.layoutCells, self.layoutCells.first?.leading ?? 0)
    }
    // MARK: -
    /// ZJaDe: 根据offSet查找cell
    open override func getCell(_ offSet: CGFloat) -> CellView? {
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
    func removeLast() -> CellView? {
        guard let last = layoutCells.last?.view else {
            return nil
        }
        remove(last)
        return last
    }
    /// ZJaDe: 移除第一个
    func removeFirst() -> CellView? {
        guard let first = layoutCells.first?.view else {
            return nil
        }
        remove(first)
        return first
    }
    /// ZJaDe: 移除一个cell
    func remove(_ cell: CellView) {
        removeLayoutCell(with: cell)
        self.visibleCells.remove(cell)
        self.cacheCells.insert(cell)
    }
}
extension PageScrollView {
    /// ZJaDe: cell快出现时 配置数据
    func add(_ cell: CellView, offSet: CGFloat, isToRight: Bool) {
        if isToRight {
            self.append(cell, origin: offSet)
        } else {
            self.insertFirst(cell, origin: offSet)
        }
    }
    /// ZJaDe: 左边插入一个cell
    private func insertFirst(_ cell: CellView, origin: CGFloat) {
        let layoutCell = createLayoutCell(cell)
        insert(layoutCell: layoutCell, at: 0)
        self.visibleCells.insert(cell)
        // ZJaDe: layout
        layoutCellsSize([layoutCell], self.length)
        layoutCellsOrigin([layoutCell], origin)
    }
    /// ZJaDe: 右边插入一个cell
    private func append(_ cell: CellView, origin: CGFloat) {
        let layoutCell = createLayoutCell(cell)
        append(layoutCell: layoutCell)
        self.visibleCells.insert(cell)
        // ZJaDe: layout
        layoutCellsSize([layoutCell], self.length)
        layoutCellsOrigin([layoutCell], origin)
    }
}
