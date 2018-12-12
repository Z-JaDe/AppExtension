//
//  CurrentIndexProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/12.
//  Copyright © 2018 ZJaDe. All rights reserved.
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
