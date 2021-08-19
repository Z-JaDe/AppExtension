//
//  ListViewController.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ListViewController<ScrollViewType>: GenericsViewController<ScrollViewType>
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
