//
//  ListViewController.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ListViewController<ScrollViewType>: ScrollViewController<ScrollViewType>
    where ScrollViewType: UIScrollView {

    open var scrollItem: ScrollViewType {
        self.rootView
    }
    // MARK: -
    open override func request() {
        self.request(isRefresh: true)
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

open class AdapterListViewController<ScrollViewType, AdapterType>: ListViewController<ScrollViewType> where ScrollViewType: UIScrollView, AdapterType: ListDataUpdateProtocol & ListAdapterType {

    // MARK: - RefreshListProtocol
    open var networkPage: Int = 0
    ///默认值若有变化 子类可重写
    open var limit: UInt? = 20

    open override func request() {
        // ZJaDe: request() 指向 refreshHeader(false) 指向 request(isRefresh: true)
        self.refreshHeader(false)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.adapter.dataController.reloadDataCompletion.register(on: self, key: "emptyDataSetReloadData", { (self) in
            self.rootView.emptyDataSet.reloadData()
        })
    }

    public lazy private(set) var adapter: AdapterType = self.loadAdapter()
    func loadAdapter() -> AdapterType {
        jdAbstractMethod()
    }
}
// MARK: - RefreshListProtocol
extension AdapterListViewController: RefreshListProtocol {
    public var parser: ResultParser<AdapterListViewController, AdapterType> {
        ResultParser(self, self.adapter)
    }
}
extension AdapterTableViewController {
    // MARK: - ResultParser
    public func parseCellArray(_ cellArray: [StaticTableItemCell]?, _ refresh: Bool) {
        parser.cellArray(cellArray, refresh)
    }
    public func parseModelArray(_ modelArray: [TableItemModel]?, _ refresh: Bool) {
        parser.modelArray(modelArray, refresh)
    }
}
extension AdapterCollectionViewController {
    // MARK: - ResultParser
    public func parseModelArray(_ modelArray: [CollectionItemModel]?, _ refresh: Bool) {
        parser.modelArray(modelArray, refresh)
    }
}
