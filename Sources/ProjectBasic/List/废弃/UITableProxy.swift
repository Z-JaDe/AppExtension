//
//  UITableProxy.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension DelegateHooker: UITableViewDelegate {}

public class UITableAdapter_Old: UITableAdapter {
    public var autoDeselectRow: Bool = true
    private var _delegateHooker: DelegateHooker<UITableViewDelegate>?
    
    override func tableViewInit(_ tableView: UITableView) {
        super.tableViewInit(tableView)
        tableView.delegate = _delegateHooker ?? tableProxy
    }
}
extension UITableAdapter_Old { // Hooker
    private var delegateHooker: DelegateHooker<UITableViewDelegate> {
        if let hooker = _delegateHooker {
            return hooker
        }
        let hooker = DelegateHooker<UITableViewDelegate>(defaultTarget: tableProxy)
        self.tableView?.delegate = hooker
        _delegateHooker = hooker
        return hooker
    }
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
    func addIn(_ adapter: UITableAdapter_Old) -> Self {
        if adapter.delegatePlugins.contains(where: {$0 === self}) == false {
            adapter.delegatePlugins.append(self)
        }
        return self
    }
}

public protocol TableCellOfLife_Old: TableCellOfLife {
    func cellShouldHighlight() -> Bool
    func cellDidSelected()
    func cellDidDeselected()
}
extension AnyTableAdapterItem {
    var base_old: TableCellOfLife_Old {
        // swiftlint:disable force_cast
        self.base as! TableCellOfLife_Old
    }
}

extension UITableProxy {
    func tableSection(at section: Int) -> AnyAdapterSection? {
        let sections = adapter.dataSource.snapshot().sectionIdentifiers
        if  section <= 0 || sections.count <= section {
            return nil
        }
        return sections[section]
    }
    func tableCellItem(at indexPath: IndexPath) -> AnyTableAdapterItem? {
        adapter.dataSource.item(for: indexPath)
    }
}

open class UITableProxy: NSObject, UITableViewDelegate {
    public private(set) weak var adapter: UITableAdapter_Old!
    public init(_ adapter: UITableAdapter_Old) {
        self.adapter = adapter
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return 0.1 }
        return sectionModel.headerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return 0.1 }
        return sectionModel.footerView.viewHeight(tableView.width)
    }
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return nil }
        return sectionModel.headerView
    }
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let sectionModel = tableSection(at: section)?.anyBase as? TableSection else { return nil }
        return sectionModel.footerView
    }
    // MARK: -
    open func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let item = tableCellItem(at: indexPath) else { return true }
        return item.base_old.cellShouldHighlight()
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if adapter.autoDeselectRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        guard let item = tableCellItem(at: indexPath) else { return }
        item.base_old.cellDidSelected()
    }
    open func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) else { return }
        item.base_old.cellDidDeselected()
    }
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let item = tableCellItem(at: indexPath) else { return }
        item.base.cellWillAppear(in: cell)
    }
    open func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? InternalTableViewCell {
            cell.contentItem?.didDisappear()
        }
    }
}
