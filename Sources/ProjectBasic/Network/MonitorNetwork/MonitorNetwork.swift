//
//  MonitorNetwork.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/20.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public class MonitorNetwork {
    public static let shared: MonitorNetwork = MonitorNetwork()
    private init() {}

    public let networkChanged: ReplaySubject<NetworkReachabilityManager.NetworkReachabilityStatus> = ReplaySubject.create(bufferSize: 1)
    public private(set) var isListening: Bool = false
    private var manager: NetworkReachabilityManager?
    public func startListening(host: String) {
        guard let manager = NetworkReachabilityManager() else {
            return
        }
        self.manager = manager
        isListening = true
        manager.listener = {[weak self] (status) in
            self?.networkChanged.onNext(status)
            switch status {
            case .notReachable, .unknown:
                logWarn("网络状态: 不可用")
            case .reachable(let connectionType):
                switch connectionType {
                case .ethernetOrWiFi:
                    logWarn("网络状态: ethernetOrWiFi")
                case .wwan:
                    logWarn("网络状态: wwan")
                }
            }
        }
        manager.listener?(manager.networkReachabilityStatus)
        manager.startListening()
    }
    /// ZJaDe: 监听这个信号 true时有网络 false没有网络
    public func hasNetwork() -> Observable<Bool> {
        return self.networkChanged.flatMapLatest { (status) -> Observable<Bool> in
            switch status {
            case .notReachable, .unknown:
                return .just(false)
            case .reachable:
                return .just(true)
            }
        }
    }
    /// ZJaDe: 检查是否有网络 有网络就回调
    public func checkHasNetwork(_ closure: @escaping (Bool) -> Void) {
        self.hasNetwork().take(1).subscribeOnNext { (hasNetwork) in
            closure(hasNetwork)
            if hasNetwork {
            } else {
                HUD.showError("无网络")
            }
        }.disposed(by: globalDisposeBag)
    }
}
