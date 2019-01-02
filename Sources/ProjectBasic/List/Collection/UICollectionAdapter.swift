//
//  ASKCollectionAdapter.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

open class UICollectionAdapter: ListAdapter<CollectionViewDataSource<SectionModelItem<CollectSection, CollectionItemModel>>> {

    public weak private(set) var collectionView: UICollectionView?
    lazy private(set) var collectProxy: UICollectionProxy = UICollectionProxy(self)
    /// ZJaDe: 代理
    open weak var delegate: CollectionViewDelegate?

    public func collectionViewInit(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.register(SNCollectionViewCell.self, forCellWithReuseIdentifier: SNCollectionViewCell.reuseIdentifier)
        collectionView.register(SNCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SNCollectionReusableView.reuseIdentifier)
        collectionView.register(SNCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SNCollectionReusableView.reuseIdentifier)
        configDataSource(collectionView)
        configDelegate(collectionView)
        allowsSelection(collectionView)
    }
    // MARK: - MultipleSelectionProtocol
    func allowsSelection(_ collectionView: UICollectionView) {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
    }
    public override func changeSelectState(_ isSelected: Bool, _ item: CollectionItemModel) {
        guard let indexPath = self.dataController.indexPath(with: item) else {
            return
        }
        if isSelected {
            self.collectionView?.selectItem(at: indexPath, animated: false, scrollPosition: [])
            self._didSelectItem(at: indexPath)
        } else {
            self.collectionView?.deselectItem(at: indexPath, animated: false)
            self._didDeselectItem(at: indexPath)
        }
    }
    // MARK: - EnabledStateProtocol
    open override func updateEnabledState(_ isEnabled: Bool) {
        super.updateEnabledState(isEnabled)
        dataArray.lazy.flatMap({$0.1}).forEach { (item) in
            item.refreshEnabledState(isEnabled)
        }
    }
    // MARK: - ListDataUpdateProtocol
    override func loadRxDataSource() -> DataSource {
        let dataSource = DataSource(dataController: DataController())
        dataSource.configureCell = {(_, collectionView, indexPath, item) in
            return item.createCell(in: collectionView, at: indexPath)
        }
        dataSource.didMoveItem = { [weak self] (dataSource) in
            guard let `self` = self else { return }
            self.lastListDataInfo = self.lastListDataInfo.map({_ in dataSource.dataArray})
        }
        return dataSource
    }
    // MARK: -
    deinit {
        cleanReference()
    }
}
extension UICollectionAdapter {
    func cleanReference() {
        self.dataArray.lazy
            .flatMap({$0.items})
            .forEach({$0.cleanReference()})
    }
    func addBufferPool(at data: [SectionModelItem<Section, Item>]) {
        data.lazy.flatMap({$0.items}).forEach({ (model) in
            model.bufferPool = self.bufferPool
        })
    }
}
extension UICollectionAdapter {
    open func configDataSource(_ collectionView: UICollectionView) {
        dataArrayObservable()
            .map({$0.map({$0.compactMapToSectionModels()})})
            .do(onNext: {[weak self] (element) -> Void in
                guard let `self` = self else {return}
                self.addBufferPool(at: element.data)
            })
            .bind(to: collectionView.rx.items(dataSource: self.rxDataSource))
            .disposed(by: disposeBag)
    }
    open func configDelegate(_ collectionView: UICollectionView) {
        collectionView.rx.setDelegate(self.collectProxy)
            .disposed(by: self.disposeBag)
    }
}
extension UICollectionAdapter: CollectionAdapterDelegate {
    public func willDisplay(cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNCollectionViewCell else {
            return
        }
        let itemModel = self.dataController[indexPath]
        itemModel.willAppear(in: cell)
        if let itemCell = itemModel.getCell() {
            delegate?.didDisplay(item: itemCell)
            if let isEnabled = self.isEnabled {
                itemCell.refreshEnabledState(isEnabled)
            }
        }
    }
    public func didEndDisplaying(cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNCollectionViewCell else {
            return
        }
        if let itemModel = (cell.contentItem as? DynamicCollectionItemCell)?._model {
            if let itemCell = itemModel.getCell() {
                delegate?.didEndDisplaying(item: itemCell)
            }
            itemModel.didDisappear(in: cell)
//        } else if let itemModel = cell.contentItem as? StaticCollectionViewCell {
//            if let itemCell = itemModel.getCell() {
//                delegate?.didEndDisplaying(item: itemCell)
//            }
//            itemModel.didDisappear(in: cell)
        }
    }

    public func shouldHighlightItem(at indexPath: IndexPath) -> Bool {
        if let result = delegate?.shouldHighlightItem(at: indexPath) {
            return result
        }
        let item = self.dataController[indexPath].getCell()
        return item?.checkShouldHighlight() ?? true
    }
    private func _didSelectItem(at indexPath: IndexPath) {
        let item = self.dataController[indexPath]
        self.checkCanSelected(item) {[weak self] (isCanSelected) in
            guard let `self` = self else { return }
            if isCanSelected {
                self.whenItemSelected(item)
            } else {
                if self.autoDeselectRow {
                    self.collectionView?.deselectItem(at: indexPath, animated: true)
                }
            }
        }
        item.didSelectItem()
    }
    public func didSelectItem(at indexPath: IndexPath) {
        _didSelectItem(at: indexPath)
        delegate?.didSelectItem(at: indexPath)
    }
    private func _didDeselectItem(at indexPath: IndexPath) {
        let item = self.dataController[indexPath]
        whenItemUnSelected(item)
    }
    public func didDeselectItem(at indexPath: IndexPath) {
        _didDeselectItem(at: indexPath)
        delegate?.didSelectItem(at: indexPath)
    }
}
