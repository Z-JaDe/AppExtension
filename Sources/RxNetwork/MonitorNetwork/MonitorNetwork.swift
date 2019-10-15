//
//  MonitorNetwork.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/20.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public class MonitorNetwork {
    public static let shared: MonitorNetwork = MonitorNetwork()
    private init() {}
    let disposeBag: DisposeBag = DisposeBag()

    public let networkChanged: ReplaySubject<NetworkReachabilityManager.NetworkReachabilityStatus> = ReplaySubject.create(bufferSize: 1)
    public private(set) var isListening: Bool = false
    private var manager: NetworkReachabilityManager?
    public func startListening(host: String) {
        guard let manager = NetworkReachabilityManager() else {
            return
        }
        self.manager = manager
        isListening = true
        manager.startListening {[weak self] (status) in
            self?.networkChanged.onNext(status)
            switch status {
            case .notReachable, .unknown:
                logWarn("网络状态: 不可用")
            case .reachable(let connectionType):
                switch connectionType {
                case .ethernetOrWiFi:
                    logWarn("网络状态: ethernetOrWiFi")
                case .cellular:
                    logWarn("网络状态: cellular")
                }
            }
        }
    }
    /// ZJaDe: 监听这个信号 true时有网络 false没有网络
    public func hasNetwork() -> Observable<Bool> {
        self.networkChanged.map { (status) -> Bool in
            switch status {
            case .notReachable, .unknown:
                return false
            case .reachable:
                return true
            }
        }
    }
    /// ZJaDe: 检查是否有网络 有网络就回调
    public func checkHasNetwork(_ closure: @escaping (Bool) -> Void) {
        self.hasNetwork().take(1).subscribe(onNext: closure).disposed(by: disposeBag)
    }
}
