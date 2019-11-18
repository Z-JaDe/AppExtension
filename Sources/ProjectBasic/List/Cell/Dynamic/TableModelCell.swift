//
//  TableModelCell.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/9/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift

open class TableModelCell<ModelType: TableItemModel>: DynamicTableItemCell, CellModelProtocol {

    public var model: ModelType? {
        get {return getModel() as? ModelType}
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
