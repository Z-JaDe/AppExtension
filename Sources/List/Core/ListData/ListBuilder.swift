//
//  ListBuilder.swift
//  AppExtension
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
// TODO: reloadData一个分区时报错
@_functionBuilder
public struct ListBuilder<Section, Item> {
    public typealias _Component<I> = (Section, [I])
    public typealias Component = _Component<Item>
    public typealias Components = ListData<Section, Item>
    ///不知原因 无效
    public static func buildBlock() -> Components {
        return []
    }
    ///不知原因 无效
    public static func buildBlock(_ content: Component) -> Components {
        return Components(content)
    }
    public static func buildBlock(_ content: Component...) -> Components {
        return Components(content.map(SectionData.init))
    }
}
extension ListBuilder {
    public static func buildBlock(_ content: Components...) -> Components {
        return Components(content.flatMap({$0}))
    }
}
extension ListBuilder {
    public static func buildIf(_ content: Component?) -> Components {
        if let content = content {
            return Components(content)
        } else {
            return []
        }
    }
    public static func buildIf(_ content: Components?) -> Components {
        if let content = content {
            return content
        } else {
            return []
        }
    }
}

// MARK: -
public extension ListDataUpdateProtocol {
    typealias ListItemBuilder = ListBuilder<Section, Item>
    func reloadData(@ListItemBuilder content: () -> _ListData) {
        self.reloadData(content())
    }
}
public extension ListBuilder where Item == AnyTableAdapterItem {
    static func buildBlock(_ content: _Component<StaticTableItemCell>...) -> Components {
        return Components(content.map(SectionData.init))
    }
    static func buildBlock(_ content: _Component<TableItemModel>...) -> Components {
        return Components(content.map(SectionData.init))
    }
}

extension SectionData where Item == AnyTableAdapterItem {
    public init<C: Swift.Collection>(_ section: Section, _ elements: C) where C.Element == StaticTableItemCell {
        self.init(section, elements.map(AnyTableAdapterItem.cell))
    }
    public init<C: Swift.Collection>(_ section: Section, _ elements: C) where C.Element == TableItemModel {
        self.init(section, elements.map(AnyTableAdapterItem.model))
    }
}
