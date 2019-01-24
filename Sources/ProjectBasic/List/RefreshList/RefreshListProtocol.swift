//
//  RefreshListProtocol.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/16.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
#if !AppExtensionPods
import EmptyDataSet
#endif
public protocol RefreshListProtocol: NetworkProtocol, AssociatedObjectProtocol {
    #if canImport(MJRefresh)
    associatedtype ScrollViewType: MJScrollProtocol, EmptyDataSetProtocol
    #else
    associatedtype ScrollViewType: EmptyDataSetProtocol
    #endif
    /// ZJaDe:
    var scrollItem: ScrollViewType {get}
    /// ZJaDe: 调用此方法来设置是否可以上拉加载或者是否下拉刷新
    func configRefresh(refreshHeader: Bool, refreshFooter: Bool, preload: Bool)
    /// ZJaDe: 自动加载
    func configPreload()
    /// ZJaDe:
    var networkPage: Int {get set}
    func resetNetworkPageIndex()
    var limit: UInt? {get set}
    func listParams(_ isRefresh: Bool, limit: UInt?) -> [String: Any]
    /// ZJaDe:
    func request(isRefresh: Bool)
    /// ZJaDe: 调用此方法来下拉刷新
    func refreshHeader(_ animated: Bool)
    /// ZJaDe: 调用此方法来上拉加载
    func refreshFooter(_ animated: Bool)
}
extension RefreshListProtocol {
    public func listParams(_ refresh: Bool, limit: UInt? = nil) -> [String: Any] {
        var params = [String: Any]()
        if refresh {
            self.resetNetworkPageIndex()
        }
        params["offset"] = networkPage
        params["limit"] = limit ?? self.limit
        return params
    }
    public func resetNetworkPageIndex() {
        self.networkPage = 0
    }
}
