//
//  UIWindow+Rx.swift
//  AppExtensionTests
//
//  Created by ZJaDe on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

extension Reactive where Base: UIWindow {

    public var windowDidAppear: Observable<Void> {
        self.sentMessage(#selector(Base.makeKeyAndVisible)).mapToVoid()
    }

}
