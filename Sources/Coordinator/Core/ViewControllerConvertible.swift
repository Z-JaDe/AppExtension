//
//  ViewControllerConvertible.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/// ZJaDe: 控制器协议
public protocol ViewControllerConvertible: class {
    var rootViewController: UIViewController? { get }
}
/// ZJaDe: 控制器协议，实现时只要有viewCon属性即可
public protocol AssociatedViewControllerConvertible: ViewControllerConvertible {
    associatedtype ViewControllerType: UIViewController
    var viewCon: ViewControllerType? {get}
}
extension AssociatedViewControllerConvertible {
    public var rootViewController: UIViewController? {
        return self.viewCon
    }
}
public extension ViewControllerConvertible {
    func pop() {
        self.rootViewController?.popVC()
    }
}

extension UIViewController: ViewControllerConvertible {
    public var rootViewController: UIViewController? {
        return self
    }
}
