//
//  PageItemsView.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/13.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

// MARK: 抽象类 需要继承
open class PageItemsView<CellView, ItemData, ScrollView>: MultipleItemsView<CellView, ItemData, ScrollView>,
    UIScrollViewDelegate
    where CellView: UIView, ScrollView: UIScrollView & OneWayScrollable {
    open var placeholderItem: ItemData? {
        didSet {
            if self.dataArray.isEmpty || self.placeholderItem != nil {
                configData(self.dataArray)
            }
        }
    }
    public let pageControl = SnakePageControl()
    // MARK: - 自动滚动
    private lazy var timer: SwiftTimer = SwiftTimer.repeaticTimer(interval: .seconds(5)) {[weak self] (_) in
        guard let self = self else { return }
        guard self.dataArray.count > 1 else { return }
        if self.scrollView.isDragging { return }
        self.scrollNextIndex()
    }
    // MARK: - 初始化
    var observer: NSKeyValueObservation?
    open override func configInit() {
        super.configInit()
        observer = self.scrollView.observe(\.contentOffset) {[weak self] (_, _) in
            self?.whenScroll()
        }
        self.scrollView.delegate = self
    }
    deinit {
        /// ZJaDe: ios10 无动画pop时，不手动调用invalidate会崩溃
        observer?.invalidate()
    }
    open override func addChildView() {
        super.addChildView()
        self.addSubview(self.pageControl)
    }

    // MARK: -
    /// ZJaDe: 子类实现数据绑定 布局更新
    open override func configData(_ dataArray: [CellData]) {
        var dataArray = dataArray
        if let placeholderItem = self.placeholderItem, dataArray.isEmpty {
            dataArray = [placeholderItem]
        }
        super.configData(dataArray)
        /// ZJaDe: 配置pageControl
        self.pageControl.isHidden = !self.isMultipleData || self.scrollView.scrollDirection == .vertical
        self.pageControl.pageCount = dataArray.count
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.pageControl.sizeToFit()
        self.pageControl.bottom = self.height - 20
        self.pageControl.centerX = self.width / 2
    }

    /// ZJaDe: 当currentIndex改变时
    open override func whenCurrentIndexChanged(_ from: Int, _ to: Int) {
        self.scroll(from, to)
    }
    // MARK: - UIScrollViewDelegate
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    }
    public final func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            adjustOffSetWhenScrollEnd()
        }
    }
    open func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustOffSetWhenScrollEnd()
    }
    open func whenScroll() {
        self.pageControl.progress = getCurrentProgress()
    }
}
extension PageItemsView {
    public func adjustOffSetWhenScrollEnd() {
        let offSet = self.scrollView.viewCenterOffset().floorToNearest(increment: self.scrollView.length)
        self.scrollView.scrollTo(offSet: offSet)
        if self.timer.isRunning {
            self.timer.suspend()
            self.timer.start()
        }
    }
    public func timerStart() {
        self.timer.start()
    }
    public func timerSuspend() {
        self.timer.suspend()
    }
}
