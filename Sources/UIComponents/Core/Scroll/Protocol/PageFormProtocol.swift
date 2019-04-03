//
//  File.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/13.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol PageFormProtocol: SingleFormProtocol {

}
extension PageFormProtocol {
    public func getCurrentProgress() -> CGFloat {
        return realProgress(offSet: self.scrollView.viewHeadOffset(), length: self.scrollView.length)
    }
    public func getCurrentIndex() -> Int {
        return getCurrentProgress().toInt
    }
    /// ZJaDe: 重新设置visibleCells在scrollView里的位置
    public func resetCellsOrigin(repeatCount: Int) {
        let length = scrollView.length
        guard self.totalCount > 0 && length > 0 else { return }
        guard repeatCount % 2 == 0 else { return }
        let scrollViewOffSet = scrollView.viewHeadOffset()
        let offSet: CGFloat
        if self.totalCount == 1 {
            offSet = 0
        } else {
            if scrollViewOffSet > length * repeatCount.toCGFloat * 0.75 * self.totalCount.toCGFloat {
                offSet = -length * (repeatCount / 2).toCGFloat * self.totalCount.toCGFloat
            } else if scrollViewOffSet < length * repeatCount.toCGFloat * 0.25 * self.totalCount.toCGFloat {
                offSet = length * (repeatCount / 2).toCGFloat * self.totalCount.toCGFloat
            } else {
                offSet = 0
            }
        }
        if offSet != 0 {
            scrollView.scrollTo(offSet: scrollViewOffSet + offSet, animated: false)
        }
    }
}
public extension PageFormProtocol {
    /// ZJaDe: 当currentIndex改变时调用，只针对Cell长度和ScrollView长度相等时
    func scroll(_ from: Int, _ to: Int) {
        let length = self.scrollView.length
        guard self.totalCount > 0, length > 0 else { return }
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
    /// ZJaDe: 滚动到对应index，只针对Cell长度和ScrollView长度相等时
    func scroll(to index: Int, animated: Bool = true) {
        let length = self.scrollView.length
        guard self.totalCount > 0 && length > 0 else { return }
        let offSet = self.scrollView.viewCenterOffset().floorToNearest(increment: length)
        let currentIndex = (offSet / length).toInt
        let indexOffset = self.realIndex(index) - self.realIndex(currentIndex)
        self.scrollView.scrollTo(offSet: offSet + indexOffset.toCGFloat * length, animated: animated)
    }
}
