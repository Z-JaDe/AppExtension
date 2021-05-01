//
//  CellModelProtocol.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift
public protocol CellModelProtocol: UpdateModelProtocol {
    associatedtype ModelType
    var model: ModelType? {get set}
    /// 不能通过直接调用的方式，应该使用设置model的方式
    func configData(with model: ModelType)

    func updateWithModel()
    func update(with model: ModelType)
}
public extension CellModelProtocol {
    func updateWithModel() {
        if let model = self.model {
            self.update(with: model)
        }
    }
    func update(with model: ModelType) {
        self.model = model
    }
}
public extension CellModelProtocol where Self: ItemCell {
    func configDataWithModel() {
        if let model = self.model {
            self.configData(with: model)
            self.setNeedsLayout()
        }
    }
}
// MARK: -
#if canImport(RxSwift) && canImport(MJRefresh)
import RxSwift
public protocol UpdateModelProtocol: AnyObject {
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
public extension UpdateModelProtocol where Self: ItemCell {
    func setNeedUpdateModel() {
        setNeedUpdateModel(self.cellState.asObservable().map {$0.isAppear}.distinctUntilChanged())
    }
}
public extension UpdateModelProtocol where Self: NSObject {
    func setNeedUpdateModel<P: ObservableType>(_ pauser: P) where P.Element == Bool {
        let tag = "isNeedUpdateModel"
        _ = disposeBagWithTag(tag)
        setNeedUpdate(pauser, tag: tag, .milliseconds(10)) {[weak self] in
            guard let self = self else { return }
            self.configDataWithModel()
        }
    }
}
#endif
