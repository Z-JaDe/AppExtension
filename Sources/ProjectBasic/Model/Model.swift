//
//  Model.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

open class Model: Hashable {

    public init() {

    }
    // MARK: - Hashable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    public static func == (lhs: Model, rhs: Model) -> Bool {
        lhs === rhs
    }

//    deinit {
//        logDebug("\(type(of: self))->\(self)注销")
//    }
}
