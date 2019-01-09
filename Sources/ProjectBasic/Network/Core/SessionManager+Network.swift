//
//  SessionManager.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/9.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
extension SessionManager {
    /// ZJaDe: 不会发送onCompleted
    public func checkNetwork<T>(_ value: T) -> Observable<T> {
        /// ZJaDe: 这里不能使用self.monitorNetwork().map的方式，因为monitorNetwork发射完onNext(true)会紧接着发射onCompleted
        return Observable.create({ (observer) -> Disposable in
            let dispose = self.monitorNetwork().subscribeOnNext({ (hasNetwork) in
                if hasNetwork {
                    observer.onNext(value)
                } else {
                    observer.onError(NetworkError.noNetwork)
                }
            })
            return Disposables.create([dispose])
        })
    }
    private func monitorNetwork() -> Observable<Bool> {
        return Observable.create({ (observer) -> Disposable in
            let monitorNetwork = MonitorNetwork.shared
            if monitorNetwork.isListening {
                let disposable = monitorNetwork.networkChanged.subscribeOnNext({ (status) in
                    switch status {
                    case .notReachable, .unknown:
                        observer.onNext(false)
                    case .reachable:
                        observer.onNext(true)
                        observer.onCompleted()
                    }
                })
                return Disposables.create([disposable])
            } else {
                observer.onNext(true)
                observer.onCompleted()
                return Disposables.create()
            }
        })
    }
}
