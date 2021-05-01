//
//  PageViewable.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/6/25.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
public struct TapContext<View: UIView, Data> {
    public let view: View
    public let data: Data
    public let index: Int
    public init(view: View, data: Data, index: Int) {
        self.view = view
        self.data = data
        self.index = index
    }
}
public protocol CollectionViewable: AnyObject, TotalCountable {
    associatedtype ScrollViewType: OneWayScrollable
    var scrollView: ScrollViewType {get}
    associatedtype CellView: UIView
    associatedtype CellData

    /// ZJaDe: 当前index
    var currentIndex: Int {get set}
}

public extension CollectionViewable {
    func getCurrentProgress() -> CGFloat {
        realProgress(offSet: self.scrollView.viewHeadOffset(), length: self.scrollView.length)
    }
    func getCurrentIndex() -> Int {
        getCurrentProgress().int
    }
    /// ZJaDe: 重新设置visibleCells在scrollView里的位置
    func resetCellsOrigin(repeatCount: Int) {
        let totalCount = self.totalCount
        let length = scrollView.length
        guard totalCount > 0 && length > 0 else { return }
        guard repeatCount % 2 == 0 else { return }
        let scrollViewOffSet = scrollView.viewHeadOffset()
        let offSet: CGFloat
        if totalCount == 1 {
            offSet = 0
        } else {
            let totalOffset = length * repeatCount.cgfloat * totalCount.cgfloat
            if scrollViewOffSet > totalOffset * 0.75 {
                offSet = -totalOffset * 0.5
            } else if scrollViewOffSet < totalOffset * 0.25 {
                offSet = totalOffset * 0.5
            } else {
                offSet = 0
            }
        }
        if offSet != 0 {
            scrollView.scrollTo(offSet: scrollViewOffSet + offSet, animated: false)
        }
    }
}
public extension CollectionViewable {
    /// ZJaDe: 当currentIndex改变时调用，只针对Cell长度和ScrollView长度相等时
    func scroll(_ from: Int, _ to: Int) {
        let length = self.scrollView.length
        guard self.totalCount > 0, length > 0 else { return }
        let offSet = self.scrollView.viewCenterOffset().floorToNearest(increment: length)
        let currentIndex = (offSet / length).int
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
        self.scrollView.scrollTo(offSet: offSet + indexOffset.cgfloat * length)
    }
    /// ZJaDe: 滚动到对应index，只针对Cell长度和ScrollView长度相等时
    func scroll(to index: Int, animated: Bool = true) {
        let length = self.scrollView.length
        guard self.totalCount > 0 && length > 0 else { return }
        let offSet = self.scrollView.viewCenterOffset().floorToNearest(increment: length)
        let currentIndex = (offSet / length).int
        let indexOffset = self.realIndex(index) - self.realIndex(currentIndex)
        self.scrollView.scrollTo(offSet: offSet + indexOffset.cgfloat * length, animated: animated)
    }
}
