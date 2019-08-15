//
//  CollectionViewable+CurrentIndex.swift
//  UIComponents
//
//  Created by Apple on 2019/8/15.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public extension CollectionViewable {
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
