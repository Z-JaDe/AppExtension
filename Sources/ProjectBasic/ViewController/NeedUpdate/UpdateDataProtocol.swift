//
//  UpdateDataProtocol.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/6.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift

public protocol UpdateDataProtocol: class {
    /// ZJaDe: 更新数据
    func updateData()
    func setNeedUpdateData()
    func setNeedUpdateDataObserver() -> AnyObserver<Void>
}
public extension UpdateDataProtocol {
    func setNeedUpdateDataObserver() -> AnyObserver<Void> {
        AnyObserver(eventHandler: { [weak self] (event) in
            guard let self = self else { return }
            switch event {
            case .next: self.setNeedUpdateData()
            case .completed, .error: break
            }
        })
    }
}
public extension UpdateDataProtocol where Self: UIViewController {
    func setNeedUpdateData<P: ObservableType>(_ pauser: P) where P.Element == Bool {
        setNeedUpdate(pauser, tag: "isNeedUpdateData") { [weak self] in
            guard let self = self else { return }
            self.updateData()
        }
    }
}
