//
//  DynamicCollectionItemCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/24.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class DynamicCollectionItemCell: CollectionItemCell {

    var isTempCell: Bool = false

    private var _model: CollectionItemModel? {
        didSet {
            if let model = self._model {
                didChangedModel(model)
            }
        }
    }
    func getModel() -> CollectionItemModel? {
        _model
    }
    func setModel(_ model: CollectionItemModel?) {
        _model = model
    }
    func didChangedModel(_ model: CollectionItemModel) {}

    open override func didDisappear() {
        super.didDisappear()
        getModel()?._weakContentCell = nil
        setModel(nil)
    }

    override func _updateSelectedState(_ isSelected: Bool) {
        super._updateSelectedState(isSelected)
        if getModel()?.isSelected != isSelected {
            getModel()?.isSelected = isSelected
        }
    }
}
open class CollectionModelCell<ModelType: CollectionItemModel>: DynamicCollectionItemCell, CellModelProtocol {

    public var model: ModelType? {
        get { return getModel() as? ModelType }
        set { setModel(newValue) }
    }

    override func didChangedModel(_ model: CollectionItemModel) {
        setNeedUpdateModel()
    }

    open func configData(with model: ModelType) {

    }
}
