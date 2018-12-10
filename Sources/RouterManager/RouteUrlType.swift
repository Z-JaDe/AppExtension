//
//  RouteUrlType.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/17.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

public typealias CallBackNoParams = () -> Void
public typealias CallBack<Params> = (Params) -> Void

public protocol RouteUrlType {
    func createViewCon(_ manager: RouterManager) -> UIViewController?
}
/// ZJaDe: 如果使用类的方式写 可以继承BaseRoute
open class BaseRoute: RouteUrlType {
    public typealias ClosureType = (RouterManager) -> UIViewController?
    private let closure: ClosureType
    public required init(_ closure: @escaping ClosureType) {
        self.closure = closure
    }
    public static func create(_ closure: @escaping ClosureType) -> Self {
        return self.init(closure)
    }
    open func createViewCon(_ manager: RouterManager) -> UIViewController? {
        return self.closure(manager)
    }
}

/// ZJaDe: 也可以遵循协议后 直接返回UIViewController
extension RouteUrlType where Self: UIViewController {
    public func createViewCon(_ manager: RouterManager) -> UIViewController? {
        return self
    }
}
