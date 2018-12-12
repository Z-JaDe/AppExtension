//
//  TableViewHeaderFooterView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/18.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

open class BaseTableViewHeaderFooterView: CustomView, WritableDefaultHeightProtocol {
    public var defaultHeight: CGFloat = -1
    var inset: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) {
        didSet {
            if self.titleLabel.superview != nil {
                updateInsetLayout()
            }
        }
    }
    fileprivate lazy var titleLabel: Label = {
        let label = Label()
        label.clipsToBounds = false
        label.numberOfLines = 0
        label.contentPriority(.required)
        return label
    }()

    func viewHeight(_ width: CGFloat) -> CGFloat {
        if self.defaultHeight > 0 {
            return self.defaultHeight
        } else {
            let autoHeight = self.sizeThatFits(CGSize(width: width, height: 0)).height
            return autoHeight > 0 ? autoHeight : 0.1
        }
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = size
        size.width -= self.inset.left + self.inset.right
        var height = self.titleLabel.sizeThatFits(size).height
        if height > 0 {
            height += self.inset.top + self.inset.bottom
        }
        return CGSize(width: size.width, height: height)
    }
    // MARK: -
    /// ZJaDe: 重写
    func updateInsetLayout() {

    }
}
extension BaseTableViewHeaderFooterView {
    public func changeTitle(_ title: String?, font: UIFont, color: UIColor) {
        self.titleLabel.text = title
        self.titleLabel.font = font
        self.titleLabel.textColor = color
        self.titleLabel.isHidden = title.isNilOrEmpty
        if self.titleLabel.superview == nil {
            self.addSubview(self.titleLabel)
            updateInsetLayout()
        }
    }
    public func change(textAlignment: NSTextAlignment) {
        self.titleLabel.textAlignment = textAlignment
    }
    public func changeAttrTitle(_ attrTitle: NSAttributedString?) {
        self.titleLabel.attributedText = attrTitle
    }
}
open class TableViewHeaderView: BaseTableViewHeaderFooterView {
    override func updateInsetLayout() {
        self.updateLayouts(tag: "updateInset", self.titleLabel.snp.prepareConstraints({ (maker) in
            maker.left.right.bottom.equalTo(self.inset)
            maker.top.greaterThanOrEqualTo(self.inset).priority(990)
        }))
    }
}
open class TableViewFooterView: BaseTableViewHeaderFooterView {
    override func updateInsetLayout() {
        self.updateLayouts(tag: "updateInset", self.titleLabel.snp.prepareConstraints({ (maker) in
            maker.left.right.top.equalTo(self.inset)
            maker.bottom.lessThanOrEqualTo(self.inset).priority(990)
        }))
    }
}
