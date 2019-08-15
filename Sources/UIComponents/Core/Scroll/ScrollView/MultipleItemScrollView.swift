//
//  MultipleItemScrollView.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/6/26.
//

import Foundation

open class MultipleItemScrollView<CellView>: ScrollView, ItemsOneWayScrollable where CellView: UIView {
    private var _layoutCells: [LayoutItemType] = []
    public var itemSpace: ItemSpace = .leading(0) {
        didSet {setNeedsLayoutCells()}
    }
    public var scrollDirection: ScrollDirection = .horizontal {
        didSet {
            setNeedsLayoutCells()
            adjustAlwaysBounce()
        }
    }
    // MARK: -
    enum LayoutState {
        case none
        case loading
        case end
    }
    internal var layoutState: LayoutState = .none
    // MARK: -
    open override func configInit() {
        super.configInit()
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
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
            /// ZJaDe: superView更新ContentSize，同时也会调用self的intrinsicContentSize
            superview?.invalidateIntrinsicContentSize()
        }
    }
    /// ZJaDe: 子类需要实现
    open func layoutAllCells() {
        self.layoutState = .loading
        self._layoutCells = self._layoutCells.map({$0.map(self.itemSpace, self.scrollDirection)})
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
        self.layoutCells.forEach { (layoutCell) in
            maxWidth = max(maxWidth, layoutCell.view.width)
            maxHeight = max(maxHeight, layoutCell.view.height)
        }
        let trailing = max(self.layoutCells.last?.trailing ?? 1, 1)
        if trailing > 1 {
            self.layoutState = .end
        }
        switch self.scrollDirection {
        case .horizontal:
            return CGSize(width: trailing, height: maxHeight)
        case .vertical:
            return CGSize(width: maxWidth, height: trailing)
        }
    }
    /// ZJaDe: 根据offSet查找cell
    open func getCell(_ offSet: CGFloat) -> CellView? {
        return nil
    }
}
extension MultipleItemScrollView {
    /// ZJaDe: layoutCells相关，子类重写会用到
    public var layoutCells: [LayoutItemType] {
        return _layoutCells
    }
    /// ZJaDe: layoutCells相关，子类重写会用到
    public func cleanCells() {
        self._layoutCells = []
    }
    /// ZJaDe: layoutCells相关，子类重写会用到
    public func resetLayoutCells(_ value: [LayoutItemType]) {
        layoutCells.forEach { (cell) in
            cell.view.removeFromSuperview()
        }
        _layoutCells = value
        layoutCells.forEach { (cell) in
            self.addSubview(cell.view)
        }
    }
    /// ZJaDe: layoutCells相关，子类重写会用到
    public func removeLayoutCell(with cell: CellView) {
        _layoutCells.removeAll(where: {$0.view == cell})
        removeCellFromSuperview(cell)
    }
    /// ZJaDe: layoutCells相关，子类重写会用到
    public func removeLayoutCell(at index: Int) {
        let removeCell = _layoutCells.remove(at: index)
        removeCellFromSuperview(removeCell.view)
    }
    /// ZJaDe: layoutCells相关，子类重写会用到
    public func insert(layoutCell: LayoutItemType, at index: Int) {
        _layoutCells.insert(layoutCell, at: index)
        self.insertSubview(layoutCell.view, at: index)
    }
    /// ZJaDe: layoutCells相关，子类重写会用到
    public func append(layoutCell: LayoutItemType) {
        _layoutCells.append(layoutCell)
        self.addSubview(layoutCell.view)
    }
}
