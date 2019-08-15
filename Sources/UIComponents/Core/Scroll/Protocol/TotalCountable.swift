//
//  TotalCountable.swift
//  UIComponents
//
//  Created by Apple on 2019/8/15.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol TotalCountable {
    /// ZJaDe: item总数量
    var totalCount: Int {get}
}
public extension TotalCountable {
    /// ZJaDe: 是否是多个数据
    var isMultipleData: Bool {
        return self.totalCount > 1
    }
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
        guard self.totalCount > 0 && length > 0 else { return 0 }
        let realOffset = offSet.truncatingRemainder(dividingBy: length * self.totalCount.toCGFloat)
        return realOffset / length
    }
}
