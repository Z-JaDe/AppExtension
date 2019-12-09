//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension UICollectionProxy {
    var dataController: UICollectionAdapter.DataSource.DataControllerType {
        adapter.dataSource.dataController
    }
    func collectionCellItem(at indexPath: IndexPath) -> UICollectionAdapter.Item {
        dataController[indexPath]
    }
}

open class UICollectionProxy: NSObject, UICollectionViewDelegate {
    public private(set) weak var adapter: UICollectionAdapter!
    public init(_ adapter: UICollectionAdapter) {
        self.adapter = adapter
    }
    // MARK: - Managing the Selected Cells
    open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    open func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        adapter._didSelectItem(at: indexPath)
    }
    open func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        adapter._didDeselectItem(at: indexPath)
    }
    // MARK: - Managing Cell Highlighting
    open func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return collectionCellItem(at: indexPath).shouldHighlight()
    }
    open func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

    }
    open func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {

    }
    // MARK: - Tracking the Addition and Removal of Views
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let item = collectionCellItem(at: indexPath)
        item.willAppear(in: cell)
        if let isEnabled = self.adapter.isEnabled {
            item.refreshEnabledState(isEnabled)
        }
    }
    open func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? InternalCollectionViewCell {
            cell.contentItem?.didDisappear()
        }
    }
    open func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }
    open func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
    }
    // MARK: - Handling Layout Changes
    open func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    open func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        proposedContentOffset
    }
    open func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        proposedIndexPath
    }
    // MARK: - Managing Actions for Cells
    open func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        false
    }
    open func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        false
    }
    open func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

    }
    // MARK: - Managing Focus in a Collection View
//    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
//        return collectionView.cellForItem(at: indexPath)?.canBecomeFocused
//    }
//    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
//        return nil
//    }
//    func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
//        return true
//    }
//    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//
//    }
    // MARK: - Controlling the Spring-Loading Behavior
    @available(iOS 11.0, *)
    open func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        true
    }
}
