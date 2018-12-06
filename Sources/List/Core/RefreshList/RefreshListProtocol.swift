//
//  RefreshListProtocol.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/16.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import MJRefresh
import RxSwift
public protocol MJScrollProtocol: ScrollProtocol {
    var mj_header: MJRefreshHeader! {get set}
    var mj_footer: MJRefreshFooter! {get set}
}
extension UIScrollView: MJScrollProtocol {}

public protocol RefreshListProtocol: NetworkProtocol {
    associatedtype ScrollViewType: MJScrollProtocol, EmptyDataSetProtocol
    // MARK: -
    var scrollItem: ScrollViewType {get}
    // MARK: -
    /// ZJaDe: 调用此方法来设置是否可以上拉加载或者是否下拉刷新
    func configRefresh(refreshHeader: Bool, refreshFooter: Bool, preload: Bool)
    // MARK: -
    var networkPage: Int {get set}
    func resetNetworkPageIndex()
    var limit: UInt? {get set}
    func listParams(_ isRefresh: Bool, limit: UInt?) -> [String: Any]
    // MARK: -
    func request(isRefresh: Bool)
    /// ZJaDe: 调用此方法来下拉刷新
    func refreshHeader(_ animated: Bool)
    /// ZJaDe: 调用此方法来上拉加载
    func refreshFooter(_ animated: Bool)
}
extension RefreshListProtocol {
    // MARK: -
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
    public func configPreload() {
        guard let scrollView = self.scrollItem as? NSObject else {
            return
        }
        scrollView.resetDisposeBagWithTag("refreshOb_contentOffset")
        scrollView.rx.observeWeakly(CGPoint.self, "contentOffset")
            .observeOn(MainScheduler.asyncInstance)
            .subscribeOnNext {[weak self] (_) in
                guard let scrollItem = self?.scrollItem else {
                    return
                }

                // 内容超过一个屏幕
                guard scrollItem.contentInset.top + scrollItem.contentSize.height > scrollItem.height else {
                    return
                }
                guard scrollItem.contentOffset.y + scrollItem.height > scrollItem.contentSize.height + scrollItem.contentInset.top + scrollItem.contentInset.bottom else {
                    return
                }
                guard scrollItem.mj_header?.isRefreshing != true else {
                    return
                }
                guard scrollItem.isEmptyData == false else {
                    return
                }
                guard let footer = scrollItem.mj_footer else {
                    return
                }
                guard footer.state == .idle && footer.mj_y > 0 else {
                    return
                }
                footer.beginRefreshing()
            }.disposed(by: scrollView.disposeBagWithTag("refreshOb_contentOffset"))
    }

    // MARK: -
    public func listParams(_ refresh: Bool, limit: UInt? = nil) -> [String: Any] {
        var params = [String: Any]()
        if refresh {
            self.resetNetworkPageIndex()
        }
        params["offset"] = networkPage
        params["limit"] = limit ?? self.limit
        return params
    }

    // MARK: -
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
