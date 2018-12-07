//
//  TableItemCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/16.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift

open class TableCellDefaultProperty: DefaultProperty {
    public var cellSelectedBackgroundColor: UIColor = Color.colorFromRGB("#fffdef")!
}

open class TableItemCell: ItemCell, WritableDefaultHeightProtocol, DefaultPropertyProtocol {
    public static var defaultProperty: TableCellDefaultProperty = TableCellDefaultProperty()

    func getSNCell() -> SNTableViewCell? {
        return self.superView(SNTableViewCell.self)
    }
    weak var _tableView: UITableView?
    func getTableView() -> UITableView? {
        return _tableView
    }
    /// ZJaDe: 
    open var cellSelectedBackgroundColor: UIColor = TableItemCell.defaultProperty.cellSelectedBackgroundColor {
        didSet {self.selectedBackgroundView.backgroundColor = self.cellSelectedBackgroundColor}
    }
    open var selectionStyle: UITableViewCell.SelectionStyle = .gray {
        didSet {getSNCell()?.selectionStyle = self.selectionStyle}
    }
    open var cellBackgroundColor: UIColor = Color.white {
        didSet {getSNCell()?.backgroundColor = self.cellBackgroundColor}
    }
    public var separatorLineHeight: CGFloat = 0.5 {
        didSet {getSNCell()?.setNeedsUpdateLaytouts()}
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
        didSet {getSNCell()?.setNeedsUpdateLaytouts()}
    }
    /// ZJaDe: 内容insets
    public var insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) {
        didSet {getSNCell()?.setNeedsUpdateLaytouts()}
    }
    public func insetSpace() -> CGFloat {
        return insets.top + insets.bottom + separatorLineHeight
    }

    /// ZJaDe: 
    public var separatorLineColor: UIColor = Color.separatorLine {
        didSet {getSNCell()?.separatorLineView.backgroundColor = self.separatorLineColor}
    }
    public var accessoryType: UITableViewCell.AccessoryType = .none {
        didSet {getSNCell()?.accessoryType = self.accessoryType}
    }
    public var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            getSNCell()?.setNeedsUpdateLaytouts()
        }
    }
    /// ZJaDe: 这个方法返回itemCell的高度，如果返回0 就采取自动布局的方式计算高度
    open func calculateFrameHeight(_ width: CGFloat) -> CGFloat {
        return 0
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
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        var resultSize = super.systemLayoutSizeFitting(targetSize)
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var resultSize = super.sizeThatFits(size)
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
    // MARK: -
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
}
