//
//  RxDataSourceType.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

#if canImport(RxCocoa) && canImport(RxSwift)
import RxCocoa
import RxSwift
extension TableViewDataSource: RxTableViewDataSourceType {
    public func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        let updater = tableView.updater
        Binder(self) { dataSource, newValue in
            dataSource.rxChange(newValue, updater)
            }.on(observedEvent)
    }
}
extension CollectionViewDataSource: RxCollectionViewDataSourceType {
    public func collectionView(_ collectionView: UICollectionView, observedEvent: Event<Element>) {
        let updater = collectionView.updater
        Binder(self) { dataSource, newValue in
            dataSource.rxChange(newValue, updater)
            }.on(observedEvent)
    }
}
extension DataController: SectionedViewDataSourceType {
    public func model(at indexPath: IndexPath) throws -> Any {
        guard sectionIndexCanBound(indexPath.section) else {
            throw NSError(domain: "分区下标越界", code: 0, userInfo: nil)
        }
        guard indexPathCanBound(indexPath) else {
            throw NSError(domain: "下标越界", code: 0, userInfo: nil)
        }
        return self[indexPath]
    }
}
#endif
