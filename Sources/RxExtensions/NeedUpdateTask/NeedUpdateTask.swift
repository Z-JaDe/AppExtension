//
//  NeedUpdateTask.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/9/19.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import FunctionalSwift

@available(iOS, deprecated: 9.0, message: "可以使用 pausableBuffered")
public class NeedUpdateTask {
    let buffer: DispatchTimeInterval
    public init(buffer: DispatchTimeInterval = .microseconds(0)) {
        self.buffer = buffer
    }
    /// ZJaDe: 只是标记需要更新，但是想要更新还是要等到limit通过
    private let needUpdateSubject: ReplaySubject<Void> = ReplaySubject.create(bufferSize: 1)
    private var isNeedUpdate: Bool = false

    public func setNeedUpdate() {
        if self.isNeedUpdate == false {
            self.isNeedUpdate = true
            self.needUpdateSubject.onNext(())
        }
    }
    public func setNeedUpdateObserver() -> AnyObserver<Void> {
        AnyObserver(eventHandler: { (event) in
            switch event {
            case .next: self.setNeedUpdate()
            case .completed, .error: break
            }
        })
    }
    /// ZJaDe: 如果已被标记更新 直接更新
    private let updateSubject: ReplaySubject<Void> = ReplaySubject.create(bufferSize: 1)
    public func updateIfNeed() {
        updateSubject.onNext(())
    }
    /// ZJaDe: 
    public var updateClosure: (() -> Void)?

    private var limitObservableArr: [Observable<Bool>] = [] {
        didSet {updateStreamObserver()}
    }
    private var updateStreamDisposeBag: DisposeBag = DisposeBag()
    func updateStreamObserver() {
        updateStreamDisposeBag = DisposeBag()

        needUpdateSubject.flatMapLatest {[weak self] () -> Observable<Void> in
            guard let self = self else {
                throw AppError.deallocError
            }
            return Observable.merge(Observable.combineLatest(self.limitObservableArr)
                .map({$0.isTrue()})
                .filter {$0}.mapToVoid(), self.updateSubject)
            }
            .throttle(self.buffer, scheduler: MainScheduler.asyncInstance)
            .subscribeOnNext({[weak self] () in
                guard let self = self else { return }
                guard self.isNeedUpdate else { return }
                self.updateClosure?()
                self.isNeedUpdate = false
            }).disposed(by: self.updateStreamDisposeBag)
//
//        Observable.of(limitObservable, updateSubject)
//            .merge()
//            .filter({[weak self] in return self.isNeedUpdate})
//            .subscribeOnNext({[weak self] (_) in
//            }).disposed(by: self.updateStreamDisposeBag)

    }
    public func configLimitObservableArr(_ limitObservableArr: [Observable<Bool>]) {
        self.limitObservableArr = limitObservableArr
    }
}
