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
    func updateHeight<Item: TableCellHeightProtocol>(_ item: Item, _ updates: (() -> Void)?) {
        guard let updater = self.getTableView()?.updater else {
            logError("\(self)->tableView找不到")
            return
        }
        guard updater.isUpdating == false else { return }
        guard CATransform3DIsIdentity(self.layer.transform) else { return }
        guard (try? self.cellState.value()) == .didAppear else { return }
        if item.cellHeightLayoutType == .hasLayout {
            let oldHeight = item.tempCellHeight - self.insetVerticalSpace()
            let height: CGFloat = self.height
            if abs(height - oldHeight) > 2 && height > 0 {
                logDebug("updateHeight -> \(oldHeight) to \(height)")
                item._setNeedResetCellHeight()
            }
        }
        guard item.cellHeightLayoutType == .resetLayout else { return }
        self.setNeedUpdate()
        updater.performBatch(animated: true, updates: updates, completion: { _ in })
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
        return self.calculateAutoLayoutHeight(contentWidth)
    }
}
