//
//  ListBuilder.swift
//  AppExtension
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

@_functionBuilder
public struct ListBuilder<Section, Item> {
    public typealias _Component<I> = (Section, [I])
    public typealias Component = _Component<Item>
    public typealias Components = ListData<Section, Item>

    public static func buildBlock(_ content: Component...) -> Components {
        return Components(content.map(SectionData.init))
    }
    public static func buildBlock(_ content: Components...) -> Components {
        return Components(content.flatMap({$0}))
    }
}
extension ListBuilder {
    public static func buildIf(_ content: Component?) -> Components {
        content.map(Components.init) ?? []
    }
    public static func buildIf(_ content: Components?) -> Components {
        content ?? []
    }
    public static func buildEither(first: Component) -> Components {
        [first]
    }
    public static func buildEither(second: Component) -> Components {
        [second]
    }
    public static func buildEither(first: Components) -> Components {
        first
    }
    public static func buildEither(second: Components) -> Components {
        second
    }
}

// MARK: -
public extension ListDataUpdateProtocol {
    typealias ListItemBuilder = ListBuilder<Section, Item>
    func reloadData(@ListItemBuilder content: () -> _ListData) {
        self.reloadData(content())
    }
}
