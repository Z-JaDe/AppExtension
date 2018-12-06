//
//  EmptyDataSetProtocol.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/11/18.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import UIKit
// MARK: -
public protocol EmptyDataSetProtocol: DisposeBagProtocol {
    var emptyDataSet: EmptyDataSetView {get}
    func changeEmptyState(_ state: EmptyViewState)

    var isEmptyData: Bool {get}
    func addEmptyItemToSuperItemIfNeed(_ emptyDataSet: EmptyDataSetView)
}
private var emptyDataSetViewKey: UInt8 = 0
extension EmptyDataSetProtocol {
    public var emptyDataSet: EmptyDataSetView {
        return associatedObject(&emptyDataSetViewKey, createIfNeed: EmptyDataSetView().then({ (node) in
            node.container = self
            node.emptyStateChangedObserver()
                .subscribeOnNext({[weak self, weak node] (_) in
                    guard let `self` = self else { return }
                    guard let node = node else { return }
                    self.addEmptyItemToSuperItemIfNeed(node)
                    node.reloadData()
                }).disposed(by: self.disposeBag)
        }))
    }
    public func changeEmptyState(_ state: EmptyViewState) {
        self.emptyDataSet.emptyState = state
    }
}
