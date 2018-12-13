//
//  BottomItemDesignable.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol BottomItemDesignable {
    associatedtype BottomItemType
    var bottomItem: BottomItemType {get}
    func configBottomItem()
}