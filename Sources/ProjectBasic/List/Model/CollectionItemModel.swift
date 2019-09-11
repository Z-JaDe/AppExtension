//
//  CollectionItemModel.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class CollectionItemModel: ListItemModel {
    public var cellSize: CGSize?
    open func getCellClsName() -> String {
        return self.cellFullName
    }
    // MARK: - cell
    public weak var bufferPool: BufferPool?
    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicCollectionItemCell?
    var _contentCell: DynamicCollectionItemCell? {
        didSet {
            _contentCell?.isEnabled = self.isEnabled
        }
    }
    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { _contentCell?.isSelected = self.isSelected }
    }
    public var canSelected: Bool = false
    open func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        closure(self.canSelected)
    }
    open func didSelectItem() {
        _contentCell?.didSelectItem()
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet { _contentCell?.isEnabled = self.isEnabled }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        _contentCell?.refreshEnabledState(isEnabled)
    }
}
extension DynamicCollectionItemCell: DynamicModelCell {}
extension CollectionItemModel: CreateCellUseModel {
    func createCell(isTemp: Bool) -> DynamicCollectionItemCell {
        let cellName = self.getCellClsName()
        let result: DynamicCollectionItemCell = bufferPool.createView(cellName)
        if let cellSize = self.cellSize {
            result.updateLayouts(result.snp.prepareConstraints({ (maker) in
                maker.size.equalTo(cellSize)
            }))
        }
        return result
    }
    func recycleCell(_ cell: DynamicCollectionItemCell) {
        bufferPool?.push(cell)
        cleanCellReference()
    }
}
extension CollectionItemModel: CollectionCellConfigProtocol {
    public func createCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier: String = InternalCollectionViewCell.reuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? InternalCollectionViewCell
        createCellIfNil()
        return cell!
    }
    public func willAppear(in cell: UICollectionViewCell) {
        guard let cell = cell as? InternalCollectionViewCell else {
            return
        }
        // ZJaDe: InternalCollectionViewCell对_contentCell引用
        cell.contentItem = _contentCell!
        cellDidInHierarchy()
        _contentCell?.willAppear()
    }
    public func didDisappear(in cell: UICollectionViewCell) {
        guard let cell = cell as? InternalCollectionViewCell else {
            return
        }
        _contentCell?.didDisappear()
        let item = getCell()
        // ZJaDe: 释放InternalCollectionViewCell对_contentCell的持有
        cell.contentItem = nil
        //讲contentCell加入到缓存池
        if let item = item {
            recycleCell(item)
        }
    }
    func shouldHighlight() -> Bool {
        return getCell()?.shouldHighlight() ?? true
    }
}
