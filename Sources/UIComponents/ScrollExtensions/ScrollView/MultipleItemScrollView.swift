//
//  MultipleItemScrollView.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/6/26.
//

import Foundation

open class MultipleItemScrollView<ItemView>: ScrollView, ItemsOneWayScrollProtocol where ItemView: UIView {

    internal var _cellArr: [LayoutCellType] = []
    public func cleanCells() {
        self._cellArr = []
    }
    public var itemSpace: ItemSpace = .leading(0) {
        didSet {setNeedsLayoutCells()}
    }
    public var scrollDirection: ScrollDirection = .horizontal {
        didSet {
            setNeedsLayoutCells()
            adjustAlwaysBounce()
        }
    }
    open override func configInit() {
        super.configInit()
        adjustAlwaysBounce()
    }
    /// ZJaDe: 布局
    private var oldSize: CGSize = CGSize.zero
    open override func layoutSubviews() {
        super.layoutSubviews()
        if self.isNeedsLayoutCells || self.oldSize != self.size {
            self.oldSize = self.size
            self.isNeedsLayoutCells = false
            layoutAllCells()
        }
    }
    internal func layoutAllCells() {
        self._cellArr.forEach { (cell) in
            cell.itemSpace = self.itemSpace
            cell.scrollDirection = self.scrollDirection
        }
    }
    private var isNeedsLayoutCells: Bool = false
    public func setNeedsLayoutCells() {
        self.isNeedsLayoutCells = true
        self.setNeedsLayout()
    }
    /// ZJaDe: 计算自有尺寸
    open override var intrinsicContentSize: CGSize {
        var maxWidth: CGFloat = 1
        var maxHeight: CGFloat = 1
        self._cellArr.forEach { (layoutCell) in
            maxWidth = max(maxWidth, layoutCell.sizeThatFits().width)
            maxHeight = max(maxHeight, layoutCell.sizeThatFits().height)
        }
        switch self.scrollDirection {
        case .horizontal:
            return CGSize(width: max(size.width, 1), height: maxHeight)
        case .vertical:
            return CGSize(width: maxWidth, height: max(size.height, 1))
        }
    }
    /// ZJaDe: 根据offSet查找cell
    public func getCell(_ offSet: CGFloat) -> ItemView? {
        return nil
    }
}
