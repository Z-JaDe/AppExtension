//
//  EmptyDataSetProtocol+Rx.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/7.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
#if canImport(RxSwift) && canImport(RxCocoa)
import RxSwift
import RxCocoa
#if !AppExtensionPods
import RxExtensions
#endif

extension EmptyDataSetProtocol where Self: Scrollable & UIView {
    public func addEmptyItemToSuperItemIfNeed(_ emptyDataSet: EmptyDataSetView) {
        defer {
            self.insertSubview(emptyDataSet, at: 0)
        }
        if emptyDataSet.superview == nil {
            self.insertSubview(emptyDataSet, at: 0)
            let frameObserve: Observable<CGRect?> = self.rx.observe(CGRect.self, "frame", retainSelf: false).distinctUntilChanged()
            let contentInsetObserve: Observable<UIEdgeInsets?> = self.rx.observe(UIEdgeInsets.self, "contentInset", retainSelf: false).distinctUntilChanged()

            let combineLatest: Observable<(CGRect?, UIEdgeInsets?)> = Observable
                .combineLatest(frameObserve, contentInsetObserve, resultSelector: {($0, $1)})
                .observe(on: MainScheduler.asyncInstance)
                .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
                .take(until: self.rx.deallocated)

            let disposeBag = emptyDataSet.resetDisposeBagWithTag("_emptySetUpdate")
            combineLatest.subscribeOnNext({ [weak self, weak emptyDataSet] (_) in
                guard let self = self else { return }
                guard let emptyDataSet = emptyDataSet else { return }
                var height = self.height - self.contentInset.top
                if height <= 0 {
                    height = 200
                }
                Animater().animations {
                    emptyDataSet.frame = CGRect(x: 0, y: 0, width: self.width, height: height)
                    if self.contentSize.height <= 0 {
                        self.contentSize.height = emptyDataSet.bottom
                    }
                }.animate()
            }).disposed(by: disposeBag)
        }
    }
}
#endif
