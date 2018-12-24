//
//  Coordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/10/31.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
#if !AppExtensionPods
@_exported import Core
#endif
/** ZJaDe:
 Coordinator 项目中 一般 一个Coordinator代表UI逻辑
 Coordinator可以由Flow来初始化
 */
public typealias ViewConCoordinator = Coordinator & Flow
public protocol Coordinator: class {

}
public protocol CoordinatorContainer: class {
    var coordinators: [Coordinator] { get set}
}

public extension CoordinatorContainer {
    func addChild(_ coordinator: Coordinator) {
        coordinators.append(coordinator)
    }
    func removeChild(_ coordinator: Coordinator) {
        coordinators = coordinators.filter { $0 !== coordinator }
    }
    func removeAll() {
        coordinators.removeAll()
    }
    func child<T: Coordinator>(_ type: T.Type) -> T? {
        if let result = self.coordinators.lazy.compactMap({$0 as? T}).first {
            return result
        }
        return nil
    }
    func findChild<T: Coordinator>(_ type: T.Type) -> T? {
        if let result = self.coordinators.lazy.compactMap({$0 as? T}).first {
            return result
        } else {
            return self.coordinators.lazy.compactMap({ ($0 as? CoordinatorContainer)?.findChild(type) }).first
        }
    }
}
