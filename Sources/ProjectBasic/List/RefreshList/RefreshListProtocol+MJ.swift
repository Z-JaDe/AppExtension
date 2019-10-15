//
//  RefreshListProtocol+MJ.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/7.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
#if canImport(MJRefresh)
import MJRefresh
public protocol MJScrollable: Scrollable {
    var mj_header: MJRefreshHeader! {get set}
    var mj_footer: MJRefreshFooter! {get set}
}
extension UIScrollView: MJScrollable {}
extension RefreshListProtocol {
    /// ZJaDe: 调用此方法来设置是否可以上拉加载或者是否下拉刷新
    public func configRefresh(refreshHeader: Bool, refreshFooter: Bool, preload: Bool = true) {
        if refreshHeader {
            self.scrollItem.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                self?.refreshHeader(false)
            })
        } else {
            self.scrollItem.mj_header = nil
        }
        if refreshFooter {
            if let footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
                self?.refreshFooter(false)
            }) {
                self.scrollItem.mj_footer = footer
                if preload {
                    configPreload()
                }
            }
        } else {
            self.scrollItem.mj_footer = nil
        }
    }
    /// ZJaDe: 调用此方法来下拉刷新
    public func refreshHeader(_ animated: Bool = true) {
        if animated && self.scrollItem.mj_header != nil {
            self.scrollItem.mj_header?.beginRefreshing()
        } else {
            self.scrollItem.changeEmptyState(.loading)
            logInfo("\(self): 下拉刷新请求")
            request(isRefresh: true)
        }
    }
    /// ZJaDe: 调用此方法来上拉加载
    public func refreshFooter(_ animated: Bool = true) {
        if animated && self.scrollItem.mj_footer != nil {
            self.scrollItem.mj_footer?.beginRefreshing()
        } else {
            logInfo("\(self): 上拉加载请求")
            request(isRefresh: false)
        }
    }
}
#endif

#if canImport(RxSwift) && canImport(MJRefresh)
import RxSwift
private var preloadEnabledKey: UInt8 = 0
extension RefreshListProtocol {
    /// ZJaDe: 刷新失败时 自动设置成false 默认为true
    var preloadEnabled: Bool {
        get { associatedObject(&preloadEnabledKey, createIfNeed: true) }
        set { setAssociatedObject(&preloadEnabledKey, newValue)}
    }
    public func configPreload() {
        guard let scrollView = self.scrollItem as? NSObject else { return }
        let disposeBag = scrollView.resetDisposeBagWithTag("_refreshOb_contentOffset")
        scrollView.rx.observeWeakly(CGPoint.self, "contentOffset")
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOnNext {[weak self] (_) in
                guard let self = self else { return }
                guard self.preloadEnabled == true else { return }
                let scrollItem = self.scrollItem
                // ZJaDe: 内容超过一个屏幕时
                guard scrollItem.contentInset.top + scrollItem.contentSize.height > scrollItem.height else { return }
                guard scrollItem.contentOffset.y + scrollItem.height > scrollItem.contentSize.height + scrollItem.contentInset.top + scrollItem.contentInset.bottom else { return }
                guard scrollItem.mj_header?.isRefreshing != true else { return }
                guard scrollItem.isEmptyData == false else { return }
                guard let footer = scrollItem.mj_footer else { return }
                guard footer.state == .idle && footer.mj_y > 0 else { return }
                footer.beginRefreshing()
            }.disposed(by: disposeBag)
    }
}
#endif
