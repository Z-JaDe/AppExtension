//
//  CyclePageFormProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/26.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public protocol CyclePageFormProtocol: ScrollPageFormProtocol {
    /// ZJaDe: cell单边延迟释放的个数
    var cacheDisappearCellCount: Int {get}
    /// ZJaDe: cell消失后回收
    func didDisAppear(_ cell: ItemView)
}
public extension CyclePageFormProtocol where ScrollViewType == PageScrollView<ItemView> {
    /// ZJaDe: 检查cells的消失和出现
    func checkCellsLifeCycle(isNeedReset: Bool) {
        checkDidDisAppearCells()
        checkWillAppearCells(isNeedReset: isNeedReset)
    }
    var cacheDisappearCellCount: Int {
        return 0
    }
    /// ZJaDe: 检查需要消失的cells
    func checkDidDisAppearCells() {
        let length = self.scrollView.length
        guard self.totalCount > 0 && length > 0 else {
            return
        }
        // ZJaDe: 单边延迟释放的个数
        let count: CGFloat = max(cacheAppearCellCount, cacheDisappearCellCount).toCGFloat
        guard count >= 0 else {
            return
        }
        /** ZJaDe:
         释放cell条件：需要cell的边界在设定的边界之外才会释放
         */

        self.scrollView.visibleCells.forEach { (cell) in
            let segmentLayoutCell = self.scrollView.createLayoutCell(cell)
            /// ZJaDe: 0.5是为了把边界里面移一点，让刚好处于边界的cell的移除
            do {
                /// ZJaDe: 左边的cells释放
                let itemOffSet = self.scrollView.viewHeadOffset() + 0.5
                if segmentLayoutCell.trailing < itemOffSet - count * length {
                    //                    logDebug("左边\(cell.debugDescription)消失")
                    didDisAppear(cell)
                }
            }
            do {
                /// ZJaDe: 右边的cells释放
                let itemOffSet = self.scrollView.viewTailOffset() - 0.5
                if segmentLayoutCell.leading > itemOffSet + count * length {
                    //                    logDebug("右边\(cell.debugDescription)消失")
                    didDisAppear(cell)
                }
            }
        }
        //        logDebug("visibleCells: \n\(self.scrollView.visibleCells.map({"\($0.debugDescription)"}).joined(separator: "\n"))")
    }
}
//extension UIView {
//    open override var debugDescription: String {
//        return "\(self.hashValue) \(type(of: self)): \(self.frame))"
//    }
//}
