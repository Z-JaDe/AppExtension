//
//  TableItemCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/16.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

extension TableItemCell {
    public static var selectedBackgroundDefaultColor: UIColor = Color.colorFromRGB("#fffdef")!
}

open class TableItemCell: ItemCell, TableCellContentItem, WritableDefaultHeightProtocol {
    open override func configInit() {
        super.configInit()
        self.updateSelectedBackgroundColor()
        configDefaultInsets()
    }
    // MARK: -
    open override func removeFromSuperview() {
        super.removeFromSuperview()
        accessoryView?.removeFromSuperview()
    }
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let cell = getInternalCell() else { return }
        prepareForReuse()
        self.updateUI(cell)
        cell.setNeedsUpdateLayouts()
    }
    /// 设置contentItem属性后刷新这里触发SNTableCell
    func updateUI(_ cell: InternalTableViewCell) {
        cell.separatorLineView.backgroundColor = self.separatorLineColor
        cell.accessoryType = self.accessoryType
        cell.selectedBackgroundView = self.selectedBackgroundView
        cell.selectionStyle = self.selectionStyle
        cell.backgroundColor = self.cellBackgroundColor

        ///isSelected由cell和model共同控制
//        cell.isSelected = self.isSelected
        ///isHighlighted由cell控制
        self.isHighlighted = cell.isHighlighted
    }
    open override func didDisappear() {
        super.didDisappear()
        self.getInternalCell()?.contentItem = nil
    }
    // MARK: -
    /// ZJaDe: 
    open var cellSelectedBackgroundColor: UIColor? = TableItemCell.selectedBackgroundDefaultColor {
        didSet { updateSelectedBackgroundColor() }
    }
    open var cellBackgroundColor: UIColor = Color.white {
        didSet {getInternalCell()?.backgroundColor = self.cellBackgroundColor}
    }
    public var separatorLineHeight: CGFloat = jd.onePx {
        didSet {getInternalCell()?.updateSeparatorLineViewFrame()}
    }
    /** ZJaDe: 
     默认与UITableViewCell对齐 而不是和contentView对齐
     如果不为nil时，使用设置的值对齐
     如果为nil 时，right默认为0
     left看分割线高度separatorLineHeight。如果分割线高度大于1时, left等于0;如果分割线高度小于等于1时, left 默认和insets属性的left相等。
     如果这个cell设置了accessoryType。需要注意右边是对齐UITableViewCell右边界，还是对齐内容
     目前系统的accessoryType右边的间距 默认为16
     */
    public var separatorLineInsets: (left: CGFloat?, right: CGFloat?) = (nil, nil) {
        didSet {getInternalCell()?.updateSeparatorLineViewFrame()}
    }
    /// ZJaDe: 内容insets
    public var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {getInternalCell()?.setNeedsUpdateLayouts()}
    }
    private func configDefaultInsets() {
        self.insets = TableItemCell.get(type(of: self)) ?? defaultInsets()
    }
    open func defaultInsets() -> UIEdgeInsets {
        UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    }
    /// ZJaDe: 
    public var separatorLineColor: UIColor = Color.separatorLine {
        didSet {getInternalCell()?.separatorLineView.backgroundColor = self.separatorLineColor}
    }
    public var accessoryType: UITableViewCell.AccessoryType = .none {
        didSet {getInternalCell()?.accessoryType = self.accessoryType}
    }
    public var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            getInternalCell()?.setNeedsUpdateLayouts()
        }
    }
    /// ZJaDe: 这个方法返回itemCell的高度，如果返回0 就采取自动布局的方式计算高度
    open func calculateFrameHeight(_ width: CGFloat) -> CGFloat {
        0
    }

    public var defaultHeight: CGFloat = 0 {
        didSet {
            self.invalidateIntrinsicContentSize()
            self.setNeedsLayout()
        }
    }
    open override var intrinsicContentSize: CGSize {
        var resultSize = super.intrinsicContentSize
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var resultSize: CGSize
        if self.defaultHeight > 0, targetSize.width > 0 {
            resultSize = CGSize(width: targetSize.width, height: self.defaultHeight)
        } else {
            resultSize = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
            if self.defaultHeight > 0 {
                resultSize.height = self.defaultHeight
            }
        }
        return resultSize
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var resultSize: CGSize
        if self.defaultHeight > 0, size.width > 0 {
            resultSize = CGSize(width: size.width, height: self.defaultHeight)
        } else {
            resultSize = super.sizeThatFits(size)
            if self.defaultHeight > 0 {
                resultSize.height = self.defaultHeight
            }
        }
        return resultSize
    }
    // MARK: -
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}
extension TableItemCell {
    private func updateSelectedBackgroundColor() {
        if let color = self.cellSelectedBackgroundColor {
            self.selectedBackgroundView.backgroundColor = color
            self.selectionStyle = .default
        } else {
            self.selectionStyle = .none
        }
    }
    internal private(set) var selectionStyle: UITableViewCell.SelectionStyle {
        get { self.cellSelectedBackgroundColor == nil ? .none : .default }
        set { getInternalCell()?.selectionStyle = newValue }
    }
}
extension TableItemCell {
    private static var insetsInfo: [String: UIEdgeInsets] = [:]
    public static func save<T>(_ cellType: T.Type, insets: UIEdgeInsets) where T: TableItemCell {
        let name = cellType.classFullName
        self.insetsInfo[name] = insets
    }
    public static func get<T>(_ cellType: T.Type) -> UIEdgeInsets? where T: TableItemCell {
        let name = cellType.classFullName
        if let insets = self.insetsInfo[name] {
            return insets
        } else if let cls = cellType.superclass() as? TableItemCell.Type {
            return get(cls)
        }
        return nil
    }
}
