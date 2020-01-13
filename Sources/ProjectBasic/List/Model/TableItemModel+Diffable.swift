//
//  TableItemModel+Diffable.swift
//  List
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension AnyTableAdapterItem {
    public var model: TableItemModel? {
        self.value as? TableItemModel
    }
    public static func model(_ value: TableItemModel) -> AnyTableAdapterItem {
        AnyTableAdapterItem(value)
    }
}
extension TableItemModel: TableAdapterItemDiffable {
    public func isEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let source = source.model else {
            return false
        }
        return self == source
    }
}
