//
//  TableModelCell.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/9/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift

open class TableModelCell<ModelType: TableItemModel>: DynamicTableItemCell, CellModelProtocol {

    public var model: ModelType {
        // swiftlint:disable force_cast
        get {return getModel() as! ModelType}
        set { setModel(newValue) }
    }

    override func didChangedModel(_ model: TableItemModel) {
        setNeedUpdateModel()
        if isTempCell {
            updateModelIfNeed()
        }
    }

    open func configData(with model: ModelType) {

    }
}
