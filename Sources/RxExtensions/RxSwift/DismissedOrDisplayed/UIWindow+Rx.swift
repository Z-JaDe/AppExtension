//
//  UIWindow+Rx.swift
//  AppExtensionTests
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: UIWindow {

    public var windowDidAppear: Observable<Void> {
        self.sentMessage(#selector(Base.makeKeyAndVisible)).mapToVoid()
    }

}
