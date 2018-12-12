//
//  SingleCycleFormProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/26.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public protocol SingleCycleFormProtocol: SingleScrollFormProtocol {
    /// ZJaDe: cell单边延迟释放的个数
    var cacheDisappearCellCount: Int {get}
    /// ZJaDe: cell消失后回收
    func didDisAppear(_ cell: CellType)
}
//extension UIView {
//    open override var debugDescription: String {
//        return "\(self.hashValue) \(type(of: self)): \(self.frame))"
//    }
//}
