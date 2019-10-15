//
//  CustomControl.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/22.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import UIKit

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
        self.contentItem
    }
}
extension CustomControl {
    /// ZJaDe: contentItem改变时会调用该方法更新约束
    private func updateContentAlignmentLayout() {
        guard let contentItem = self.contentItem else {
            return
        }
        self.updateLayouts(
            tag: "contentAlignment",
            self.layoutVertical(contentItem) + self.layoutHorizontal(contentItem)
        )
    }
    internal func bindingView(_ view: UIView, _ hasData: Bool) {
        if hasData {
            self.addSubview(view)
        } else {
            view.removeFromSuperview()
        }
    }
}
extension CustomControl {
    private func layoutVertical(_ contentItem: UIView) -> [NSLayoutConstraint] {
        var array: [NSLayoutConstraint] = []
        let options: LayoutOptions
        switch self.contentVerticalAlignment {
        case .top:
            array.append(contentsOf: contentItem.innerToSuperview(.bottom, insets: self.contentEdgeInsets))
            options = .start(self.contentEdgeInsets.top)
        case .bottom:
            array.append(contentsOf: contentItem.innerToSuperview(.top, insets: self.contentEdgeInsets))
            options = .end(self.contentEdgeInsets.bottom)
        case .center:
            array.append(contentsOf: contentItem.innerToSuperview(.top, insets: self.contentEdgeInsets))
            array.append(contentsOf: contentItem.innerToSuperview(.bottom, insets: self.contentEdgeInsets))
            options = .centerOffset(0)
        case .fill:
            options = .fill(self.contentEdgeInsets.top, self.contentEdgeInsets.bottom)
        @unknown default:
            fatalError()
        }
        array.append(contentsOf: contentItem.vertical(self, options))
        return array
    }
    private func layoutHorizontal(_ contentItem: UIView) -> [NSLayoutConstraint] {
        var array: [NSLayoutConstraint] = []
        let options: LayoutOptions
        switch self.contentHorizontalAlignment {
        case .left, .leading:
            array.append(contentsOf: contentItem.innerToSuperview(.right, insets: self.contentEdgeInsets))
            options = .start(self.contentEdgeInsets.left)
        case .right, .trailing:
            array.append(contentsOf: contentItem.innerToSuperview(.left, insets: self.contentEdgeInsets))
            options = .end(self.contentEdgeInsets.right)
        case .center:
            array.append(contentsOf: contentItem.innerToSuperview(.left, insets: self.contentEdgeInsets))
            array.append(contentsOf: contentItem.innerToSuperview(.right, insets: self.contentEdgeInsets))
            options = .centerOffset(0)
        case .fill:
            options = .fill(self.contentEdgeInsets.left, self.contentEdgeInsets.right)
        @unknown default:
            fatalError()
        }
        array.append(contentsOf: contentItem.horizontal(self, options))
        return array
    }
}
