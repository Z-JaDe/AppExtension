//
//  PageScrollView.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/6/22.
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

    public enum CellSize {
        /// ZJaDe: 使用item的尺寸，适配scrollView大小
        case itemsFill
        /// ZJaDe: 给定scrollView大小，适配items大小
        case adapterItems
    }
    public var itemSize: CellSize = .adapterItems {
        didSet {setNeedsLayoutCells()}
    }
    /// ZJaDe: 布局
    public override func layoutAllCells() {
        layoutCellsSize(layoutCells)
        layoutCellsOrigin(self.layoutCells, self.layoutCells.first?.leading ?? 0)
    }
    public func layoutCellsSize(_ cellArr: [_LayoutItem]) {
        switch self.itemSize {
        case .itemsFill:
             layoutCellsSize(cellArr, self.length, nil)
        case .adapterItems:
            layoutCellsSize(cellArr, self.length, self.length2)
        }
    }
    // MARK: -
    /// ZJaDe: 根据offSet查找cell
    open override func getCell(_ offSet: CGFloat) -> CellView? {
        self.visibleCells.first { (cell) -> Bool in
            let segmentLayoutCell = self.createLayoutCell(cell)
            return segmentLayoutCell.leading <= offSet && segmentLayoutCell.trailing > offSet
        }
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
        layoutCellsSize([layoutCell])
        layoutCellsOrigin([layoutCell], origin)
    }
    /// ZJaDe: 右边插入一个cell
    private func append(_ cell: CellView, origin: CGFloat) {
        let layoutCell = createLayoutCell(cell)
        append(layoutCell: layoutCell)
        self.visibleCells.insert(cell)
        // ZJaDe: layout
        layoutCellsSize([layoutCell])
        layoutCellsOrigin([layoutCell], origin)
    }
}
