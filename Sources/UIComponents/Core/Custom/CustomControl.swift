//
//  CustomControl.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
open class CustomControl: UIControl {
    public override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        self.configInit()
        self.viewDidLoad()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configInit()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.viewDidLoad()
    }
    open func configInit() {
        updateContentItem()
    }
    open func viewDidLoad() {
        addChildView()
        configLayout()
    }
    open func addChildView() {}
    open func configLayout() {
        updateLayout()
    }
    func updateLayout() {
        updateContentAlignmentLayout()
    }
    // MARK: -
    public var didMoveToSuperviewClosure: (() -> Void)?
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.didMoveToSuperviewClosure?()
    }
    // MARK: - UIControl
    open override var contentVerticalAlignment: UIControl.ContentVerticalAlignment {
        didSet {updateContentAlignmentLayout()}
    }
    open override var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment {
        didSet {updateContentAlignmentLayout()}
    }
    // MARK: - content
    private var contentItem: UIView?
    public var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {updateContentAlignmentLayout()}
    }
    /// ZJaDe: contentItem可能改变时调用该方法更新
    public func updateContentItem() {
        // ZJaDe: 添加和移除视图由子类来控制
        let newItem = getContentItem()
        if newItem != self.contentItem {
            self.contentItem = newItem
            updateContentAlignmentLayout()
        }
    }
    /// ZJaDe: 子类重写该方法返回自定制的contentItem
    public func getContentItem() -> UIView? {
        return self.contentItem
    }
    /// ZJaDe: contentItem改变时会调用该方法更新约束
    private func updateContentAlignmentLayout() {
        guard let contentItem = self.contentItem else {
            return
        }
        self.updateLayouts(tag: "contentAlignment", contentItem.snp.prepareConstraints({ (maker) in
            self.layoutVertical(maker)
            self.layoutHorizontal(maker)
        }))
    }
}
extension CustomControl {
    internal func bindingView(_ view: UIView, _ hasData: Bool) {
        if hasData {
            self.addSubview(view)
        } else {
            view.removeFromSuperview()
        }
    }
}
extension CustomControl {
    private func layoutVertical(_ maker: ConstraintMaker) {
        let options: MakerLayoutOptions
        switch self.contentVerticalAlignment {
        case .top:
            maker.bottom.lessThanOrEqualToSuperview().offset(-self.contentEdgeInsets.bottom)
            options = .start(self.contentEdgeInsets.top)
        case .bottom:
            maker.top.greaterThanOrEqualToSuperview().offset(self.contentEdgeInsets.top)
            options = .end(self.contentEdgeInsets.bottom)
        case .center:
            maker.top.greaterThanOrEqualToSuperview().offset(self.contentEdgeInsets.top)
            maker.bottom.lessThanOrEqualToSuperview().offset(-self.contentEdgeInsets.bottom)
            options = .centerOffset(0)
        case .fill:
            options = .fill(self.contentEdgeInsets.top, self.contentEdgeInsets.bottom)
        }
        maker.vertical(self, options)
    }
    private func layoutHorizontal(_ maker: ConstraintMaker) {
        let options: MakerLayoutOptions
        switch self.contentHorizontalAlignment {
        case .left, .leading:
            maker.right.lessThanOrEqualToSuperview().offset(-self.contentEdgeInsets.right)
            options = .start(self.contentEdgeInsets.left)
        case .right, .trailing:
            maker.left.greaterThanOrEqualToSuperview().offset(self.contentEdgeInsets.left)
            options = .end(self.contentEdgeInsets.right)
        case .center:
            maker.left.greaterThanOrEqualToSuperview().offset(self.contentEdgeInsets.left)
            maker.right.lessThanOrEqualToSuperview().offset(-self.contentEdgeInsets.right)
            options = .centerOffset(0)
        case .fill:
            options = .fill(self.contentEdgeInsets.left, self.contentEdgeInsets.right)
        }
        maker.horizontal(self, options)
    }
}
