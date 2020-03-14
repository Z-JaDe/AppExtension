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

    private var _model: TableItemModel? {
        didSet {
            if let model = self._model {
                didChangedModel(model)
            }
        }
    }
    @inline(__always)
    func getModel() -> TableItemModel? {
        _model
    }
    @inline(__always)
    func setModel(_ model: TableItemModel?) {
        _model = model
    }
    func didChangedModel(_ model: TableItemModel) {}

    override func _updateSelectedState(_ isSelected: Bool) {
        super._updateSelectedState(isSelected)
        if getModel()?.isSelected != isSelected {
            getModel()?.isSelected = isSelected
        }
    }
}
open class TableModelCell<ModelType: TableItemModel>: DynamicTableItemCell, CellModelProtocol {

    public var model: ModelType? {
        get { return getModel() as? ModelType }
        set { setModel(newValue) }
    }

    override func didChangedModel(_ model: TableItemModel) {
        if isTempCell {
            configDataWithModel()
        } else {
            setNeedUpdateModel()
        }
    }

    open func configData(with model: ModelType) {

    }
}
