//
//  EmptyDataSet+Rx.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/7.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

#if canImport(RxSwift)
import RxSwift
#if !AppExtensionPods
import RxExtensions
#endif
extension EmptyDataSetView {
    func whenEmptyStateChanged(_ closure: @escaping CallBack<EmptyViewState>) {
        self.emptyStateChangedObserver().subscribe(onNext: closure).disposed(by: self.disposeBag)
    }
    func emptyStateChangedObserver() -> Observable<EmptyViewState> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let `self` = self else {
                return Disposables.create()
            }
            self.emptyStateChanged = { (state) in
                observer.onNext(state)
            }
            return Disposables.create()
        })
            .share(replay: 1)
            .observeOn(MainScheduler.instance)
            .delay(0.1, scheduler: MainScheduler.instance)
            .throttle(0.5, scheduler: MainScheduler.instance)
    }
}
#else
extension EmptyDataSetView {
    func whenEmptyStateChanged(_ clsoure: @escaping CallBack<EmptyViewState>) {
        self.emptyStateChanged = clsoure
    }
}
#endif
