//
//  TableItemCell+Height.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
private var isUpdatingKey: UInt8 = 0
extension TableItemCell {
    private var isUpdating: Bool {
        get {return associatedObject(&isUpdatingKey, createIfNeed: false)}
        set {setAssociatedObject(&isUpdatingKey, newValue)}
    }
    public func updateHeight(_ indexPath: IndexPath, _ closure: (() -> Void)?) {
        guard self.isUpdating == false else {
            return
        }
        guard CATransform3DIsIdentity(self.layer.transform) else {
            return
        }
        guard (try? self.cellState.value()) == .didAppear else {
            return
        }
        guard let tableView = self.getTableView() else {
            logError("\(self)->tableView找不到")
            return
        }
        if tableView.cellHeightLayoutType(for: indexPath) == .hasLayout {
            let oldHeight = tableView.tempCellHeight(for: indexPath) - self.insetSpace()
            let height: CGFloat = self.height
            if abs(height - oldHeight) > 2 && height > 0 {
                logDebug("updateHeight -> \(oldHeight) to \(height)")
                self.setNeedResetCellHeight()
            }
        }
        guard tableView.cellHeightLayoutType(for: indexPath) == .resetLayout else {
            return
        }
        self.setNeedUpdate()
        self.isUpdating = true
        UIView.animate(withDuration: 0.25) {
            TableViewUpdating(tableView).performBatch(animated: true, updates: {[weak self] in
                guard let `self` = self else { return }
                closure?()
                self.isUpdating = false
                }, completion: {_ in })
        }
    }
    public func setNeedResetCellHeight() {
        guard let tableView = self.getTableView() else {
            return
        }
        guard let cell = self.superView(UITableViewCell.self) else {
            return
        }
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        tableView.changeTempCellHeight(-1, for: indexPath)
    }
}
extension TableItemCell {
    /*************** 计算TableViewCell高度 ***************/
    public func layoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        let result: CGFloat
        if let height = self.frameLayoutHeight(contentWidth) {
            result = height
        } else {
            result = self.autoLayoutHeight(contentWidth)
        }
        return result.ceilToNearest(increment: 1)
    }
    /*************** 计算TableViewCell高度 ***************/
    fileprivate func frameLayoutHeight(_ contentWidth: CGFloat) -> CGFloat? {
        let viewWidth = contentWidth - insets.left - insets.right
        let viewHeight = self.calculateFrameHeight(viewWidth)
        if viewHeight > 0 {
            return viewHeight
        } else {
            return nil
        }
    }
    fileprivate func autoLayoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        let constraint = self.widthAnchor.constraint(equalToConstant: contentWidth)
        constraint.priority = UILayoutPriority(rawValue: 999.1)
        constraint.isActive = true
        let _translates = self.translatesAutoresizingMaskIntoConstraints
        self.translatesAutoresizingMaskIntoConstraints = false
        let cellHeight = self.systemLayoutSizeFitting(CGSize(width: contentWidth, height: 0)).height

        constraint.isActive = false
        self.translatesAutoresizingMaskIntoConstraints = _translates

        return cellHeight
    }
}
