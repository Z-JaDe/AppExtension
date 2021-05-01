//
//  Presentable.swift
//  AppExtension
//
//  Created by 郑军铎 on 2020/3/22.
//

import Foundation

extension UIViewController: Presentable {
    public func asPresentItem() -> UIViewController? {
        self
    }
}
// MARK: -
public protocol PresentItemConvertible: AnyObject {
    func asPresentItem() -> UIViewController?
}
public protocol AbstractPresentItemConvertible: PresentItemConvertible {
    associatedtype PresentItemType: UIViewController
    var presentItemViewCon: PresentItemType? {get}
}
extension AbstractPresentItemConvertible {
    public func asPresentItem() -> UIViewController? {
        self.presentItemViewCon
    }
}
// MARK: -
public protocol Presentable: PresentItemConvertible {
    func present(_ item: PresentItemConvertible, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
public extension Presentable {
    func present(_ item: PresentItemConvertible, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard let rootViewCon = item.asPresentItem() else { return }
            if rootViewCon.isBeingDismissed || rootViewCon.isBeingPresented == false {
                self.asPresentItem()?.present(rootViewCon, animated: animated, completion: completion)
            } else {
                assertionFailure("控制器已经显示")
            }
        }
    }
    /// ZJaDe: 不一定会调用这个方法，有可能控制器自己调用了dismiss，比如实现了CanCancelModalViewController协议时
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            guard let rootViewCon = self.asPresentItem() else { return }
            if rootViewCon.isBeingPresented || rootViewCon.isBeingDismissed == false {
                rootViewCon.dismiss(animated: animated, completion: completion)
            } else {
                assertionFailure("控制器已经消失")
            }
        }
    }
}
