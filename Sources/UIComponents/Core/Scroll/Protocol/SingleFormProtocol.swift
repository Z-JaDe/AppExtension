//
//  SingleFormProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/25.
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
public protocol SingleFormProtocol: CurrentIndexProtocol, TotalCountProtocol {
    associatedtype ScrollViewType: OneWayScrollProtocol
    var scrollView: ScrollViewType {get}
    associatedtype CellView: UIView
    associatedtype CellData
}
