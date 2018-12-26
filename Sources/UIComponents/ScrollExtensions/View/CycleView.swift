//
//  CycleView.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/23.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class CycleView<ItemView, ItemData>: PageItemsView<ItemView, ItemData, PageScrollView<ItemView>> where ItemView: UIView {
    /// ZJaDe: 下面属性需要加载数据之前提前设置好
    public var cacheAppearCellCount: Int = 1
    /// ZJaDe: 下面属性需要加载数据之前提前设置好
    public var cacheDisappearCellCount: Int = 1

    // MARK: - 初始化
    open override func configInit() {
        super.configInit()
        self.scrollView.tapGesture.addTarget(self, action: #selector(whenTap(_:)))
    }
    internal let repeatCount: Int = 1000
    // MARK: - 重写
    /// ZJaDe: 设置数据
    open override func configData(_ dataArray: [ItemData]) {
        super.configData(dataArray)
        if dataArray.count > 0 {
            let cell = createCell()
            self.config(cell: cell, index: 0)
            scrollView.add(cell, offSet: 0, isToRight: false)
        }
        setNeedsLayout()
        layoutIfNeeded()
        checkCellsLifeCycle(isNeedReset: true)
        /// ZJaDe: 检查并更新cells
        resetItemViewsLocation()
        /// ZJaDe: 刷新intrinsicContentSize
        invalidateIntrinsicContentSize()
    }
    /// ZJaDe: 更新布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        /// ZJaDe: 布局更新时刷新contentLength
        if self.dataArray.count > 1 {
            self.scrollView.contentLength = repeatCount.toCGFloat * self.scrollView.length * self.totalCount.toCGFloat
        } else {
            self.scrollView.contentLength = self.scrollView.length * self.totalCount.toCGFloat
        }
        /// ZJaDe: 布局更新时重新检查需要显示和消失的cells
        checkCellsLifeCycle(isNeedReset: false)
    }
    /// ZJaDe: 创建cell
    internal func createCell() -> ItemView {
        if self.scrollView.cacheCells.count > 0 {
            return self.scrollView.cacheCells.removeFirst()
        } else {
            return ItemView()
        }
    }
    // MARK: - UIScrollViewDelegate
    open override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetItemViewsLocation()
    }
    open override func whenScroll() {
        super.whenScroll()
        checkCellsLifeCycle(isNeedReset: false)
    }

    // MARK: -
    public var didSelectItem: ((TapContext<ItemView, ItemData>) -> Void)?
    @objc open func whenTap(_ tap: UITapGestureRecognizer) {
        if let element = self.scrollView.visibleCells.first(where: {$0.point(inside: tap.location(in: $0), with: nil)}) {
            let index = getCurrentIndex()
            self.currentIndex = index
            let context = TapContext(view: element, data: dataArray[index], index: index)
            self.didSelectItem?(context)
        }
    }
}
extension CycleView {
    private func resetItemViewsLocation() {
        resetItemViewsLocation(repeatCount: repeatCount)
    }
}
extension CycleView: CyclePageFormProtocol {
    public func loadCell(_ currentOffset: CGFloat, _ indexOffset: Int, _ isNeedResetData: Bool) {
        let length = self.scrollView.length
        let currentIndex = (currentOffset / length).toInt
        let offSet = currentOffset + indexOffset.toCGFloat * length
        let itemIndex = realIndex(currentIndex + indexOffset)
        if let cell = self.scrollView.getCell(offSet) {
            if isNeedResetData {// || self.modelAndCells[cell] == nil {
                config(cell: cell, index: itemIndex)
            }
        } else {
            let cell = createCell()
            self.config(cell: cell, index: itemIndex)
            scrollView.add(cell, offSet: offSet, isToRight: indexOffset >= 0)
        }
    }
    public func didDisAppear(_ cell: ItemView) {
        self.scrollView.remove(cell)
    }
}
