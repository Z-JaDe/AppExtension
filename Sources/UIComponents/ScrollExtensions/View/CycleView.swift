//
//  CycleView.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/23.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class CycleView<ItemView, ItemData>: MultipleItemsView<ItemView, ItemData, PageScrollView<ItemView>>, UIScrollViewDelegate where ItemView: UIView {

    open var placeholderItem: ItemData? {
        didSet {
            if self.dataArray.count == 0 || self.placeholderItem != nil {
                configData(self.dataArray)
            }
        }
    }
    public let pageControl = SnakePageControl()
    /// ZJaDe: 下面属性需要加载数据之前提前设置好
    public var cacheAppearCellCount: Int = 1
    /// ZJaDe: 下面属性需要加载数据之前提前设置好
    public var cacheDisappearCellCount: Int = 1
    // MARK: - 自动滚动
    private lazy var timer: SwiftTimer = SwiftTimer.repeaticTimer(interval: .seconds(5)) {[weak self] (_) in
        guard let `self` = self else { return }
        guard self.dataArray.count > 1 else { return }
        if self.scrollView.isDragging { return }
        self.scrollNextIndex()
    }
    public func timerStart() {
        self.timer.start()
    }
    public func timerSuspend() {
        self.timer.suspend()
    }
    // MARK: - 初始化
    var observer: NSKeyValueObservation?
    open override func configInit() {
        super.configInit()
        self.scrollView.delegate = self
        observer = self.scrollView.observe(\.contentOffset) {[weak self] (_, _) in
            self?.whenScroll()
        }
    }
    deinit {
        /// ZJaDe: ios10 无动画pop时，不手动调用invalidate会崩溃
        observer?.invalidate()
    }

    open override func addChildView() {
        super.addChildView()
        self.addSubview(self.pageControl)
    }
    internal let repeatCount: Int = 1000
    // MARK: - 重写
    /// ZJaDe: 设置数据
    open override func configData(_ dataArray: [ItemData]) {
        var dataArray = dataArray
        if let placeholderItem = self.placeholderItem, dataArray.count == 0 {
            dataArray = [placeholderItem]
        }
        super.configData(dataArray)
        /// ZJaDe: 配置pageControl
        self.pageControl.isHidden = !self.isMultipleData || self.scrollView.scrollDirection == .vertical
        self.pageControl.pageCount = dataArray.count
        /// ZJaDe: 刷新布局
        if let first = dataArray.first {
            let cell = createCell()
            self.config(cell: cell, model: first)
            willAppear(cell, offSet: 0, isToRight: false)
        }
        setNeedsLayout()
        layoutIfNeeded()
        checkCells(true)
        /// ZJaDe: 检查并更新cells
        resetItemViewsLocation(repeatCount: repeatCount)
        /// ZJaDe: 刷新intrinsicContentSize
        invalidateIntrinsicContentSize()
    }
    /// ZJaDe: 更新布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.pageControl.sizeToFit()
        self.pageControl.bottom = self.height - 20
        self.pageControl.centerX = self.width / 2
        /// ZJaDe: 布局更新时刷新contentLength
        if self.dataArray.count > 1 {
            self.scrollView.contentLength = repeatCount.toCGFloat * self.scrollView.length * self.totalCount.toCGFloat
        } else {
            self.scrollView.contentLength = self.scrollView.length * self.totalCount.toCGFloat
        }
        /// ZJaDe: 布局更新时重新检查需要显示和消失的cells
        checkCells(false)
    }

    /// ZJaDe: 当currentIndex改变时
    internal override func whenCurrentIndexChanged(_ from: Int, _ to: Int) {
        self.scroll(from, to)
    }
    /// ZJaDe: 创建cell
    internal override func createCell() -> CellType {
        if self.scrollView.cacheCells.count > 0 {
            return self.scrollView.cacheCells.removeFirst()
        } else {
            return super.createCell()
        }
    }
    // MARK: - UIScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        resetItemViewsLocation(repeatCount: repeatCount)
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            adjustOffSetWhenScrollEnd()
        }
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustOffSetWhenScrollEnd()
    }

    func whenScroll() {
        self.pageControl.progress = realProgress(offSet: self.scrollView.viewHeadOffset(), length: self.scrollView.length)
        checkCells()
    }
    func adjustOffSetWhenScrollEnd() {
        let offSet = self.scrollView.viewCenterOffset().floorToNearest(increment: self.scrollView.length)
        self.scrollView.scrollTo(offSet: offSet)
        if self.timer.isRunning {
            self.timer.suspend()
            self.timer.start()
        }
    }
}

extension CycleView: SingleCycleFormProtocol {
    public func loadCell(_ currentOffset: CGFloat, _ indexOffset: Int, _ isNeedResetData: Bool) {
        let length = self.scrollView.length
        let currentIndex = (currentOffset / length).toInt
        let offSet = currentOffset + indexOffset.toCGFloat * length
        let itemIndex = currentIndex + indexOffset
        let itemData = self.dataArray[realIndex(itemIndex)]
        if let cell = self.scrollView.getCell(offSet) {
            if isNeedResetData || self.modelAndCells[cell] == nil {
                config(cell: cell, model: itemData)
            }
        } else {
            let cell = createCell()
            self.config(cell: cell, model: itemData)
            willAppear(cell, offSet: offSet, isToRight: indexOffset >= 0)
        }
    }
}
