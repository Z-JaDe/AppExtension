//
//  DynamicTableItemCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift
open class DynamicTableItemCell: TableItemCell {

    var isTempCell: Bool = false

    weak var _model: TableItemModel?

    open override func configInit() {
        super.configInit()
        self.cellState.filter({$0 == .didAppear}).subscribeOnNext {[weak self] (_) in
            self?._model?.hasLoad = true
        }.disposed(by: self.disposeBag)
    }

    open override func configAppearAnimate() {
        if _model?.hasLoad == true {
            super.configAppearAnimate()
        }
    }

    open func checkCanSelected(_ closure: @escaping (Bool?) -> Void) {
        closure(nil)
    }
}
