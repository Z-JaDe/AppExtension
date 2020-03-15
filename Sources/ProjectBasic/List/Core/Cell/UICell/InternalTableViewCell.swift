//
//  InternalTableViewCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/30.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import SnapKit
extension UITableViewCell {
    public var jd_tableView: UITableView? {
        self.value(forKey: "tableView") as? UITableView
    }
}
public protocol TableCellContentItem: UIView {
    var isHighlighted: Bool { get set }
    var isSelected: Bool { get set }
    var separatorLineHeight: CGFloat { get }
    var accessoryView: UIView? { get }
    var insets: UIEdgeInsets { get }
    var separatorLineInsets: (left: CGFloat?, right: CGFloat?) { get }

    func didDisappear()
}
public extension TableCellContentItem {
    internal func getInternalCell() -> InternalTableViewCell? {
        self.superView(InternalTableViewCell.self)
    }
    var tableView: UITableView? {
        self.getInternalCell()?.jd_tableView
    }
    func insetVerticalSpace() -> CGFloat {
        insets.top + insets.bottom + separatorLineHeight
    }
}
class InternalTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configInit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryView = nil
    }
    var contentItem: TableCellContentItem? {
        willSet { newValue?.getInternalCell()?.contentItem = nil }
        didSet {
            oldValue?.removeFromSuperview()
            if let contentItem = self.contentItem {
                self.contentView.addSubview(contentItem)
            }
        }
    }

    /// ZJaDe: separator
    private(set) lazy var separatorLineView: UIView = UIView()
    func configInit() {
        self.addSubview(self.separatorLineView)
    }

    func setNeedsUpdateLayouts() {
        updateLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        updateSeparatorLineViewFrame()
    }
    override func didTransition(to state: UITableViewCell.StateMask) {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        super.didTransition(to: state)
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if selected != contentItem?.isSelected {
//            contentItem?.isSelected = selected
//        }
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted != contentItem?.isHighlighted {
            contentItem?.isHighlighted = highlighted
        }
    }
}
extension InternalTableViewCell {
    private func updateLayout() {
        guard let contentItem = self.contentItem else {
            return
        }
        var constraintArr: [Constraint] = []

        if let accessoryView = contentItem.accessoryView {
            self.contentView.addSubview(accessoryView)
            accessoryView.contentPriority(.required)
            constraintArr += accessoryView.snp.prepareConstraints { (maker) in
                maker.right.equalTo(contentItem.insets)
                maker.leftSpace(contentItem).offset(8)
                maker.centerY.equalTo(contentItem)
                maker.top.greaterThanOrEqualTo(contentItem)
            }
        } else {
            constraintArr += contentItem.snp.prepareConstraints { (maker) in
                maker.right.equalTo(contentItem.insets)
            }
        }
        /// ZJaDe: bottom优先级设置成999，一是为了不把contentItem高度固定，这样contentItem内容变化时就可以自动调用layoutSubviews，二是有时候计算出现误差，布局不会出现异常，只是隐藏了一部分或者有部分留白
        constraintArr += contentItem.snp.prepareConstraints { (maker) in
            maker.left.top.equalTo(contentItem.insets)
            maker.bottom.equalTo(-(contentItem.separatorLineHeight + contentItem.insets.bottom)).priority(999)
        }
        self.updateLayouts(tag: "cellLayout", constraintArr)
    }
    @available(iOS, unavailable, message: "使用自动布局")
    private func updateFrames() {
        guard let contentItem = self.contentItem else {
            return
        }
        /// ZJaDe: -------------------------------------------
        contentItem.width = self.contentView.width - contentItem.insets.left - contentItem.insets.right
        let space = contentItem.insetVerticalSpace()
        contentItem.height = self.height - space

        contentItem.top = contentItem.insets.top
        contentItem.left = contentItem.insets.left
    }
    // MARK: -
    func updateSeparatorLineViewFrame() {
        guard let contentItem = self.contentItem else {
            return
        }
        let separatorLineInsets = getSeparatorLineInsets(contentItem)
        self.separatorLineView.width = self.width - separatorLineInsets.left - separatorLineInsets.right
        self.separatorLineView.height = contentItem.separatorLineHeight

        self.separatorLineView.bottom = self.height
        self.separatorLineView.left = separatorLineInsets.left
    }

    private func getSeparatorLineInsets(_ contentItem: TableCellContentItem) -> (left: CGFloat, right: CGFloat) {
        let left: CGFloat = contentItem.separatorLineInsets.left ??
            (contentItem.separatorLineHeight > 1 ? 0 : contentItem.insets.left)
        let right: CGFloat = contentItem.separatorLineInsets.right ?? 0

        return (left, right)
    }
}
