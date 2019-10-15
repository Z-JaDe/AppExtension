//
//  EmptyDataSet+Rx.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/7.
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
        Observable.create({ [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.emptyStateChanged = { (state) in
                observer.onNext(state)
            }
            return Disposables.create()
        })
            .share(replay: 1)
            .observeOn(MainScheduler.instance)
            .delay(.milliseconds(100), scheduler: MainScheduler.instance)
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}
#else
extension EmptyDataSetView {
    func whenEmptyStateChanged(_ clsoure: @escaping CallBack<EmptyViewState>) {
        self.emptyStateChanged = clsoure
    }
}
#endif
