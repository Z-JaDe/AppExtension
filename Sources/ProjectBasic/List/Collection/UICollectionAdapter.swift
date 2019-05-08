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

public typealias CollectionSectionModel = SectionModelItem<CollectSection, CollectionItemModel>

open class UICollectionAdapter: ListAdapter<CollectionViewDataSource<CollectionSectionModel>> {

    public weak private(set) var collectionView: UICollectionView?
    lazy private(set) var collectProxy: UICollectionViewDelegate = UICollectionProxy(self)
    /// ZJaDe: 代理
    open weak var delegate: CollectionViewDelegate?

    public func collectionViewInit(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.register(SNCollectionViewCell.self, forCellWithReuseIdentifier: SNCollectionViewCell.reuseIdentifier)
        collectionView.register(SNCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SNCollectionReusableView.reuseIdentifier)
        collectionView.register(SNCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: SNCollectionReusableView.reuseIdentifier)
        setDataSource(self.rxDataSource)
        setDelegate(self.collectProxy)
        allowsSelection(collectionView)
    }
    // MARK: - MultipleSelectionProtocol
    func allowsSelection(_ collectionView: UICollectionView) {
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
    }
    open override func changeSelectState(_ isSelected: Bool, _ item: CollectionItemModel) {
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
        dataSource.didMoveItem = { [weak self] (dataSource, source, destination) in
            guard let `self` = self else { return }
            self.lastListDataInfo = self.lastListDataInfo.map({$0.exchange(source, destination)})
        }
        return dataSource
    }
    // MARK: -
    deinit {
        cleanReference()
    }
    // MARK: -
    open override func setDataSource(_ dataSource: DataSource) {
        super.setDataSource(dataSource)
        guard let collectionView = collectionView else { return }
        dataArrayObservable()
            .map({$0.map({$0.compactMapToSectionModels()})})
            .do(onNext: {[weak self] (element) -> Void in
                guard let `self` = self else {return}
                self.addBufferPool(at: element.data)
            })
            .bind(to: collectionView.rx.items(dataSource: self.rxDataSource))
            .disposed(by: disposeBag)
    }
    open func setDelegate(_ collectProxy: UICollectionViewDelegate) {
        self.collectProxy = collectProxy
        collectionView?.rx.setDelegate(self.collectProxy)
            .disposed(by: self.disposeBag)
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
