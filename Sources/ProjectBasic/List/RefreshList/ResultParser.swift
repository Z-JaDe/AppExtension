//
//  ResultParser.swift
//  List
//
//  Created by 郑军铎 on 2018/10/8.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
public class ResultParser<RefreshList, AdapterType: ListDataUpdateProtocol> {
    public let list: RefreshList
    public let adapter: AdapterType
    public typealias ListDataType = AdapterType.ListDataType
    public init(_ list: RefreshList, _ adapter: AdapterType) {
        self.list = list
        self.adapter = adapter
    }
    // MARK: - updateScrollState
    public private(set) var updateScrollState: Bool = true
    // MARK: - section
    public private(set) var section: AdapterType.Section?
    public func section(_ value: AdapterType.Section) -> ResultParser {
        self.section = value
        return self
    }
}
extension ResultParser where RefreshList: RefreshListProtocol {
    public func isNeedUpdateScrollState(_ value: Bool) -> ResultParser {
        self.updateScrollState = value
        return self
    }
    private var scrollItem: RefreshList.ScrollViewType {
        self.list.scrollItem
    }
    open func endRefreshing(count: Int?) {
        guard updateScrollState else {
            return
        }
        if let count = count {
            self.endRefreshing(count > 0)
        } else {
            self.endRefreshing(nil)
        }
    }
    open func endRefreshing(_ hasData: Bool?) {
        self.list.preloadEnabled = hasData == true
        self.scrollItem.mj_header?.endRefreshing()
        if let hasData = hasData {
            self.list.networkPage = self.adapter.dataArray.itemCount
            if hasData {
                self.scrollItem.mj_footer?.endRefreshing()
            } else {
                self.scrollItem.mj_footer?.endRefreshingWithNoMoreData()
            }
            self.scrollItem.changeEmptyState(.loaded)
        } else {
            self.scrollItem.mj_footer?.endRefreshing()
            self.scrollItem.changeEmptyState(.loadFailed)
        }
    }
}

// MARK: - ResultParser扩展table collection
extension ResultParser where AdapterType.Section: Equatable&InitProtocol, RefreshList: RefreshListProtocol {
    public func itemArray(_ itemArray: [AdapterType.Item]?, _ isRefresh: Bool) -> ResultParser {
        self.adapter.reloadData(section: self.section, itemArray, isRefresh: isRefresh, {
            $0.configUpdateMode(.everything).completion {
                self.endRefreshing(count: itemArray?.count)
            }
        })
        return self
    }
}
extension ResultParser where AdapterType.Section: Equatable&InitProtocol, AdapterType.Item == CollectionItemModel, RefreshList: RefreshListProtocol {
    @discardableResult
    public func modelArray(_ modelArray: [CollectionItemModel]?, _ refresh: Bool) -> ResultParser {
        self.itemArray(modelArray, refresh)
    }
}
extension ResultParser where AdapterType.Section: Equatable&InitProtocol, AdapterType.Item == AnyTableAdapterItem, RefreshList: RefreshListProtocol {
    @discardableResult
    public func modelArray(_ modelArray: [TableItemModel]?, _ refresh: Bool) -> ResultParser {
        let listItems: [AnyTableAdapterItem]? = modelArray?.map {.model($0)}
        return self.itemArray(listItems, refresh)
    }
    @discardableResult
    public func cellArray(_ cellArray: [StaticTableItemCell]?, _ refresh: Bool) -> ResultParser {
        let listItems: [AnyTableAdapterItem]? = cellArray?.map {.cell($0)}
        return self.itemArray(listItems, refresh)
    }
}
