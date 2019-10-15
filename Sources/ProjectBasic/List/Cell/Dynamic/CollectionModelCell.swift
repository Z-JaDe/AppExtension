//
//  CollectionModelCell.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/9/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift
open class CollectionModelCell<ModelType: CollectionItemModel>: DynamicCollectionItemCell, CellModelProtocol {

    public var model: ModelType {
        // swiftlint:disable force_cast
        get {return getModel() as! ModelType}
        set { setModel(newValue) }
    }

    override func didChangedModel(_ model: CollectionItemModel) {
        setNeedUpdateModel()
    }

    open func configData(with model: ModelType) {

    }
}
