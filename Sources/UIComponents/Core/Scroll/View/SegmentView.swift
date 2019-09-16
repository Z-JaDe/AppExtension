//
//  SegmentView.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class SegmentView<CellView, CellData>: MultipleItemsView<CellView, CellData, SegmentScrollView<CellView>> where CellView: UIView {
    private var cellArr: [CellView] {
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
        self.cellArr.count
    }
    /// ZJaDe: 设置数据
    open override func configData(_ dataArray: [CellData]) {
        super.configData(dataArray)
        func bind(itemView: CellView, itemData: CellData, index: Int) {
            update(cell: itemView, index: index)
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
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        /// ZJaDe: 布局更新时刷新当前index
        updateCurrentIndex()
    }
    /// ZJaDe: 当currentIndex改变时
    open override func whenCurrentIndexChanged(_ from: Int, _ to: Int) {
        guard self.totalCount > 0 else { return }
        // ZJaDe: 根据toIndex找到cell滚动
        let currentCell: CellView = self.cellArr[self.realIndex(to)]
        self.scrollView.scrollTo(currentCell)
        self.currentItem = currentCell
        currentLayerUpdate(currentCell)
    }
    // MARK: -
    internal func createCell() -> CellView {
        let itemView = CellView()
        return itemView
    }
    // MARK: - currentLayer
    public var currentLayerUpdater: ((CALayer, CGRect) -> Void)?
    private var _currentLayer: CALayer?
    public var currentLayer: CALayer {
        get {
            if let layer = _currentLayer {
                return layer
            } else {
                self.currentLayer = CALayer()
                return _currentLayer!
            }
        } set {
            _currentLayer?.removeFromSuperlayer()
            _currentLayer = newValue
            self.scrollView.layer.addSublayer(self.currentLayer)
        }
    }
    // MARK: - isSelected
    public private(set) var currentItem: CellView? {
        didSet {
            if let oldContext = oldValue.flatMap({ (oldItem) -> CellTapContext? in
                guard let oldIndex = self.cellArr.firstIndex(of: oldItem) else {return nil}
                return CellTapContext(view: oldItem, data: dataArray[oldIndex], index: oldIndex)
            }) {
                self.changeSelectState?(oldContext, false)
            }
            if var itemView = oldValue as? SelectedStateDesignable {
                itemView.isSelected = false
            }
            /// ZJaDe: 
            if let context = currentItem.map({CellTapContext(view: $0, data: dataArray[currentIndex], index: currentIndex)}) {
                self.changeSelectState?(context, true)
            }
            if var itemView = self.currentItem as? SelectedStateDesignable {
                itemView.isSelected = true
            }
        }
    }
    // MARK: -
    public typealias CellTapContext = TapContext<CellView, CellData>
    /// ZJaDe: 点击时会调用
    public var shouldSelectItem: ((CellTapContext) -> Bool)?
    /// ZJaDe: 点击时会调用
    public var didSelectItem: ((CellTapContext) -> Void)?
    /// ZJaDe: 只要状态更改就会调用
    public var changeSelectState: ((CellTapContext, Bool) -> Void)?
    @objc open func whenTap(_ tap: UITapGestureRecognizer) {
        if let (offset, element) = self.cellArr.enumerated().first(where: {$0.element.point(inside: tap.location(in: $0.element), with: nil)}) {
            let context = CellTapContext(view: element, data: dataArray[offset], index: offset)
            guard self.shouldSelectItem?(context) != false else { return }
            self.currentIndex = offset
            didSelectItem?(context)
        }
    }
}
extension SegmentView {
    /// ZJaDe: 当item数据需要更新时会调用该方法
    private func update(cell: CellView, index: Int) {
        self.viewUpdater(cell, dataArray[index], index)
    }
    private func currentLayerUpdate(_ currentCell: CellView) {
        if _currentLayer == nil {
            self.currentLayer = CALayer()
        }
        if let updater = self.currentLayerUpdater {
            self.currentLayer.position = CGPoint(x: currentCell.centerX, y: currentCell.bottom)
            updater(self.currentLayer, currentCell.frame)
        } else {
            self.currentLayer.position = CGPoint(x: currentCell.centerX, y: currentCell.bottom - currentLayer.height / 2)
        }
    }
}
