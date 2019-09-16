//
//  UICollectView+Rx.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 17/3/23.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UICollectionView {
    public func modelItemSelected<T>(_ modelType: T.Type) -> ControlEvent<(model: T, indexPath: IndexPath)> {
        let source: Observable<(model: T, indexPath: IndexPath)> = self.itemSelected.flatMap { [weak view = self.base as UICollectionView] indexPath -> Observable<(model: T, indexPath: IndexPath)> in
            guard let view = view else {
                return Observable.empty()
            }

            return Observable.just((model: try view.rx.model(at: indexPath), indexPath: indexPath))
        }

        return ControlEvent(events: source)
    }
}

// MARK: - AutoDeselect
extension Reactive where Base: UICollectionView {
    public func enableAutoDeselect() -> Disposable {
        itemSelected
            .map { (at: $0, animated: true) }
            .subscribeOnNext( base.deselectItem)
    }
}
