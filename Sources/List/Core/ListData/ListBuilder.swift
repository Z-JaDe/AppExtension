//
//  ListBuilder.swift
//  AppExtension
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol CollectionBuilder {
    associatedtype Element
    init<C: Swift.Collection>(_ elements: C) where C.Element == Element
}

@_functionBuilder
public struct ListBuilder<S, L: CollectionBuilder> where L.Element == S {
    public static func buildBlock() -> L? {
        return nil
    }
    public static func buildBlock(_ content: S...) -> L {
        return L(content)
    }
//
//    public static func buildIf(_ content: S?) -> S? {
//        return content
//    }
//    public static func buildEither(first: S) -> L {
//        
//    }
}
