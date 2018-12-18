//
//  UpdateDataProtocol.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/6.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

public protocol UpdateDataProtocol: class {
    /// ZJaDe: 更新数据
    func updateData()
    func setNeedUpdateData()
    func setNeedUpdateDataObserver() -> AnyObserver<Void>
}
public extension UpdateDataProtocol {
    func setNeedUpdateDataObserver() -> AnyObserver<Void> {
        return AnyObserver(eventHandler: { (event) in
            switch event {
            case .next: self.setNeedUpdateData()
            case .completed, .error: break
            }
        })
    }
}
public extension UpdateDataProtocol where Self: UIViewController {
    func setNeedUpdateData<P: ObservableType>(_ pauser: P) where P.E == Bool {
        let tag = "isNeedUpdateData"
        self.resetDisposeBagWithTag(tag)
        Observable.just(())
            .pausableBuffered(pauser)
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribeOnNext { [weak self] in
                guard let `self` = self else { return }
                self.updateData()
            }.disposed(by: self.disposeBagWithTag(tag))
    }
}
