//
//  CollectionItemCell.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/16.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class CollectionItemCell: ItemCell {

    func getInternalCell() -> InternalCollectionViewCell? {
        return self.superView(InternalCollectionViewCell.self)
    }
    /// ZJaDe: insets
    public var insets: UIEdgeInsets = Space.cellInsets {
        didSet {getInternalCell()?.setNeedsUpdateConstraints()}
    }
}
