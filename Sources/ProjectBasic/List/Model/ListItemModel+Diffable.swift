//
//  ListItemModel+Diffable.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension ListItemModel: Diffable {
    public func isContentEqual(to source: ListItemModel) -> Bool {
        return self.identity == source.identity
    }
    private var identity: String {
        return "\(self.hashValue)\(self.needUpdateSentinel.value)"
    }
}
