//
//  ResultParser.swift
//  List
//
//  Created by ZJaDe on 2018/10/8.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
public struct ResultParser<RefreshList> {
    public let list: RefreshList
    public let getPage: () -> Int
    public init(_ list: RefreshList, getPage: @escaping () -> Int) {
        self.list = list
        self.getPage = getPage
    }
}
extension ResultParser where RefreshList: RefreshListProtocol {
    private var scrollItem: RefreshList.ScrollViewType {
        self.list.scrollItem
    }
    public func endRefreshing(count: Int?) {
        if let count = count {
            self.endRefreshing(count > 0)
        } else {
            self.endRefreshing(nil)
        }
    }
    public func endRefreshing(_ hasData: Bool?) {
        self.list.preloadEnabled = hasData == true
        self.scrollItem.mj_header?.endRefreshing()
        if let hasData = hasData {
            self.list.networkPage = self.getPage()
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
