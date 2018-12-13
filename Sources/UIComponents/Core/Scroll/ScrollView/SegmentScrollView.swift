//
//  SegmentScrollView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public class SegmentScrollView<ItemView>: MultipleItemScrollView<ItemView>, TotalCountProtocol where ItemView: UIView {

    public enum ItemViewLength {
        /// ZJaDe: 最多显示几个，少的时候平铺，多的时候滑动
        case showMaxCount(Int)
        /// ZJaDe: 默认显示几个
        case showCount(Int)
        /// ZJaDe: 固定长度
        case length(CGFloat)
        /// ZJaDe: 用item的自有长度
        case auto
    }
    public var itewLength: ItemViewLength = .auto {
        didSet {setNeedsLayoutCells()}
    }
    public enum AutoScrollItemType {
        case center
        case edge
    }
    public var autoScrollItem: AutoScrollItemType = .edge
    /// ZJaDe: TotalCountProtocol
    open var totalCount: Int {
        return self._cellArr.count
    }

    /// ZJaDe: 布局
    public override func layoutAllCells() {
        super.layoutAllCells()
        layoutCellsSize(self._cellArr, self.getCellLength())
        let length = layoutCellsOrigin(self._cellArr, 0)
        self.contentLength = length
        if let firstCell = self._cellArr.first, self.viewHeadOffset() < firstCell.leading {
            self.scrollTo(offSet: firstCell.leading, animated: false)
        } else if let lastCell = self._cellArr.last, self.viewTailOffset() > lastCell.trailing && self.contentLength > self.length {
            self.scrollTo(offSet: lastCell.trailing - self.length, animated: false)
        }
    }
    /// ZJaDe: 返回itemView宽度或者长度
    internal func getCellLength() -> CGFloat? {
        switch self.itewLength {
        case .showMaxCount(let maxCount):
            let count = maxCount.clamp(min: 1, max: self.totalCount)
            return self.length / count.toCGFloat
        case .showCount(var count):
            count = max(1, count)
            return self.length / count.toCGFloat
        case .length(let length):
            return length + self.itemSpace.space
        case .auto:
            return nil
        }
    }

    /// ZJaDe: 根据offSet查找cell
    public override func getCell(_ offSet: CGFloat) -> ItemView? {
        let index = self.realProgress(offSet: offSet, length: self.length).toInt
        return self.itemArr[self.realIndex(index)]
    }
}

extension SegmentScrollView {
    /// ZJaDe: 滚动到指定的cell
    public func scrollTo(_ item: ItemView) {
        let layoutCell = createLayoutCell(item)
        switch self.autoScrollItem {
        case .edge:
            let head = layoutCell.leading
            let tail = layoutCell.trailing
            let offSet = viewHeadOffset()
            if offSet > head {
                self.scrollTo(offSet: head)
            } else if offSet + self.length < tail {
                self.scrollTo(offSet: tail)
            }
        case .center:
            let cellCenter = layoutCell.leading + layoutCell.length / 2
            var offset: CGFloat = cellCenter - self.length / 2
            offset = offset.clamp(min: 0, max: self.contentLength - self.length)
            self.scrollTo(offSet: offset)
        }
    }

}
extension SegmentScrollView {
    /// ZJaDe: 重新设置 _cellArr
    public var itemArr: [ItemView] {
        get {return _cellArr.map {$0.view}}
        set {
            _cellArr.forEach { (cell) in
                cell.view.removeFromSuperview()
            }
            _cellArr = newValue.map {createLayoutCell($0)}
            _cellArr.forEach { (cell) in
                self.addSubview(cell.view)
            }
            setNeedsLayoutCells()
        }
    }
    // MARK: - 添加或者移除itemView 默认都是更新右边的cells的位置
    /// ZJaDe: 插入一个itemView
    public func insertAndUpdate(_ itemView: ItemView, at index: Int) {
        guard _cellArr.indexCanInsert(index) else {
            return
        }
        let cell = createLayoutCell(itemView)
        _cellArr.insert(cell, at: index)
        self.insertSubview(itemView, at: index)
        let cellLength = getCellLength()
        layoutCellsSize([cell], cellLength)
        let needUpdateOriginCells = Array(self._cellArr.suffix(from: index))
        let startLocation: CGFloat
        if self._cellArr.count > 1 {
            startLocation = index > 0 ? self._cellArr[index - 1].trailing : self._cellArr[index].leading - cell.length
        } else {
            startLocation = 0
        }
        layoutCellsOrigin(needUpdateOriginCells, startLocation)

    }
    /// ZJaDe: 移除一个itemView
    public func removeAndUpdate(_ itemView: ItemView) {
        guard let index = self._cellArr.index(where: {$0.view == itemView}) else {
            return
        }
        removeAndUpdate(at: index)
    }
    public func removeAndUpdate(at index: Int) {
        guard self._cellArr.indexCanBound(index) else {
            return
        }
        let removeCell = _cellArr.remove(at: index)
        removeItemViewFromSuperview(removeCell.view)
        if  _cellArr.count > 0 {
            let needUpdateOriginCells = Array(self._cellArr.suffix(from: index))
            let startLocation: CGFloat = index > 0 ? self._cellArr[index - 1].trailing : 0
            layoutCellsOrigin(needUpdateOriginCells, startLocation)
        }
    }
}
