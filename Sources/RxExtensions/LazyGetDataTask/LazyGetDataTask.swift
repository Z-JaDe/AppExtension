//
//  LazyGetDataTask.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/15.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/// ZJaDe: 如果value是延时获取的，可能需要用到这个task。如果value是通过网络请求的，可以实现requestClosure
public class LazyGetDataTask<Value: Equatable>: DisposeBagProtocol {
    public init() {}
    enum RSARequestState {
        case initialized
        case requestIng
        case finished

        func canRequest() -> Bool {
            switch self {
            case .initialized, .finished: return true
            case .requestIng: return false
            }
        }
    }
    private let valueSubject: PublishSubject<()> = PublishSubject()
    /// ZJaDe: value负责记录，同时控制信号发送
    var result: Result<Value?, Error> = .success(nil) {
        didSet {
            switch result {
            case .success(let value):
                if value != nil {
                    self.valueSubject.onNext(())
                }
            case .failure:
                self.valueSubject.onNext(())
            }
        }
    }
    public var value: Value? {
        switch result {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    private var requestState: RSARequestState = .initialized
    public var requestClosure: ((AnyObserver<Value?>) -> Void)?
    /// ZJaDe: 手动设置value 发射信号
    public func change(_ value: Value) {
        self.result = .success(value)
    }
    /// ZJaDe: value重置为nil 不发射信号，下次获取时再request数据
    public func cleanValue() {
        self.result = .success(nil)
        self.requestState = .initialized
    }
    /// ZJaDe: value重置为nil 不发射信号，但是会马上request数据
    public func resetValue() {
        self.cleanValue()
        self.requestIfNeed()
    }
    public enum ErrorEventHandle {
        case error
        case complete
        case never
    }
    public func valueObservable(whenError: ErrorEventHandle = .never) -> Observable<Value> {
        Observable<Value>.create { (observer) -> Disposable in
            let disposable = self.valueSubject.observe(on: MainScheduler.asyncInstance).subscribeOnNext({ [weak self] (_) in
                guard let self = self else {
                    observer.onError(AppError.deallocError)
                    return
                }
                switch self.result {
                case .failure(let error):
                    switch whenError {
                    case .complete: observer.onCompleted()
                    case .error: observer.onError(error)
                    case .never: break
                    }
                case .success(let value):
                    if let value = value {
                        observer.onNext(value)
                    }
                }
            })
            if let value = self.value { // 不使用ReplaySubject 是因为result的failure不想被新的订阅信号直接接收
                self.result = .success(value)
            } else {
                self.requestIfNeed()
            }
            defer {
            }
            return Disposables.create([disposable])
        }.distinctUntilChanged().logDebug("task: \(Value.self), \(String(describing: self.value))")
    }
    func requestIfNeed() {
        guard self.requestState.canRequest() else {
            return
        }
        if let requestClosure = self.requestClosure {
            self.requestState = .requestIng
            requestClosure(AnyObserver<Value?> { (event) in
                switch event {
                case .next(let value):
                    self.result = .success(value)
                    self.requestState = .finished
                case .error(let error):
                    self.result = .failure(error)
                    self.requestState = .finished
                case .completed:
                    break
                }
            })
        }

    }
}
