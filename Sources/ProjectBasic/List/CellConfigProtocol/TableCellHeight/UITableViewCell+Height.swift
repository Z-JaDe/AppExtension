//
//  UITableViewCell+Height.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/11/20.
//

import Foundation
extension UITableViewCell {
    func updateHeight<Item: TableCellHeightProtocol>(_ item: Item, _ updates: (() -> Void)?) {
        guard let updater = self.jd_tableView?.updater else {
            logError("\(self)->tableView找不到")
            return
        }
        guard updater.isUpdating == false else { return }
        guard CATransform3DIsIdentity(self.layer.transform) else { return }
        if item.cellHeightLayoutType == .hasLayout {
            let oldHeight = item.tempCellHeight
            let height: CGFloat = self.height
            if abs(height - oldHeight) > 2 && height > 0 {
                logDebug("updateHeight -> \(oldHeight) to \(height)")
                item._setNeedResetCellHeight()
            }
        }
        guard item.cellHeightLayoutType == .resetLayout else { return }
        (self as? NeedUpdateProtocol)?.setNeedUpdate()
        updater.performBatch(animated: true, updates: updates, completion: { _ in })
    }
}
extension UITableViewCell {
    func getItemCellWidth(_ tableView: UITableView) -> CGFloat {
        tableView.getItemCellWidth(accessoryView, accessoryType)
    }
    /*************** 计算TableViewCell高度 ***************/
    func layoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        let result: CGFloat
        if let height = self.frameLayoutHeight(contentWidth) {
            result = height
        } else {
            result = self.autoLayoutHeight(contentWidth)
        }
        return result.flat()
    }
    /*************** 计算TableViewCell高度 ***************/
    private func frameLayoutHeight(_ contentWidth: CGFloat) -> CGFloat? {
        let viewWidth = contentWidth
        let viewHeight = self.calculateFrameHeight(viewWidth)
        return viewHeight > 0 ? viewHeight : nil
    }
    open dynamic func calculateFrameHeight(_ width: CGFloat) -> CGFloat {
        0
    }
    private func autoLayoutHeight(_ contentWidth: CGFloat) -> CGFloat {
        self.calculateAutoLayoutHeight(contentWidth)
    }
}
