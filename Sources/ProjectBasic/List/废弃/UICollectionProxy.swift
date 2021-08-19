//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension DelegateHooker: UICollectionViewDelegate {}

public class UICollectionAdapter_Old: UICollectionAdapter {
    public var autoDeselectRow: Bool = true
    private var _delegateHooker: DelegateHooker<UICollectionViewDelegate>?
    /// ZJaDe: 设置自定义的代理时，需要注意尽量使用UICollectionProxy或者它的子类，这样会自动实现一些默认配置
    public lazy var collectionProxy: UICollectionProxy = UICollectionProxy(self)
    
    override func collectionViewInit(_ collectionView: UICollectionView) {
        super.collectionViewInit(collectionView)
        collectionView.delegate = _delegateHooker ?? collectionProxy
    }
}

extension UICollectionAdapter_Old { // Hooker
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
    func addIn(_ adapter: UICollectionAdapter_Old) -> Self {
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
        return self
    }
}

public protocol CollectionCellOfLife_Old: CollectionCellOfLife {
    func cellShouldHighlight() -> Bool
    func cellDidSelected()
    func cellDidDeselected()
}

extension AnyCollectionAdapterItem {
    var base_old: CollectionCellOfLife_Old {
        // swiftlint:disable force_cast
        self.base as! CollectionCellOfLife_Old
    }
}

open class UICollectionProxy: NSObject, UICollectionViewDelegate {
    public private(set) weak var adapter: UICollectionAdapter_Old!
    public init(_ adapter: UICollectionAdapter_Old) {
        self.adapter = adapter
    }
    // MARK: - Managing the Selected Cells
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if adapter.autoDeselectRow {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.base_old.cellDidSelected()
    }
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.base_old.cellDidDeselected()
    }
    // MARK: - Managing Cell Highlighting
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let item = collectionCellItem(at: indexPath) else { return true }
        return item.base_old.cellShouldHighlight()
    }
    // MARK: - Tracking the Addition and Removal of Views
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.base.cellWillAppear(in: cell)
    }
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? InternalCollectionViewCell {
            cell.contentItem?.didDisappear()
        }
    }
    
    func collectionCellItem(at indexPath: IndexPath) -> AnyCollectionAdapterItem? {
        adapter.dataSource.item(for: indexPath)
    }
}
