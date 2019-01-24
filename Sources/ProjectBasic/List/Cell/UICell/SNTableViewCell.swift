//
//  SNTableViewCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/30.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import SnapKit
class SNTableViewCell: UITableViewCell {
    static let reuseIdentifier: String = SNTableViewCell.classFullName
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
    typealias ContentItemType = TableItemCell
    var contentItem: ContentItemType? {
        willSet {
            newValue?.getSNCell()?.contentItem = nil
        }
        didSet {
            oldValue?.removeFromSuperview()
            oldValue?.accessoryView?.removeFromSuperview()
            if let contentItem = self.contentItem {
                contentItem.prepareForReuse()
                self.contentView.addSubview(contentItem)
                self.updateUI(contentItem)
                self.setNeedsUpdateLayouts()
            }
        }
    }

    /// 设置contentItem属性后刷新这里触发SNTableCell
    func updateUI(_ contentItem: ContentItemType) {
        self.separatorLineView.backgroundColor = contentItem.separatorLineColor
        self.accessoryType = contentItem.accessoryType
        self.selectedBackgroundView = contentItem.selectedBackgroundView
        self.selectionStyle = contentItem.selectionStyle
        self.backgroundColor = contentItem.cellBackgroundColor
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
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentItem?.isHighlighted = highlighted
    }
}
extension SNTableViewCell {
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

    private func getSeparatorLineInsets(_ contentItem: ContentItemType) -> (left: CGFloat, right: CGFloat) {
        let left: CGFloat = contentItem.separatorLineInsets.left ??
            (contentItem.separatorLineHeight > 1 ? 0 : contentItem.insets.left)
        let right: CGFloat = contentItem.separatorLineInsets.right ?? 0

        return (left, right)
    }
}
