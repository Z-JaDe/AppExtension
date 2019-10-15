//
//  UIViewController+ViewState.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewWillLayoutSubviews: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewWillLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
    var viewDidLayoutSubviews: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.viewDidLayoutSubviews)).map { _ in }
        return ControlEvent(events: source)
    }
}
public extension Reactive where Base: UIViewController {
    var willMove: ControlEvent<UIViewController?> {
        let source = self.sentMessage(#selector(Base.willMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    var didMove: ControlEvent<UIViewController?> {
        let source = self.sentMessage(#selector(Base.didMove)).map { $0.first as? UIViewController }
        return ControlEvent(events: source)
    }
    var didReceiveMemoryWarning: ControlEvent<Void> {
        let source = self.sentMessage(#selector(Base.didReceiveMemoryWarning)).map { _ in }
        return ControlEvent(events: source)
    }
}
