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
protocol CollectionCellOfLife {
    func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell
    func cellWillAppear(in cell: UICollectionViewCell)
    func cellDidDisAppear()
}
extension CollectionCellOfLife {
    @inline(__always)
    func _createCell<T: UICollectionViewCell>(in collectionView: UICollectionView, for indexPath: IndexPath, _ reuseIdentifier: String) -> T {
        collectionView.register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
        // swiftlint:disable force_cast
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}
// MARK: -
extension CollectionItemModel: CollectionCellOfLife {
    typealias DynamicCell = DynamicCollectionItemCell
    func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
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
    func cellWillAppear(in cell: UICollectionViewCell) {
        _weakContentCell = (cell as! InternalCollectionViewCell).contentItem as? DynamicCell
        _weakContentCell?.setModel(self)
        _weakContentCell?.willAppear()
    }
    func cellDidDisAppear() {
        getCell()?.didDisappear()
        getCell()?.setModel(nil)
        _weakContentCell = nil
    }
    func shouldHighlight() -> Bool {
        getCell()?.shouldHighlight() ?? true
    }
}
