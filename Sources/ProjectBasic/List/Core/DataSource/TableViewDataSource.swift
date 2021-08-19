//
//  TableViewDataSource.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2021/5/1.
//  Copyright © 2021 ZJaDe. All rights reserved.
//

import UIKit

extension AnyTableAdapterItem {
    fileprivate func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        if let _item = self.base as? TableCellHeightProtocol {
            if _item.cellHeightLayoutType.isNeedLayout {
                _item.calculateCellHeight(tableView, wait: true)
            }
        }
        return self.base.createCell(in: tableView, for: indexPath)
    }
}

open class TableViewDataSource: UITableViewDiffableDataSource<AnyAdapterSection, AnyTableAdapterItem> {
    public init(tableView: UITableView) {
        super.init(tableView: tableView) { tableView, indexPath, item in
            item.createCell(in: tableView, for: indexPath)
        }
    }

    public let reloadDataCompletion: CallBackerNoParams = CallBackerNoParams()

    private lazy var tableHeaderCell: CustomTableItemCell<UIView> = CustomTableItemCell()
    private lazy var tableFooterCell: CustomTableItemCell<UIView> = CustomTableItemCell()
    public var tableHeaderView: UIView? {
        get { self.tableHeaderCell.customView }
        set {
            self.tableHeaderCell.customView = newValue
            if let tableView = tableView, numberOfSections(in: tableView) >= 0 {
                self.apply(self.snapshot(), animatingDifferences: false)
            }
        }
    }
    public var tableFooterView: UIView? {
        get { self.tableFooterCell.customView }
        set {
            self.tableFooterCell.customView = newValue
            if let tableView = tableView, numberOfSections(in: tableView) >= 0 {
                self.apply(self.snapshot(), animatingDifferences: false)
            }
        }
    }

    public private(set) var tableView: UITableView?
    public override init(tableView: UITableView, cellProvider: @escaping UITableViewDiffableDataSource<AnyAdapterSection, AnyTableAdapterItem>.CellProvider) {
        super.init(tableView: tableView, cellProvider: cellProvider)
        self.tableView = tableView
    }

    open override func apply(_ snapshot: NSDiffableDataSourceSnapshot<AnyAdapterSection, AnyTableAdapterItem>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        var snapshot = snapshot
        let hasTableHeaderView = self.tableHeaderView != nil
        if hasTableHeaderView {
            if snapshot.sectionIdentifier(containingItem: AnyTableAdapterItem(self.tableHeaderCell)) == nil {
                let section = AnyAdapterSection(TableSection())
                if snapshot.numberOfSections > 0 {
                    snapshot.insertSections([section], beforeSection: snapshot.sectionIdentifiers[0])
                } else {
                    snapshot.appendSections([section])
                }
                snapshot.appendItems([AnyTableAdapterItem(self.tableHeaderCell)], toSection: section)
            }
            if snapshot.sectionIdentifier(containingItem: AnyTableAdapterItem(self.tableFooterCell)) == nil {
                let section = AnyAdapterSection(TableSection())
                snapshot.appendSections([section])
                snapshot.appendItems([AnyTableAdapterItem(self.tableFooterCell)], toSection: section)
            }
        }
        super.apply(snapshot, animatingDifferences: animatingDifferences) {
            completion?()
            self.reloadDataCompletion.call()
        }
    }

    /// ZJaDe: 重新刷新 返回 ListData
    open func reloadData<Item: AnyTableAdapterItem.Element>(_ itemArray: [Item]?, isRefresh: Bool, _ completion: (() -> Void)? = nil) {
        reloadData(section: TableSection(), itemArray, isRefresh: isRefresh, completion)
    }
    open func reloadData<Section: Hashable, Item: AnyTableAdapterItem.Element>(section: Section, _ itemArray: [Item]?, isRefresh: Bool, _ completion: (() -> Void)? = nil) {
        var snapshot: NSDiffableDataSourceSnapshot<AnyAdapterSection, AnyTableAdapterItem>
        if isRefresh {
            snapshot = NSDiffableDataSourceSnapshot()
        } else {
            snapshot = self.snapshot()
        }
        if snapshot.indexOfSection(AnyAdapterSection(section)) == nil {
            snapshot.appendSections([AnyAdapterSection(section)])
        }
        if let itemArray = itemArray?.map(AnyTableAdapterItem.init) {
            snapshot.appendItems(itemArray, toSection: AnyAdapterSection(section))
        }
        apply(snapshot) {
            completion?()
        }
    }
}
extension TableViewDataSource: ListViewDataSource {
    public typealias Section = AnyAdapterSection
    public typealias Item = AnyTableAdapterItem

    public func item(for indexPath: IndexPath) -> AnyTableAdapterItem? {
        itemIdentifier(for: indexPath)
    }
}
