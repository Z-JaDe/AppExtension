//
//  EmptyDataSetProtocol+ScrollItem.swift
//  JDKit
//
//  Created by ZJaDe on 2017/12/14.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension UIScrollView: EmptyDataSetProtocol {
    @objc public var isEmptyData: Bool {
        self.subviews.isEmpty
    }
}
extension UITableView {
    public override var isEmptyData: Bool {
        var items = 0
        guard let dataSource = self.dataSource else {
            return true
        }
        for sectionIndex in 0..<(dataSource.numberOfSections!(in: self)) {
            items += dataSource.tableView(self, numberOfRowsInSection: sectionIndex)
        }
        return items <= 0
    }
}
extension UICollectionView {
    public override var isEmptyData: Bool {
        var items = 0
        guard let dataSource = self.dataSource else {
            return true
        }
        for sectionIndex in 0..<(dataSource.numberOfSections!(in: self)) {
            items += dataSource.collectionView(self, numberOfItemsInSection: sectionIndex)
        }
        return items <= 0
    }
}
