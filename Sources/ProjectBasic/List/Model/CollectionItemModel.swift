//
//  CollectionItemModel.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class CollectionItemModel: ListItemModel {
    public var cellSize: CGSize?
    // MARK: - cell
    public weak var bufferPool: BufferPool?
    /// ZJaDe: 手动释放
    weak var _weakContentCell: DynamicCollectionItemCell? {
        didSet {
            _weakContentCell?.isEnabled = self.isEnabled
        }
    }
    // MARK: SelectedStateDesignable
    public var isSelected: Bool = false {
        didSet { getCell()?.isSelected = self.isSelected }
    }
    open func didSelectItem() {
        getCell()?.didSelectItem()
    }
    // MARK: EnabledStateDesignable
    public var isEnabled: Bool? {
        didSet { getCell()?.isEnabled = self.isEnabled }
    }
    open func updateEnabledState(_ isEnabled: Bool) {
        getCell()?.refreshEnabledState(isEnabled)
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
        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InternalCollectionViewCell
        cell.tempContentItem = createCellIfNil()
        return cell
    }
    public func willAppear(in cell: UICollectionViewCell) {
        guard let cell = cell as? InternalCollectionViewCell else {
            return
        }
        cell.contentItem = cell.tempContentItem
        _weakContentCell?.willAppear()
    }
    func shouldHighlight() -> Bool {
        getCell()?.shouldHighlight() ?? true
    }
}
