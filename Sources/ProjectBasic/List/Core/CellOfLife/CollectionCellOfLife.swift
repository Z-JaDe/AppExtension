//
//  CollectionCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
/**
 自己实现复用cell，willAppear和didDisappear需要代理里面调用，UICollectionAdapter默认已经调用
 */
public protocol CollectionCellOfLife {
    func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func cellWillAppear(in cell: UICollectionViewCell)
//    func cellDidDisAppear() ///cell消失时 有可能数据源已经丢失

    func cellShouldHighlight() -> Bool
    func cellDidSelected()
    func cellDidDeselected()
}
extension CollectionCellOfLife {
    func _createCell<T: UICollectionViewCell>(in collectionView: UICollectionView, for indexPath: IndexPath, _ reuseIdentifier: String) -> T {
        collectionView.register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
        // swiftlint:disable force_cast
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}
// MARK: -
extension CollectionItemModel: CollectionCellOfLife {
    typealias DynamicCell = DynamicCollectionItemCell
    public func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = cellInfo.reuseIdentifier
        let cell: InternalCollectionViewCell = _createCell(in: collectionView, for: indexPath, reuseIdentifier)
        guard let cls = NSClassFromString(cellInfo.clsName) as? DynamicCell.Type else {
            assertionFailure("Cell需要继承自DynamicTableItemCell")
            return UICollectionViewCell()
        }
        let itemCell: DynamicCell
        if let contentItem = cell.contentItem {
            if type(of: contentItem) == cls {
                itemCell = contentItem as! DynamicCell
            } else {
                assertionFailure("\(cellInfo.reuseIdentifier)注册了其他Cell?")
                itemCell = cls.init()
                cell.contentItem = itemCell
            }
        } else {
            itemCell = cls.init()
            cell.contentItem = itemCell
        }
        return cell
    }
    public func cellWillAppear(in cell: UICollectionViewCell) {
        guard let _cell = (cell as! InternalCollectionViewCell).contentItem as? DynamicCell else {
            assertionFailure("没获取到DynamicCell")
            return
        }
        _weakContentCell = _cell
        _cell.isEnabled = self.isEnabled
        _cell.isSelected = self.isSelected
        _cell.setModel(self)
        _cell.willAppear()
        _cell.changeCellStateToDidAppear()
    }
    public func cellShouldHighlight() -> Bool {
        getCell()?.shouldHighlight() ?? true
    }
    public func cellDidSelected() {
        getCell()?.didSelectedItem()
    }
    public func cellDidDeselected() {
    }
}
