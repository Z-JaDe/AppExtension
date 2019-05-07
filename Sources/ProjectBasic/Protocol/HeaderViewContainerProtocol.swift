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
    /// ZJaDe: 当滚动时监听
    func whenScroll()
    /// ZJaDe: 滚动时更新高度
    func update(viewHeight height: CGFloat)
}
private var headerViewHeightKey: UInt8 = 0
private var offsetYKey: UInt8 = 0
private extension HeaderViewContainerProtocol {
    var headerViewHeight: CGFloat {
        get {return associatedObject(&headerViewHeightKey, createIfNeed: 0)}
        set {
            willUpdateContentOffsetAndInset()
            setAssociatedObject(&headerViewHeightKey, newValue)
            updateContentOffsetAndInset()
        }
    }
    var offsetY: CGFloat {
        get {return associatedObject(&offsetYKey, createIfNeed: 0)}
        set {setAssociatedObject(&offsetYKey, newValue)}
    }
    func _headerAndScrollBinding(in view: UIView?) {
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
    func changeContentOffsetY(scrollView: ScrollViewType, y: CGFloat) {
        scrollView.contentOffset.y = y
    }
}
public extension HeaderViewContainerProtocol {
    func headerAndScrollBinding(in view: UIView? = nil) {
        _headerAndScrollBinding(in: view)
    }
    func resetHeaderViewHeight() {
        self.headerViewHeight = self.headerView.defaultHeight
    }
}
public extension HeaderViewContainerProtocol where HeaderViewType: UpdateHeightProtocol {
    func update(viewHeight height: CGFloat) {
        self.headerView.update(viewHeight: height)
    }
}
#if canImport(RxSwift)
import RxSwift
import RxCocoa
public extension HeaderViewContainerProtocol where ScrollViewType: UIScrollView {
    func headerAndScrollBinding(in view: UIView? = nil) {
        _headerAndScrollBinding(in: view)
        whenScroll()
    }
    func whenScroll() {
        subscribeWhenScroll {[weak self] (offSet) in
            guard let `self` = self else { return }
            let height = self.headerView.defaultHeight - offSet
            self.update(viewHeight: height)
        }
    }
    func subscribeWhenScroll(_ updateClosure: @escaping (CGFloat) -> Void) {
        let disposeBag = self.scrollView.resetDisposeBagWithTag("_headerScroll")
        self.scrollView.rx.contentOffset
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOnNext {[weak self] (contentOffset) in
                guard let `self` = self else { return }
                updateClosure(contentOffset.y + self.scrollView.contentInset.top)
            }.disposed(by: disposeBag)
    }
}
#endif
