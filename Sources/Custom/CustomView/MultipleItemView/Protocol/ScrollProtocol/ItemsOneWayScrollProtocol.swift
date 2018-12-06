//
//  ItemsOneWayScrollProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/8/8.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public enum ItemSpace {
    /// ZJaDe: 间距在item两边平分
    case center(CGFloat)
    /// ZJaDe: 间距在item右边或者下边
    case leading(CGFloat)

    var space: CGFloat {
        switch self {
        case .center(let space):
            return space
        case .leading(let space):
            return space
        }
    }
}

public protocol ItemsOneWayScrollProtocol: OneWayScrollProtocol {
    associatedtype ItemView: UIView
    typealias LayoutCellType = LayoutMultipleItemCell<ItemView>
    var itemSpace: ItemSpace {get set}

    func setNeedsLayoutCells()
}
extension ItemsOneWayScrollProtocol {
    /// ZJaDe: 更新itemArr的尺寸布局，cellLength不为空时表示给定尺寸
    func layoutCellsSize(_ cellArr: [LayoutCellType], _ cellLength: CGFloat?) {
        cellArr.lazy.enumerated().forEach { (_, cell) in
            switch self.scrollDirection {
            case .horizontal:
                let _length = cellLength ?? cell.sizeThatFits().width
                cell.changeSize(CGSize(width: min(_length, self.width), height: self.height))
            case .vertical:
                let _length = cellLength ?? cell.sizeThatFits().height
                cell.changeSize(CGSize(width: self.width, height: min(_length, self.height)))
            }
        }
    }
    @discardableResult
    func layoutCellsOrigin(_ cellArr: [LayoutCellType], _ startLocation: CGFloat) -> CGFloat {
        return cellArr.reduce(startLocation) { (offSet, item) -> CGFloat in
            item.leading = offSet
            return item.trailing
        }
    }
    // MARK: -
    public func createLayoutCell(_ itemView: ItemView) -> LayoutCellType {
        let cell = LayoutCellType(itemView)
        cell.itemSpace = self.itemSpace
        cell.scrollDirection = self.scrollDirection
        return cell
    }
}
extension ItemsOneWayScrollProtocol where Self: UIView {
    // MARK: -
    @discardableResult
    internal func itemViewRemoveFromSuperview(_ itemView: ItemView) -> Bool {
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
