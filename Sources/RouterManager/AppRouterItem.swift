//
//  AppRouterItem.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/21.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

public struct AppRouterItem: Equatable {
    let key: String
    public init(_ key: String) {
        self.key = key
    }
    public static func == (lhs: AppRouterItem, rhs: AppRouterItem) -> Bool {
        return lhs.key == rhs.key
    }
}

public protocol RouterUrlConverterProtocol {
    func decode(_ routerUrl: RouterUrl)
}
