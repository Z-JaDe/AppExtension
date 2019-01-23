//
//  CellModelProtocol.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift
public protocol CellModelProtocol: ConfigModelProtocol, UpdateModelProtocol {
    init(model: ModelType)
}
public extension CellModelProtocol where Self: ItemCell {
    func configDataWithModel() {
        self.configData(with: self.model)
        self.setNeedsLayout()
    }
    func setNeedUpdateModel() {
        setNeedUpdateModel(self.cellState.asObservable().map {$0.isAppear}.distinctUntilChanged())
    }
}
// MARK: -
public protocol UpdateModelProtocol: class {
    func configDataWithModel()

    func setNeedUpdateModel()
    func updateModelIfNeed()
    func setNeedUpdateModelObserver() -> AnyObserver<Void>
}
public extension UpdateModelProtocol {
    func setNeedUpdateModelObserver() -> AnyObserver<Void> {
        return AnyObserver(eventHandler: { (event) in
            switch event {
            case .next: self.setNeedUpdateModel()
            case .completed, .error: break
            }
        })
    }
    func updateModelIfNeed() {
        configDataWithModel()
    }
}
public extension UpdateModelProtocol where Self: NSObject {
    func setNeedUpdateModel<P: ObservableType>(_ pauser: P) where P.E == Bool {
        let tag = "isNeedUpdateModel"
        self.resetDisposeBagWithTag(tag)
        Observable<Void>.setNeedUpdate(pauser, 0.01)
            .subscribeOnNext { [weak self] in
                guard let `self` = self else { return }
                self.configDataWithModel()
            }.disposed(by: self.disposeBagWithTag(tag))
    }
}
