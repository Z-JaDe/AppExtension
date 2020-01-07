//
//  DynamicTableItemCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift
open class DynamicTableItemCell: TableItemCell {

    var isTempCell: Bool = false

    var _model: TableItemModel? {
        didSet {
            if let model = self._model {
                didChangedModel(model)
            }
        }
    }
    func didChangedModel(_ model: TableItemModel) {}

    open override func didDisappear() {
        super.didDisappear()
        _model?.recycleCell(self)
    }
    override func _updateSelectedState(_ isSelected: Bool) {
        super._updateSelectedState(isSelected)
        if _model?.isSelected != isSelected {
            _model?.isSelected = isSelected
        }
    }
}
