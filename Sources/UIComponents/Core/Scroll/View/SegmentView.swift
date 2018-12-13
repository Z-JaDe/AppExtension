//
//  SegmentView<ItemView, ItemData>.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class SegmentView<ItemView, ItemData>: MultipleItemsView<ItemView, ItemData, SegmentScrollView<ItemView>> where ItemView: UIView {
    private var cellArr: [ItemView] {
        get {return self.scrollView.itemArr}
        set {self.scrollView.itemArr = newValue}
    }
    open override func configInit() {
        super.configInit()
        self.scrollView.tapGesture.addTarget(self, action: #selector(whenTap(_:)))
    }
    // MARK: - 重写
    /// ZJaDe: item总数量
    open override var totalCount: Int {
        return self.cellArr.count
    }
    /// ZJaDe: 设置数据
    open override func configData(_ dataArray: [ItemData]) {
        super.configData(dataArray)
        func bind(itemView: ItemView, itemData: ItemData, index: Int) {
            config(cell: itemView, index: index)
            if var itemView = itemView as? SelectedStateDesignable {
                itemView.isSelected = false
            }
        }
        /// ZJaDe: 设置cellArr数据
        self.cellArr.countIsEqual(
            dataArray,
            bind: bind,
            append: {_ in createCell()},
            remove: {_ in }
        )
        self.scrollView.itemArr = self.cellArr
        if self.currentIndex < self.cellArr.count {
            self.currentItem = self.cellArr[self.currentIndex]
        }
        setNeedsLayout()
    }
    /// ZJaDe: 更新布局
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollView.contentLength = self.scrollView.length * self.totalCount.toCGFloat
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        /// ZJaDe: 布局更新时刷新当前index
        updateCurrentIndex()
    }
    /// ZJaDe: 当currentIndex改变时
    open override func whenCurrentIndexChanged(_ from: Int, _ to: Int) {
        guard self.totalCount > 0 else { return }
        // ZJaDe: 根据toIndex找到cell滚动
        let currentItemView: ItemView = self.cellArr[self.realIndex(to)]
        self.scrollView.scrollTo(currentItemView)
        self.currentItem = currentItemView
        self.currentLayer.position = CGPoint(x: currentItemView.centerX, y: currentItemView.bottom - self.currentLayer.height / 2)
        self.configCurrentLayerClosure?(self.currentLayer, currentItemView.frame)
        self.scrollView.layer.addSublayer(self.currentLayer)
    }
    // MARK: -
    internal func createCell() -> ItemView {
        let itemView = ItemView()
        return itemView
    }

    // MARK: isSelected
    public var configCurrentLayerClosure: ((CALayer, CGRect) -> Void)?
    public let currentLayer: CALayer = CALayer()
    public private(set) var currentItem: ItemView? {
        didSet {
            if var itemView = oldValue as? SelectedStateDesignable {
                itemView.isSelected = false
            }
            if var itemView = self.currentItem as?SelectedStateDesignable {
                itemView.isSelected = true
            }
        }
    }
    // MARK: -
    public var didSelectItem: ((TapContext<ItemView, ItemData>) -> Void)?
    @objc open func whenTap(_ tap: UITapGestureRecognizer) {
        if let (offset, element) = self.cellArr.enumerated().first(where: {$0.element.point(inside: tap.location(in: $0.element), with: nil)}) {
            self.currentIndex = offset
            let context = TapContext(view: element, data: dataArray[offset], index: offset)
            self.didSelectItem?(context)
        }
    }
}
