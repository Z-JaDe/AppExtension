//
//  SingleFormProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/25.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
public protocol CurrentIndexProtocol: class {
    /// ZJaDe: 当前index
    var currentIndex: Int {get set}
}
public extension CurrentIndexProtocol {
    //    /// ZJaDe: 根据item数量计算出的真实currentIndex
    //    var currentIndex: Int {
    //        get {return self.realIndex(self._currentIndex)}
    //    }

    //    func changeCurrentIndex(_ index: Int) {
    //        self.currentIndex = index
    //    }
    func scrollNextIndex() {
        self.currentIndex += 1
    }
    func scrollPreviousIndex() {
        self.currentIndex -= 1
    }
}
public protocol TotalCountProtocol {
    /// ZJaDe: item总数量
    var totalCount: Int {get}
}
public extension TotalCountProtocol {
    /// ZJaDe: 根据totalCount返回realIndex
    func realIndex(_ index: Int) -> Int {
        guard self.totalCount > 0 else {
            return 0
        }
        var index = index
        while index < 0 {
            index += self.totalCount
        }
        return index % self.totalCount
    }
    /** ZJaDe: 
     根据totalCount和布局方向返回realProgress
     realProgress可以直接toInt转换成realIndex
     */
    func realProgress(offSet: CGFloat, length: CGFloat) -> CGFloat {
        guard self.totalCount > 0 else {
            return 0
        }
        guard length > 0 else {
            return 0
        }
        let realOffset = offSet.truncatingRemainder(dividingBy: length * self.totalCount.toCGFloat)
        return realOffset / length
    }
}
public protocol SingleFormProtocol: CurrentIndexProtocol, TotalCountProtocol {
    associatedtype CellType
}
