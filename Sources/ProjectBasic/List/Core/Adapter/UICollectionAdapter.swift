//
//  ASKCollectionAdapter.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension CollectionItemModel: _AdapterItemType {}
extension CollectionSection: _AdapterSectionType {}

public typealias CollectionSectionModel = SectionModelItem<CollectionSection, CollectionItemModel>

extension DelegateHooker: UICollectionViewDelegate {}
open class UICollectionAdapter: ListAdapter<CollectionViewDataSource<CollectionSectionModel>> {

    private var _delegateHooker: DelegateHooker<UICollectionViewDelegate>?
    public weak private(set) var collectionView: UICollectionView?

    public func collectionViewInit(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)

        dataSourceDefaultInit(dataSource)
        collectionView.delegate = _delegateHooker ?? collectionProxy
        collectionView.dataSource = dataSource
        dataChanged()
    }

    /// ZJaDe: 设置自定义的代理时，需要注意尽量使用UICollectionProxy或者它的子类，这样会自动实现一些默认配置
    public lazy var collectionProxy: UICollectionProxy = UICollectionProxy(self)
    public var dataSource: DataSource = DataSource() {
        didSet { dataSourceDefaultInit(dataSource) }
    }
    open func dataSourceDefaultInit(_ dataSource: DataSource) {
        dataSource.configureCell = {(_, collectionView, indexPath, item) in
            return item.createCell(in: collectionView, at: indexPath)
        }
        dataSource.didMoveItem = { [weak self] (dataSource, source, destination) in
            guard let self = self else { return }
            self.dataInfo = self.dataInfo?.map({$0.move(source, destination)})
        }
    }
    public lazy var updating: Updating = collectionView!.createUpdating(updateMode: .partial)
    var dataInfo: _ListDataInfo?
}
extension UICollectionAdapter { //Hooker
    private var delegateHooker: DelegateHooker<UICollectionViewDelegate> {
        if let hooker = _delegateHooker {
            return hooker
        }
        let hooker = DelegateHooker<UICollectionViewDelegate>(defaultTarget: collectionProxy)
        self.collectionView?.delegate = hooker
        _delegateHooker = hooker
        return hooker
    }
    public func transformDelegate(_ target: UICollectionViewDelegate?) {
        delegateHooker.transform(to: target)
    }
    public func setAddDelegate(_ target: UITableViewDelegate?) {
        delegateHooker.addTarget = target
    }
    public var delegatePlugins: [UICollectionViewDelegate] {
        get { delegateHooker.plugins }
        set { delegateHooker.plugins = newValue }
    }
}
extension UICollectionAdapter: ListAdapterType {
    public var dataArray: _ListData {
        self.dataInfo?.data ?? .init()
    }
    public func changeListDataInfo(_ newData: _ListDataInfo) {
        self.dataInfo = newData
        dataChanged()
    }
    func dataChanged() {
        guard let collectionView = collectionView else { return }
        guard let dataInfo = dataInfo else { return }
        let mapDataInfo = dataInfo.map({ (dataArray) -> [SectionModelItem<Section, Item>] in
            return dataArray.compactMapToSectionModels()
        })
        dataSource.dataChange(mapDataInfo, collectionView.updater)
    }
}
extension UICollectionAdapter: ListDataUpdateProtocol {}
