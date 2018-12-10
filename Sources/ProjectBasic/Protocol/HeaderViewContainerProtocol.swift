//
//  HeaderViewContainerProtocol.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/7/13.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

public protocol HeaderViewContainerProtocol: AssociatedObjectProtocol {
    associatedtype HeaderViewType: DefaultHeightProtocol&UIView
    var headerView: HeaderViewType {get}
    associatedtype ScrollViewType: ScrollProtocol&UIView
    var scrollView: ScrollViewType {get}

    func headerAndScrollBinding(in view: UIView?)
}
private var headerViewHeightKey: UInt8 = 0
private var offsetYKey: UInt8 = 0
public extension HeaderViewContainerProtocol {
    private var headerViewHeight: CGFloat {
        get {return associatedObject(&headerViewHeightKey, createIfNeed: 0)}
        set {
            willUpdateContentOffsetAndInset()
            setAssociatedObject(&headerViewHeightKey, newValue)
            updateContentOffsetAndInset()
        }
    }
    private var offsetY: CGFloat {
        get {return associatedObject(&offsetYKey, createIfNeed: 0)}
        set {setAssociatedObject(&offsetYKey, newValue)}
    }
    // MARK: -
    func headerAndScrollBinding(in view: UIView? = nil) {
        willUpdateContentOffsetAndInset()
        if headerView.superview == nil {
            let superView = view ?? scrollView
            superView.addSubview(headerView)
            headerView.snp.makeConstraints { (maker) in
                maker.left.centerX.width.equalToSuperview()
            }
        }
        resetHeaderViewHeight()
    }
    func resetHeaderViewHeight() {
        self.headerViewHeight = self.headerView.defaultHeight
    }
    // MARK: -
    /// ZJaDe: 当headerView将要改变或高度将要变化的时候，或者scrollView将要变化的时候调用
    func willUpdateContentOffsetAndInset() {
        self.offsetY = scrollView.contentOffset.y + headerViewHeight
        scrollView.contentInset.top -= headerViewHeight
    }
    /// ZJaDe: 当headerView已经改变或高度已经变化的时候，或者scrollView已经变化的时候调用
    func updateContentOffsetAndInset() {
        scrollView.contentInset.top += headerViewHeight
        changeContentOffsetY(scrollView: scrollView, y: self.offsetY - headerViewHeight)
    }
    private func changeContentOffsetY(scrollView: ScrollViewType, y: CGFloat) {
        scrollView.contentOffset.y = y
    }
}

#if canImport(RxSwift)
import RxSwift
import RxCocoa
extension HeaderViewContainerProtocol where ScrollViewType == UIScrollView {
    // MARK: -
    public func subscribeWhenScroll(_ updateClosure: @escaping (CGFloat) -> Void) {
        self.scrollView.resetDisposeBagWithTag("headerScroll")
        self.scrollView.rx.contentOffset.subscribeOnNext {[weak self] (contentOffset) in
            guard let `self` = self else { return }
            updateClosure(contentOffset.y + self.scrollView.contentInset.top)
            }.disposed(by: self.scrollView.disposeBagWithTag("headerScroll"))
    }
}
#endif
