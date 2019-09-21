//
//  ListBuilder.swift
//  AppExtension
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
// TODO: reloadData一个分区时报错 正式版XCode11出来后 看看能优化不
extension ListDataUpdateProtocol {
    typealias ListItemBuilder = ListBuilder<(Section, [Item])>
    public func reloadData(@ListItemBuilder content: () -> [(Section, [Item])]) {
        self.reloadData(ListDataType(content().map(SectionData.init)))
    }
}

@_functionBuilder
public struct ListBuilder<T> {
    public static func buildBlock(_ children: T...) -> [T] {
        return children
    }
//    public static func buildExpression(_ expression: T) -> [T] {
//        return [expression]
//    }
//    public static func buildBlock(_ children: T) -> [T] {
//        return [children]
//    }
//    public static func buildBlock(_ children: [T]...) -> [T] {
//        return children.flatMap { $0 }
//    }
//    public static func buildBlock(_ component: T) -> T {
//        return component
//    }
}
