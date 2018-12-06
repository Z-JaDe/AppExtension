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
    var contentItem: TableItemCell? {
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
                self.setNeedsUpdateLaytouts()
            }
        }
    }

    /// 设置contentItem属性后刷新这里触发SNTableCell
    func updateUI(_ contentItem: TableItemCell) {
        self.separatorLineView.backgroundColor = contentItem.separatorLineColor
        self.accessoryType = contentItem.accessoryType
        contentItem.selectedBackgroundView.backgroundColor = contentItem.cellSelectedBackgroundColor
        self.selectedBackgroundView = contentItem.selectedBackgroundView
        self.selectionStyle = contentItem.selectionStyle
        self.backgroundColor = contentItem.cellBackgroundColor
    }

    /// ZJaDe: separator
    private(set) lazy var separatorLineView: UIView = UIView()
    func configInit() {
        self.addSubview(self.separatorLineView)
    }

    func setNeedsUpdateLaytouts() {
        updateLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
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
                maker.bottom.lessThanOrEqualTo(contentItem)
            }
        } else {
            constraintArr += contentItem.snp.prepareConstraints { (maker) in
                maker.right.equalTo(contentItem.insets)
            }
        }
        constraintArr += contentItem.snp.prepareConstraints { (maker) in
            maker.left.top.equalTo(contentItem.insets)
            maker.bottom.equalTo(-(contentItem.separatorLineHeight + contentItem.insets.bottom)).priority(999)
        }

        let separatorLineInsets = getSeparatorLineInsets(contentItem)
        constraintArr += self.separatorLineView.snp.prepareConstraints { (maker) in
            maker.left.equalTo(self).offset(separatorLineInsets.left)
            maker.right.equalTo(self).offset(-separatorLineInsets.right)
            maker.bottom.equalTo(self)
            maker.height.equalTo(contentItem.separatorLineHeight)
        }
        self.updateLayouts(tag: "cellLayout", constraintArr)
    }
    private func updateFrames() {
        guard let contentItem = self.contentItem else {
            return
        }
        let separatorLineInsets = getSeparatorLineInsets(contentItem)
        self.separatorLineView.width = self.width - separatorLineInsets.left - separatorLineInsets.right
        self.separatorLineView.height = contentItem.separatorLineHeight

        self.separatorLineView.bottom = self.height
        self.separatorLineView.left = separatorLineInsets.left
        /// ZJaDe: -------------------------------------------
        contentItem.width = self.contentView.width - contentItem.insets.left - contentItem.insets.right
        let space = contentItem.insets.bottom
        contentItem.height = self.separatorLineView.top - space - contentItem.insets.top

        contentItem.top = contentItem.insets.top
        contentItem.left = contentItem.insets.left
    }

    private func getSeparatorLineInsets(_ contentItem: TableItemCell) -> (left: CGFloat, right: CGFloat) {
        let left: CGFloat = contentItem.separatorLineInsets.left ??
            (contentItem.separatorLineHeight > 1 ? 0 : contentItem.insets.left)
        let right: CGFloat = contentItem.separatorLineInsets.right ?? 0

        return (left, right)
    }
}
