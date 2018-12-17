//
//  Flow.swift
//  NavigationFlow
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
public protocol Flow: Presentable {
    func navigate(to step: Step) -> NextFlowItems
    var root: Presentable { get }
}
private var flowReadyKey: UInt8 = 0
extension Flow {
    internal var flowReadySubject: PublishSubject<Bool> {
        return associatedObject(&flowReadyKey, createIfNeed: PublishSubject<Bool>())
    }
    public var rxFlowReady: Single<Bool> {
        return self.flowReadySubject.take(1).asSingle()
    }
}
