//
//  MultipleItemsView.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/23.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

/**
 1. 调用configData(_ dataArray: [ItemData])方法设置数据
 2. 设置完成后更新布局
 3. 每次更新布局后需要更新 updateCurrentIndex
 4. 每次currentIndex更新 调用whenCurrentIndexChanged(_ to: Int)完成滚动
 */

// MARK: 抽象类 需要继承
open class MultipleItemsView<CellView, CellData, ScrollView>: CustomControl, CollectionViewable
    where CellView: UIView, ScrollView: UIView & OneWayScrollable {
    public var inset: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {setNeedsLayout()}
    }
    /// ZJaDe: viewUpdater
    public typealias ViewUpdaterFn = (CellView, CellData, Int) -> Void
    /// ZJaDe: 数据绑定
    open var viewUpdater: ViewUpdaterFn

    public convenience init() {
        self.init(viewUpdater: { _, _, _ in })
    }
    public init(viewUpdater: @escaping ViewUpdaterFn) {
        self.viewUpdater = viewUpdater
        super.init(frame: .zero)
    }
    public required init?(coder aDecoder: NSCoder) {
        self.viewUpdater = { _, _, _ in }
        super.init(coder: aDecoder)
    }

    public private(set) var dataArray: [CellData] = []
    // MARK: - PageViewable
    public private(set) lazy var scrollView: ScrollView = createScrollView()
    open func createScrollView() -> ScrollView {
        ScrollView()
    }
    public var currentIndex: Int = 0 {
        didSet {
            whenCurrentIndexChanged(oldValue, self.currentIndex)
            self.sendActions(for: .valueChanged)
        }
    }
    open var totalCount: Int {
        self.dataArray.count
    }
    // MARK: - 初始化
    open override func configInit() {
        super.configInit()
    }
    open override func addChildView() {
        super.addChildView()
        self.addSubview(self.scrollView)
    }
    // MARK: - 需要重写的methods
    /// ZJaDe: 设置数据
    open func configData(_ dataArray: [CellData]) {
        self.dataArray = dataArray
    }
    /// ZJaDe: 更新布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.width = self.width - inset.left - inset.right
        self.scrollView.height = self.height - inset.top - inset.bottom
        self.scrollView.origin = CGPoint(x: self.inset.left, y: self.inset.top)
    }
    /// ZJaDe: 计算自有尺寸
    open override var intrinsicContentSize: CGSize {
        var result = self.scrollView.intrinsicContentSize
        result.width += self.inset.left + self.inset.right
        result.height += self.inset.top + self.inset.bottom
//        if !(CellView.self == Label.self || CellView.self == ImageView.self) {
//            logDebug("cycleView -> frame ->\(self.scrollView.subviews)")
//        }
        return result
    }
    /// ZJaDe: _currentIndex更改时会调用该方法，该方法只能用于重写
    open func whenCurrentIndexChanged(_ from: Int, _ to: Int) {
        jdAbstractMethod()
    }
    /// ZJaDe: 刷新数据后校正currentIndex 外部使用时不需要调用 重写时可能调用到
    open func updateCurrentIndex() {
        whenCurrentIndexChanged(self.currentIndex, self.currentIndex)
    }
}
