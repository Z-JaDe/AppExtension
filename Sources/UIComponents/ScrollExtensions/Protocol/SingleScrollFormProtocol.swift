//
//  SingleScrollFormProtocol.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/6/27.
//

import Foundation

public protocol SingleScrollFormProtocol: SingleFormProtocol {
    associatedtype CellType
    /// ZJaDe: 检查cells的消失和出现
    func checkCells(_ isNeedResetData: Bool)

    /// ZJaDe: 提前加载cell的数量
    var cacheAppearCellCount: Int {get}
    /// ZJaDe: 加载cell
    func loadCell(_ currentOffset: CGFloat, _ indexOffset: Int, _ isNeedResetData: Bool)
    /// ZJaDe: cell快出现时 配置数据
    func willAppear(_ cell: CellType, offSet: CGFloat, isToRight: Bool)
}

public extension SingleScrollFormProtocol {
    /// ZJaDe: 检查cells的消失和出现
    func checkCells(_ isNeedResetData: Bool = false) {
        checkWillAppearCells(isNeedResetData)
    }
    var cacheAppearCellCount: Int {
        return 0
    }
    /// ZJaDe: 检查快出现的cells
    func checkWillAppearCells(_ isNeedResetData: Bool = false) {
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
//                logDebug("加载左边cell\(itemOffSet)->\($0)->isNeedResetData: \(isNeedResetData)")
                loadCell(itemOffSet, $0, isNeedResetData)
            }
        }
        do {
            /// ZJaDe: 右边的cells加载
            let itemOffSet = (self.scrollView.viewTailOffset() - 1).floorToNearest(increment: length)
            (0...count).forEach {
//                logDebug("加载右边cell\(itemOffSet)->\($0)->isNeedResetData: \(isNeedResetData)")
                loadCell(itemOffSet, $0, isNeedResetData)
            }
        }
    }
}
public extension SingleScrollFormProtocol {
    /// ZJaDe: 当currentIndex改变时
    func scroll(_ from: Int, _ to: Int) {
        let length = self.scrollView.length
        guard self.totalCount > 0, length > 0 else {
            return
        }
        let offSet = self.scrollView.viewCenterOffset().floorToNearest(increment: length)
        let currentIndex = (offSet / length).toInt
        var indexOffset = self.realIndex(to) - self.realIndex(currentIndex)
        if self.totalCount > 1 {
            if to > from && indexOffset < 0 {
                indexOffset += self.totalCount
            } else if to < from && indexOffset > 0 {
                indexOffset -= self.totalCount
            }
        } else {
            indexOffset = (to > from ? 1 : -1)
        }
        self.scrollView.scrollTo(offSet: offSet + indexOffset.toCGFloat * length)
    }
    func scroll(to index: Int, animated: Bool = true) {
        let length = self.scrollView.length
        guard self.totalCount > 0 && length > 0 else {
            return
        }
        let offSet = self.scrollView.viewCenterOffset().floorToNearest(increment: length)
        let currentIndex = (offSet / length).toInt
        let indexOffset = self.realIndex(index) - self.realIndex(currentIndex)
        self.scrollView.scrollTo(offSet: offSet + indexOffset.toCGFloat * length)
    }
}
