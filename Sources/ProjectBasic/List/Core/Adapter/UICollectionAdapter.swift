//
//  ASKCollectionAdapter.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/4.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension DelegateHooker: UICollectionViewDelegate {}
open class UICollectionAdapter: NSObject {

    public weak private(set) var collectionView: UICollectionView?

    private var _delegateHooker: DelegateHooker<UICollectionViewDelegate>?
    /// ZJaDe: 设置自定义的代理时，需要注意尽量使用UICollectionProxy或者它的子类，这样会自动实现一些默认配置
    public lazy var collectionProxy: UICollectionProxy = UICollectionProxy(self)
    public var dataSource: CollectionViewDataSource!

    public func collectionViewInit(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)
        collectionView.register(InternalCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: InternalCollectionReusableView.reuseIdentifier)

        dataSourceDefaultInit(collectionView)
        collectionView.delegate = _delegateHooker ?? collectionProxy
        collectionView.dataSource = dataSource
    }

    open func dataSourceDefaultInit(_ collectionView: UICollectionView) {
        dataSource = CollectionViewDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            item.base.createCell(in: collectionView, at: indexPath)
        })
    }
}
extension UICollectionAdapter { // Hooker
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
extension UICollectionViewDelegate {
    func addIn(_ adapter: UICollectionAdapter) -> Self {
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
        return self
    }
}
