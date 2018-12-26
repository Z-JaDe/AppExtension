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
    override var _model: TableItemModel? {
        get {return self.model}
        set {
            if let newValue = newValue as? ModelType {
                self.model = newValue
            }
        }
    }
    public var model: ModelType {
        didSet {
            setNeedUpdateModel()
            if isTempCell {
                updateModelIfNeed()
            }
        }
    }

    public convenience init() {
        self.init(model: ModelType())
    }
    public required init(model: ModelType) {
        self.model = model
        super.init(frame: CGRect.zero)
        setNeedUpdateModel()
    }
    public required init?(coder aDecoder: NSCoder) {
        self.model = ModelType()
        super.init(coder: aDecoder)
        setNeedUpdateModel()
    }

    open func configData(with model: ModelType) {

    }
}
