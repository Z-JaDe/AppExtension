//
//  ListViewController.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ListViewController<ScrollViewType, AdapterType>: ScrollViewController<ScrollViewType>, RefreshListProtocol
    where ScrollViewType: UIScrollView, AdapterType: ListDataUpdateProtocol & ListAdapterType {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.adapter.dataController.reloadDataCompletion.subscribeOnNext {[weak self] () in
            self?.sn_view.emptyDataSet.reloadData()
        }.disposed(by: self.disposeBag)
    }

    open var scrollItem: ScrollViewType {
        return self.sn_view
    }
    private var _adapter: AdapterType?
    public var adapter: AdapterType {
        if let adapter = _adapter {
            return adapter
        }
        let adapter = loadAdapter()
        _adapter = adapter
        return adapter
    }
    func loadAdapter() -> AdapterType {
        jdAbstractMethod()
    }

    // MARK: - ResultParser RefreshListProtocol
    public var parser: ResultParser<ListViewController, AdapterType> {
        return ResultParser(self, self.adapter)
    }
    public var networkPage: Int = 0
    public func resetNetworkPageIndex() {
        self.networkPage = 0
    }
    public var limit: UInt? = 20
    // MARK: -
    open override func request() {
        // ZJaDe: request() 指向 refreshHeader(false) 指向 request(isRefresh: true)
        self.refreshHeader(false)
    }

    /// ZJaDe: 如果继承自该类的情况可以直接重写request(isRefresh: Bool)，如果是在外部该类作为子控制器的情况，应该把requestClosure指向外部类里面的request(isRefresh: Bool)
    public var requestClosure: ((Bool) -> Void)?
    open func request(isRefresh: Bool) {
        if let closure = self.requestClosure {
            closure(isRefresh)
        } else {
            jdAbstractMethod()
        }
    }
    /// ZJaDe: 如果继承自该类的情况可以直接重写updateData()，如果是在外部该类作为子控制器的情况，应该把updateDataClosure指向外部类里面的updateData()
    public var updateDataClosure: (() -> Void)?
    open override func updateData() {
        if let closure = self.updateDataClosure {
            closure()
        } else {
            jdAbstractMethod()
        }
    }
}
