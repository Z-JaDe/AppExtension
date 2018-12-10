//
//  EmptyDataSetProtocol+ScrollItem.swift
//  JDKit
//
//  Created by 茶古电子商务 on 2017/12/14.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
extension EmptyDataSetProtocol where Self: ScrollProtocol & UIView {
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
                .observeOn(MainScheduler.asyncInstance)
                .throttle(0.1, scheduler: MainScheduler.instance)
                .takeUntil(self.rx.deallocated)

            emptyDataSet.frameDisposeBag = DisposeBag()
            combineLatest.subscribeOnNext({ [weak self, weak emptyDataSet] (_) in
                guard let `self` = self else { return }
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
            }).disposed(by: emptyDataSet.frameDisposeBag)
        }
    }
}
extension UIScrollView: EmptyDataSetProtocol {
    @objc public var isEmptyData: Bool {
        return self.subviews.count == 0
    }
}
extension UITableView {
    public override var isEmptyData: Bool {
        var items = 0
        guard let dataSource = self.dataSource else {
            return true
        }
        for sectionIndex in 0..<(dataSource.numberOfSections!(in: self)) {
            items += dataSource.tableView(self, numberOfRowsInSection: sectionIndex)
        }
        return items <= 0
    }
}
extension UICollectionView {
    public override var isEmptyData: Bool {
        var items = 0
        guard let dataSource = self.dataSource else {
            return true
        }
        for sectionIndex in 0..<(dataSource.numberOfSections!(in: self)) {
            items += dataSource.collectionView(self, numberOfItemsInSection: sectionIndex)
        }
        return items <= 0
    }
}
