//
//  SegmentView<ItemView, ItemData>.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class SegmentView<ItemView, ItemData>: MultipleItemsView<ItemView, ItemData, SegmentScrollView<ItemView>> where ItemView: UIView {
    private var cellArr: [CellType] = []

    // MARK: - 重写
    /// ZJaDe: item总数量
    open override var totalCount: Int {
        return self.cellArr.count
    }
    /// ZJaDe: 设置数据
    open override func configData(_ dataArray: [ItemData]) {
        super.configData(dataArray)
        /// ZJaDe: 设置cellArr数据
        self.cellArr.countIsEqual(dataArray, bind: { (itemView, itemData) in
            self.config(cell: itemView, model: itemData)
        }, append: {_ in createCell()}, remove: {_ in })

        self.scrollView.itemArr = self.cellArr
        self.cellArr.lazy.enumerated().forEach { (offset, cell) in
            if var itemView = cell as? SelectedStateDesignable {
                itemView.isSelected = false
            }
            if offset == self.currentIndex {
                self.currentItem = cell
            }
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
    internal override func whenCurrentIndexChanged(_ from: Int, _ to: Int) {
        guard self.totalCount > 0 else {
            return
        }
        // ZJaDe: 根据toIndex找到cell滚动
        let currentItemView: CellType = self.cellArr[self.realIndex(to)]
        self.scrollView.scrollTo(currentItemView)
        self.currentItem = currentItemView
        self.currentLayer.position = CGPoint(x: currentItemView.centerX, y: currentItemView.bottom - self.currentLayer.height / 2)
        self.configCurrentLayerClosure?(self.currentLayer, currentItemView.frame)
        self.scrollView.layer.addSublayer(self.currentLayer)
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
    internal override func didSelectItem(_ cell: CellType) {
        super.didSelectItem(cell)
        self.currentItem = cell
        if let index = self.cellArr.index(of: cell) {
            self.currentIndex = index
        }
    }
}
