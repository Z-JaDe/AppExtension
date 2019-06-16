//
//  SegmentScrollView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

extension SegmentScrollView.CellLength: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    public init(integerLiteral value: Int) {
        self = .length(value.toCGFloat)
    }
    public init(floatLiteral value: Double) {
        self = .length(value.toCGFloat)
    }
}
public class SegmentScrollView<CellView>: MultipleItemScrollView<CellView>, TotalCountProtocol where CellView: UIView {
    public enum CellLength {
        /// ZJaDe: 最多显示几个，少的时候平铺，多的时候滑动
        case showMaxCount(Int)
        /// ZJaDe: 默认显示几个，根据个数和segment长度计算固定长度
        case showCount(Int)
        /// ZJaDe: 固定长度
        case length(CGFloat)
        /// ZJaDe: 用item的自有长度
        case auto
    }
    public var itemLength: CellLength = .auto {
        didSet {setNeedsLayoutCells()}
    }
    public enum AutoScrollItemType {
        case center
        case edge
        case none
    }
    public var autoScrollItem: AutoScrollItemType = .edge
    /// ZJaDe: TotalCountProtocol
    open var totalCount: Int {
        return self.layoutCells.count
    }

    /// ZJaDe: 布局
    public override func layoutAllCells() {
        super.layoutAllCells()
        layoutCellsSize(self.layoutCells)
        let length = layoutCellsOrigin(self.layoutCells, 0)
        self.contentLength = length
        if let firstCell = self.layoutCells.first, self.viewHeadOffset() < firstCell.leading {
            self.scrollTo(offSet: firstCell.leading, animated: false)
        } else if let lastCell = self.layoutCells.last, self.viewTailOffset() > lastCell.trailing && self.contentLength > self.length {
            self.scrollTo(offSet: lastCell.trailing - self.length, animated: false)
        }
    }
    public func layoutCellsSize(_ cellArr: [LayoutItemType]) {
        layoutCellsSize(cellArr, self.getCellLength(), self.length2)
    }
    /// ZJaDe: 返回itemView宽度或者长度
    internal func getCellLength() -> CGFloat? {
        switch self.itemLength {
        case .showMaxCount(let maxCount):
            let count = maxCount.clamp(min: 1, max: self.totalCount)
            return self.length / count.toCGFloat
        case .showCount(var count):
            count = max(1, count)
            return self.length / count.toCGFloat
        case .length(let length):
            return length
        case .auto:
            return nil
        }
    }

    /// ZJaDe: 根据offSet查找cell
    public override func getCell(_ offSet: CGFloat) -> CellView? {
        let index = self.realProgress(offSet: offSet, length: self.length).toInt
        return self.itemArr[self.realIndex(index)]
    }
}

extension SegmentScrollView {
    /// ZJaDe: 滚动到指定的cell
    public func scrollTo(_ cell: CellView) {
        guard self.layoutState == .end else {
            return
        }
        let layoutCell = createLayoutCell(cell)
        switch self.autoScrollItem {
        case .edge:
            let head = layoutCell.leading
            let tail = layoutCell.trailing
            let offSet = viewHeadOffset()
            if offSet > head {
                self.scrollTo(offSet: head)
            } else if offSet + self.length < tail {
                self.scrollTo(offSet: tail - self.length)
            }
        case .center:
            let cellCenter = layoutCell.leading + layoutCell.length / 2
            var offset: CGFloat = cellCenter - self.length / 2
            offset = offset.clamp(min: 0, max: self.contentLength - self.length)
            self.scrollTo(offSet: offset)
        case .none:
            break
        }
    }

}
extension SegmentScrollView {
    /// ZJaDe: 重新设置 _cellArr
    public var itemArr: [CellView] {
        get {return layoutCells.map {$0.view}}
        set {
            resetLayoutCells(newValue.map {createLayoutCell($0)})
            // ZJaDe: layout
            setNeedsLayoutCells()
        }
    }
    // MARK: - 添加或者移除itemView 默认都是更新右边的cells的位置
    /// ZJaDe: 插入一个itemView
    public func insertAndUpdate(_ cell: CellView, at index: Int) {
        guard layoutCells.indexCanInsert(index) else { return }
        let layoutCell = createLayoutCell(cell)
        insert(layoutCell: layoutCell, at: index)
        // ZJaDe: layout
        layoutCellsSize([layoutCell])
        let needUpdateOriginCells = Array(self.layoutCells.suffix(from: index))
        let startOrigin: CGFloat
        if self.layoutCells.count > 1 {
            startOrigin = index > 0 ? self.layoutCells[index - 1].trailing : self.layoutCells[index].leading - layoutCell.length
        } else {
            startOrigin = 0
        }
        layoutCellsOrigin(needUpdateOriginCells, startOrigin)

    }
    /// ZJaDe: 移除一个itemView
    public func removeAndUpdate(_ cell: CellView) {
        guard let index = self.layoutCells.firstIndex(where: {$0.view == cell}) else { return }
        removeAndUpdate(at: index)
    }
    public func removeAndUpdate(at index: Int) {
        guard layoutCells.indexCanBound(index) else { return }
        removeLayoutCell(at: index)
        // ZJaDe: layout
        if  layoutCells.isEmpty == false {
            let needUpdateOriginCells = Array(self.layoutCells.suffix(from: index))
            let startOrigin: CGFloat = index > 0 ? self.layoutCells[index - 1].trailing : 0
            layoutCellsOrigin(needUpdateOriginCells, startOrigin)
        }
    }
}
