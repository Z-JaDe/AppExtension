//
//  LazyGetDataTask.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/15.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
/// ZJaDe: 如果value是延时获取的，可能需要用到这个task。如果value是通过网络请求的，可以实现requestClosure
public class LazyGetDataTask<Value: Equatable>: DisposeBagProtocol {
    public init() {}
    enum RSARequestState {
        case noRequest
        case inRequest

        func canRequest() -> Bool {
            switch self {
            case .inRequest:
                return false
            case .noRequest:
                return true
            }
        }
    }
    enum Result<Value> {
        case success(Value)
        case failure(Error)
        init(value: Value) {
            self = .success(value)
        }
    }
    private let valueSubject: PublishSubject<()> = PublishSubject()
    /// ZJaDe: value负责记录，同时控制信号发送
    var result: Result<Value?> = Result(value: nil) {
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

    private var requestState: RSARequestState = .noRequest
    public var requestClosure: ((AnyObserver<Value?>) -> Void)?
    /// ZJaDe: 手动设置value 发射信号
    public func change(_ value: Value) {
        self.result = .success(value)
    }
    /// ZJaDe: value重置为nil 不发射信号，下次获取时再request数据
    public func cleanValue() {
        self.result = .success(nil)
        self.requestState = .noRequest
    }
    /// ZJaDe: value重置为nil 不发射信号，但是会马上request数据
    public func resetValue() {
        self.cleanValue()
        self.requestIfNeed()
    }

    public func valueObservable(whenError: ErrorEventHandle = .never) -> Observable<Value> {
        self.valueSubject
            .observeOn(MainScheduler.asyncInstance)
            .flatMapLatest({[weak self] (_) -> Observable<Value> in
                guard let self = self else {
                    throw AppError.deallocError
                }
                switch self.result {
                case .failure(let error):
                    switch whenError {
                    case .complete: return .empty()
                    case .error: throw error
                    case .never: return .never()
                    }
                case .success(let value):
                    if let value = value {
                        return .just(value)
                    } else {
                        return .never()
                    }
                }
            }).do(onSubscribed: { [weak self] in
                guard let self = self else { return }
                if let value = self.value {
                    DispatchQueue.main.async {
                        self.result = .success(value)
                    }
                } else {
                    self.requestIfNeed()
                }
            })
            .distinctUntilChanged()
            .logDebug("task: \(Value.self), \(String(describing: self.value))")
    }
    func requestIfNeed() {
        guard self.requestState.canRequest() else {
            return
        }
        if let requestClosure = self.requestClosure {
            self.requestState = .inRequest
            requestClosure(AnyObserver<Value?> { (event) in
                switch event {
                case .next(let value):
                    self.result = .success(value)
                    self.requestState = .noRequest
                case .error(let error):
                    self.result = .failure(error)
                    self.requestState = .noRequest
                case .completed:
                    break
                }
            })
        }

    }
}
