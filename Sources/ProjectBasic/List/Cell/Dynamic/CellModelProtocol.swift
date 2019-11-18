//
//  CellModelProtocol.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift
public protocol CellModelProtocol: ConfigModelProtocol, UpdateModelProtocol {
//    init(model: ModelType)
}
public extension CellModelProtocol where Self: ItemCell {
    func configDataWithModel() {
        self.configData(with: self.model)
        self.setNeedsLayout()
    }
    func setNeedUpdateModel() {
        setNeedUpdateModel(self.cellState.ignore(.prepare).asObservable().map {$0.isAppear}.distinctUntilChanged())
    }
}
// MARK: -
public protocol UpdateModelProtocol: class {
    func configDataWithModel()

    func setNeedUpdateModel()
    func setNeedUpdateModelObserver() -> AnyObserver<Void>
}
public extension UpdateModelProtocol {
    func setNeedUpdateModelObserver() -> AnyObserver<Void> {
        AnyObserver(eventHandler: { (event) in
            switch event {
            case .next: self.setNeedUpdateModel()
            case .completed, .error: break
            }
        })
    }
}
public extension UpdateModelProtocol where Self: NSObject {
    func setNeedUpdateModel<P: ObservableType>(_ pauser: P) where P.Element == Bool {
        let tag = "isNeedUpdateModel"
        self.resetDisposeBagWithTag(tag)
        Observable<Void>.setNeedUpdate(pauser, .milliseconds(10))
            .takeUntil(pauser.ignore(true))
            .subscribeOnNext { [weak self] in
                guard let self = self else { return }
                self.configDataWithModel()
            }.disposed(by: self.disposeBagWithTag(tag))
    }
}
