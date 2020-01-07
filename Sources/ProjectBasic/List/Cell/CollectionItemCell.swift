//
//  CollectionItemCell.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/16.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class CollectionItemCell: ItemCell, CollectionCellContentItem {
    open override func removeFromSuperview() {
        super.removeFromSuperview()
    }
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let cell = superview as? InternalCollectionViewCell else {
            return
        }
        prepareForReuse()
        self.updateUI(cell)
        cell.setNeedsUpdateLayouts()
    }
    /// 设置contentItem属性后刷新这里触发SNTableCell
    func updateUI(_ cell: InternalCollectionViewCell) {
        ///isSelected由cell和model共同控制
//        cell.isSelected = self.isSelected
        ///isHighlighted由cell控制
        self.isHighlighted = cell.isHighlighted
    }
    open override func didDisappear() {
        super.didDisappear()
        self.getInternalCell()?.contentItem = nil
    }
    /// ZJaDe: insets
    public var insets: UIEdgeInsets = Space.cellInsets {
        didSet {getInternalCell()?.setNeedsUpdateConstraints()}
    }
}
