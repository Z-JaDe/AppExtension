//
//  ItemsOneWayScrollProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/8.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public enum ItemSpace {
    /// ZJaDe: [-sapce/2-content-sapce/2-content-sapce/2-]
    case center(CGFloat)
    /// ZJaDe: [-content-sapce-content-sapce-]
    case leading(CGFloat)
//    /// ZJaDe: [-content-sapce-content-]
//    case fill(CGFloat)
}

public protocol ItemsOneWayScrollProtocol: OneWayScrollProtocol {
    associatedtype CellView: UIView
    typealias LayoutItemType = LayoutItem<CellView>
    var itemSpace: ItemSpace {get set}

    func setNeedsLayoutCells()
}
public extension ItemsOneWayScrollProtocol {
    /// ZJaDe: 更新itemArr的尺寸布局，cellLength不为空时表示给定尺寸
    func layoutCellsSize(_ cellArr: [LayoutItemType], _ cellLength: CGFloat?) {
        cellArr.lazy.enumerated().forEach { (_, cell) in
            switch self.scrollDirection {
            case .horizontal:
                let _length = cellLength ?? cell.sizeThatFits().width
                cell.changeSize(CGSize(width: _length, height: self.height))
            case .vertical:
                let _length = cellLength ?? cell.sizeThatFits().height
                cell.changeSize(CGSize(width: self.width, height: _length))
            }
        }
    }
    @discardableResult
    func layoutCellsOrigin(_ cellArr: [LayoutItemType], _ startOrigin: CGFloat) -> CGFloat {
        return cellArr.reduce(startOrigin) { (offSet, item) -> CGFloat in
            item.leading = offSet
            return item.trailing
        }
    }
    // MARK: -
    func createLayoutCell(_ cell: CellView) -> LayoutItemType {
        return LayoutItemType(cell, itemSpace, scrollDirection)
    }
}
public extension ItemsOneWayScrollProtocol where Self: UIView {
    // MARK: -
    @discardableResult
    func removeCellFromSuperview(_ itemView: CellView) -> Bool {
        if itemView.superview == self || itemView.superview == nil {
            itemView.removeFromSuperview()
            return true
        } else {
            assertionFailure("itemView的父视图不是\(self)")
            setNeedsLayoutCells()
            return false
        }
    }
}
