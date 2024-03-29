//
//  TitleItemDesignable.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol TitleItemDesignable {
    associatedtype TitleItemType
    var titleItem: TitleItemType {get}
    func configTitleItem()
}
