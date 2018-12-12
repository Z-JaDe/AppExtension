//
//  SingleFormProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/25.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
public protocol SingleFormProtocol: CurrentIndexProtocol, TotalCountProtocol {
}
extension SingleFormProtocol {
    /// ZJaDe: 重新设置visibleItemViews在scrollView里的位置
    public func resetItemViewsLocation(repeatCount: Int = 1, in scrollItem: OneWayScrollProtocol) {
        let length = scrollItem.length
        guard self.totalCount > 0 && length > 0 else { return }
        guard repeatCount % 2 == 0 else { return }
        let scrollViewOffSet = scrollItem.viewHeadOffset()
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
            scrollItem.scrollTo(offSet: scrollViewOffSet + offSet, animated: false)
        }
    }
}
