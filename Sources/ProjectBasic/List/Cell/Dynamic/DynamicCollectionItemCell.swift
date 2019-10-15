//
//  DynamicCollectionItemCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class DynamicCollectionItemCell: CollectionItemCell {

    weak var _weakModel: CollectionItemModel? {
        didSet {
            if let model = self._weakModel {
                didChangedModel(model)
            }
        }
    }
    var _model: CollectionItemModel?
    func didChangedModel(_ model: CollectionItemModel) {}

    open override func configInit() {
        super.configInit()
    }
    open override func willAppear() {
        super.willAppear()
        self.getModel()?.hasLoad = true
    }
    open override func configAppearAnimate() {
        if getModel()?.hasLoad == true {
            super.configAppearAnimate()
        }
    }

}
