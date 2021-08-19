//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension DelegateHooker: UICollectionViewDelegate {}

public protocol CollectionCellOfLifeWithProxy: CollectionCellOfLife {
    func cellShouldHighlight() -> Bool
    func cellDidSelected()
    func cellDidDeselected()
}

extension AnyCollectionAdapterItem {
    var baseWithProxy: CollectionCellOfLifeWithProxy? {
        self.base as? CollectionCellOfLifeWithProxy
    }
}

open class UICollectionProxy: NSObject {
    public var autoDeselectRow: Bool = true
    private lazy var delegateHooker: DelegateHooker<UICollectionViewDelegate> = .init(defaultTarget: self)
    public weak var dataSource: CollectionViewDataSource!
    public init(_ dataSource: CollectionViewDataSource) {
        self.dataSource = dataSource
        super.init()
    }
    open var collectionViewDelegate: UICollectionViewDelegate {
        delegateHooker
    }
}
extension UICollectionProxy: UICollectionViewDelegate {
    // MARK: - Managing the Selected Cells
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if autoDeselectRow {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.baseWithProxy?.cellDidSelected()
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.baseWithProxy?.cellDidDeselected()
    }
    // MARK: - Managing Cell Highlighting
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        guard let item = collectionCellItem(at: indexPath) else { return true }
        return item.baseWithProxy?.cellShouldHighlight() ?? true
    }
    // MARK: - Tracking the Addition and Removal of Views
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let item = collectionCellItem(at: indexPath) else { return }
        item.base.cellWillAppear(in: cell)
    }
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? InternalCollectionViewCell {
            cell.contentItem?.didDisappear()
        }
    }
}
extension UICollectionProxy {
    func collectionCellItem(at indexPath: IndexPath) -> AnyCollectionAdapterItem? {
        dataSource.item(for: indexPath)
    }
}
extension UICollectionProxy { // Hooker
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
    @discardableResult
    func addIn(_ deledate: UICollectionProxy) -> Self {
        if deledate.delegatePlugins.contains(where: {$0 === self}) == false {
            deledate.delegatePlugins.append(self)
        }
        return self
    }
}
