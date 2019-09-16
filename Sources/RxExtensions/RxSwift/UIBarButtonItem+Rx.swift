//
//  UIBarButtonItem+Rx.swift
//  JDKit
//
//  Created by 茶古电子商务 on 2017/11/15.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIBarButtonItem {
    @discardableResult
    public func tap(_ closure: ((Base) -> Void)?) -> Disposable {
        self.tap
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: ())
            .driveOnNext { [weak base] in
                guard let base = base else { return }
                closure?(base)
            }
    }
}
