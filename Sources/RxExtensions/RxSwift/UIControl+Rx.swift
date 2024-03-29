//
//  UIControl+Rx.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/10/15.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIControl {
    @discardableResult
    public func controlEvent(_ controlEvents: UIControl.Event, _ closure: ((Base) -> Void)?) -> Disposable {
        self.controlEvent(controlEvents)
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
            .driveOnNext { [weak base] in
                guard let base = base else {return}
                closure?(base)
            }
    }

    @discardableResult
    public func valueChanged(_ closure: ((Base) -> Void)?) -> Disposable {
        self.valueChanged().subscribeOnNext {[weak base] _ in
            guard let base = base else { return }
            closure?(base)
        }
    }
    public func valueChanged() -> Observable<Void> {
        self.controlEvent(.valueChanged)
            .asDriver(onErrorJustReturn: ())
            .asObservable()
    }

    @discardableResult
    public func touchUpInside(_ closure: ((Base) -> Void)?) -> Disposable {
        self.touchUpInside().subscribeOnNext {[weak base] _ in
            guard let base = base else { return }
            closure?(base)
        }
    }
    // MARK: -
    public func touchUpInside() -> Observable<Void> {
        self.controlEvent(.touchUpInside)
            .asDriver(onErrorJustReturn: ())
            .asObservable()
    }

    @discardableResult
    public func throttleTouchUpInside(timeInterval: TimeInterval = 1, _ closure: ((Base) -> Void)?) -> Disposable {
        self.throttleTouchUpInside(timeInterval).subscribeOnNext {[weak base] _ in
            guard let base = base else {
                return
            }
            closure?(base)
        }
    }
    public func throttleTouchUpInside(_ timeInterval: TimeInterval = 1) -> Observable<Void> {
        self.touchUpInside().do(onNext: {[weak base] () in
            base?.isEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
                base?.isEnabled = true
            }
        })
    }
}
