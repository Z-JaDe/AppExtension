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

extension CollectionItemModel: AdapterItemType {}
extension CollectSection: AdapterSectionType {}

public typealias CollectionSectionModel = SectionModelItem<CollectSection, CollectionItemModel>

open class UICollectionAdapter: ListAdapter<CollectionViewDataSource<CollectionSectionModel>> {

    public weak private(set) var collectionView: UICollectionView?
    lazy private(set) var collectProxy: UICollectionViewDelegate = UICollectionProxy(self)
    /// ZJaDe: 代理
    open weak var delegate: CollectionViewDelegate?

    public func collectionViewInit(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.register(InternalCollectionViewCell.self, forCellWithReuseIdentifier: InternalCollectionViewCell.reuseIdentifier)
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)
        bindingDataSource(self.rxDataSource)
        bindingDelegate(self.collectProxy)
        allowsSelection(collectionView)
    }
    // MARK: -
    public override var rxDataSource: DataSource {
        if let result = _rxDataSource {
            return result
        }
        let dataSource = DataSource()
        _rxDataSource = dataSource
        dataSource.configureCell = {(_, collectionView, indexPath, item) in
            return item.createCell(in: collectionView, at: indexPath)
        }
        dataSource.didMoveItem = { [weak self] (dataSource, source, destination) in
            guard let self = self else { return }
            self.dataInfo = self.dataInfo.map({$0.exchange(source, destination)})
        }
        return dataSource
    }
    // MARK: -
    deinit {
        cleanReference()
    }
    // MARK: -
    open override func bindingDataSource(_ dataSource: DataSource) {
        super.bindingDataSource(dataSource)
        guard let collectionView = collectionView else { return }
        dataArrayObservable()
            .map({$0.map({$0.compactMapToSectionModels()})})
            .do(onNext: {[weak self] (element) -> Void in
                guard let self = self else {return}
                self.addBufferPool(at: element.data)
            })
            .bind(to: collectionView.rx.items(dataSource: self.rxDataSource))
            .disposed(by: disposeBag)
    }
    /**
     设置自定义的代理时，需要注意尽量使用UICollectionProxy或者它的子类，这样会自动实现一些默认配置
     */
    open func bindingDelegate(_ collectProxy: UICollectionViewDelegate) {
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
