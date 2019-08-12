//
//  ScrollPageFormProtocol.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/6/27.
//

import Foundation

public protocol ScrollPageFormProtocol: PageFormProtocol {
    /// ZJaDe: 提前加载cell的数量
    var cacheAppearCellCount: Int {get}
    /// ZJaDe: 加载cell
    func loadCell(_ currentOffset: CGFloat, _ indexOffset: Int, _ isNeedUpdate: Bool)
}

public extension ScrollPageFormProtocol {
    var cacheAppearCellCount: Int {
        return 0
    }
    /// ZJaDe: 检查快出现的cells
    func checkWillAppearCells(isNeedUpdate: Bool) {
        let length = self.scrollView.length
        guard self.totalCount > 0 && length > 0 else {
            return
        }
        // ZJaDe: 0.5是为了把边界里面移一点，防止刚好在边界的
        /** ZJaDe: 
         加载cell条件：如果对应cell的frame出现在视线内，直接加载。根据count两边提前加载几个cell
         */
        /// ZJaDe: 单边提前加载的个数
        let count: Int = self.cacheAppearCellCount
        do {
            /// ZJaDe: 左边的cells加载
            let itemOffSet = self.scrollView.viewHeadOffset().floorToNearest(increment: length)
            (-count...0).forEach {
//                logDebug("加载左边cell\(itemOffSet)->\($0)->isNeedUpdate: \(isNeedUpdate)")
                loadCell(itemOffSet, $0, isNeedUpdate)
            }
        }
        do {
            /// ZJaDe: 右边的cells加载
            let itemOffSet = (self.scrollView.viewTailOffset() - 1).floorToNearest(increment: length)
            (0...count).forEach {
//                logDebug("加载右边cell\(itemOffSet)->\($0)->isNeedUpdate: \(isNeedUpdate)")
                loadCell(itemOffSet, $0, isNeedUpdate)
            }
        }
    }
}
