//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension DelegateHooker: UITableViewDelegate {}

public protocol TableCellOfLifeWithProxy: TableCellOfLife {
    func cellShouldHighlight() -> Bool
    func cellDidSelected()
    func cellDidDeselected()
}
extension AnyTableAdapterItem {
    var baseWithProxy: TableCellOfLifeWithProxy? {
        self.base as? TableCellOfLifeWithProxy
    }
}

open class UITableProxy: NSObject {
    private lazy var delegateHooker: DelegateHooker<UITableViewDelegate> = .init(defaultTarget: self)
    public var autoDeselectRow: Bool = true
    public private(set) weak var dataSource: TableViewDataSource!
    public init(_ dataSource: TableViewDataSource) {
        self.dataSource = dataSource
    }
    open var tableViewDelegate: UITableViewDelegate {
        delegateHooker
    }

}
extension UITableProxy: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = tableCellItem(at: indexPath)?.base as? TableCellHeightProtocol else {
            return UITableView.automaticDimension
        }
        if item.cellHeightLayoutType == .resetLayout {
            item.calculateCellHeight(tableView, wait: true)
        }
        let height = item.tempCellHeight
        return height > 0 ? height : 0.1
    }
    // MARK: -
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return 0.1 }
        return sectionModel.headerView.viewHeight(tableView.width)
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return 0.1 }
        return sectionModel.footerView.viewHeight(tableView.width)
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return nil }
        return sectionModel.headerView
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return nil }
        return sectionModel.footerView
    }
    // MARK: -
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let item = tableCellItem(at: indexPath) else { return true }
        return item.baseWithProxy?.cellShouldHighlight() ?? true
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if autoDeselectRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let item = tableCellItem(at: indexPath) else { return }
        item.baseWithProxy?.cellDidSelected()
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) else { return }
        item.baseWithProxy?.cellDidDeselected()
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) else { return }
        item.base.cellWillAppear(in: cell)
    }
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? InternalTableViewCell {
            cell.contentItem?.didDisappear()
        }
    }
}
extension UITableProxy {
    func tableSection(at section: Int) -> AnyAdapterSection? {
        let sections = dataSource.snapshot().sectionIdentifiers
        if  section <= 0 || sections.count <= section {
            return nil
        }
        return sections[section]
    }
    func tableCellItem(at indexPath: IndexPath) -> AnyTableAdapterItem? {
        dataSource.item(for: indexPath)
    }
}
extension UITableProxy {
    public func transformDelegate(_ target: UITableViewDelegate?) {
        delegateHooker.transform(to: target)
    }
    public func setAddDelegate(_ target: UITableViewDelegate?) {
        delegateHooker.addTarget = target
    }
    public var delegatePlugins: [UITableViewDelegate] {
        get { delegateHooker.plugins }
        set { delegateHooker.plugins = newValue }
    }
}
extension UITableViewDelegate {
    @discardableResult
    func addIn(_ adapter: UITableProxy) -> Self {
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
        return self
    }
}
