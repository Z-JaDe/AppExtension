//
//  CollectionItemModel.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class CollectionItemModel: ListItemModel, CollectionCellConfigProtocol {
    public var cellSize: CGSize?
    open func getCellClsName() -> String {
        return self.cellFullName
    }
    // MARK: - cell
    public weak var bufferPool: BufferPool?
    public func createCell() -> CollectionItemCell {
        let result: DynamicCollectionItemCell
        let cellName = self.getCellClsName()
        if let cell: DynamicCollectionItemCell = bufferPool?.pop(cellName) {
            result = cell
        } else {
            // swiftlint:disable force_cast
            let cls: DynamicCollectionItemCell.Type = NSClassFromString(cellName) as! DynamicCollectionItemCell.Type
            result = cls.init()
        }
        if let cellSize = self.cellSize {
            result.updateLayouts(result.snp.prepareConstraints({ (maker) in
                maker.size.equalTo(cellSize)
            }))
        }
        result._model = self
        return result
    }
    public func recycleCell(_ cell: CollectionItemCell) {
        bufferPool?.push(cell)
    }
    public func getCell() -> CollectionItemCell? {
        return _contentCell
    }
    private func createCellIfNil() {
        if _contentCell == nil {
            let cell = createCell()
            _contentCell = cell as? DynamicCollectionItemCell
        }
    }
    /// ZJaDe: 手动释放
    private var _contentCell: DynamicCollectionItemCell? {
        didSet {
            _contentCell?.isEnabled = self.isEnabled
        }
    }
    open override var isEnabled: Bool? {
        didSet {
            _contentCell?.isEnabled = self.isEnabled
        }
    }
    public override var isSelected: Bool {
        didSet {
            _contentCell?.isSelected = self.isSelected
        }
    }
    public override func didSelectItem() {
        _contentCell?.didSelectItem()
    }
    open override func updateEnabledState(_ isEnabled: Bool) {
        _contentCell?.refreshEnabledState(isEnabled)
    }

    // MARK: -
    public func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier: String = SNCollectionViewCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? SNCollectionViewCell
        createCellIfNil()
        return cell!
    }

    public func willAppear(in cell: UICollectionViewCell) {
        guard let cell = cell as? SNCollectionViewCell else {
            return
        }
        createCellIfNil()
        // ZJaDe: SNCollectionViewCell对_contentCell引用
        cell.contentItem = _contentCell
        _contentCell?.willAppear()
        if _contentCell == nil {
            logError("cell为空，需检查错误")
        }
    }
    public func didDisappear(in cell: UICollectionViewCell) {
        guard let cell = cell as? SNCollectionViewCell else {
            return
        }
        _contentCell?.didDisappear()
        // ZJaDe: 释放SNCollectionViewCell对_contentCell的持有
        cell.contentItem = nil
        //讲contentCell加入到缓存池
        if let item = _contentCell {
            recycleCell(item)
        }

        cleanReference()
    }

    func cleanReference() {
        // ZJaDe: 释放model对_contentCell的持有
        _contentCell?._model = nil
        _contentCell = nil
    }
}
