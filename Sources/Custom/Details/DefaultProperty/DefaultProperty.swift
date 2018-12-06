//
//  DefaultProperty.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/29.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
open class DefaultProperty {
    public init() {}
}
public protocol DefaultPropertyProtocol {
    associatedtype DefaultPropertyType: DefaultProperty
    static var defaultProperty: DefaultPropertyType {get}
}
