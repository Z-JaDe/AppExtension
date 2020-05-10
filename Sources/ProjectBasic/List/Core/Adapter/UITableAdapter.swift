//
//  UITableAdapter.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/10.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension AnyTableAdapterItem: AdapterItemType {
    public var realItem: Any {
        self.value
    }
}
extension TableItemModel: _AdapterItemType {}
extension TableCellModel: _AdapterItemType {}
extension StaticTableItemCell: _AdapterItemType {}

extension TableSection: _AdapterSectionType {}

public typealias TableSectionModel = SectionModelItem<TableSection, AnyTableAdapterItem>

public typealias TableListData = ListData<TableSection, AnyTableAdapterItem>
public typealias TableStaticData = ListData<TableSection, StaticTableItemCell>

extension DelegateHooker: UITableViewDelegate {}
open class UITableAdapter: ListAdapter<TableViewDataSource<TableSectionModel>> {
    private var timer: Timer?
    private var _delegateHooker: DelegateHooker<UITableViewDelegate>?
    public weak private(set) var tableView: UITableView?
    public func tableViewInit(_ tableView: UITableView) {
        self.tableView = tableView
        dataSourceDefaultInit(dataSource)

        tableView.delegate = _delegateHooker ?? tableProxy
        tableView.dataSource = dataSource
        dataChanged({})
    }
    /// ZJaDe: 设置自定义的代理时，需要注意尽量使用UITableProxy或者它的子类，这样会自动实现一些默认配置
    public lazy var tableProxy: UITableProxy = UITableProxy(self)
    open override func dataSourceDefaultInit(_ dataSource: DataSource) {
        super.dataSourceDefaultInit(dataSource)
        dataSource.configureCell = { (_, tableView, indexPath, item) in
            return item.createCell(in: tableView, for: indexPath)
        }
    }
    public let insertSecionModels: CallBackerReduce = CallBackerReduce<_ListData>()
    override func dataChanged(_ completion: (() -> Void)?) {
        guard let tableView = tableView else { return }
        guard let listData = listData else { return }
        let dataArray = self.insertSecionModels.callReduce(listData)
        let mapDataInfo = dataArray.compactMapToSectionModels()
        self.updateItemsIfNeed()
        let updater = self.updater ?? tableView.updater
        updater.tempUpdateMode = self.tempUpdateMode
        self.tempUpdateMode = nil
        let updating = self.updating ?? tableView.createUpdating(.fade)
        dataSource.dataChange(mapDataInfo, updater, updating, completion)
    }
}
extension UITableAdapter { //Hooker
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
extension UITableAdapter: ListDataUpdateProtocol {}
extension AnyTableAdapterItem {
    fileprivate func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        if let _item = self.value as? TableCellHeightProtocol {
            if _item.cellHeightLayoutType.isNeedLayout {
                _item.calculateCellHeight(tableView, wait: true)
            }
        }
        // swiftlint:disable force_cast
        return (self.value as! TableCellOfLife).createCell(in: tableView, for: indexPath)
    }
}
extension UITableAdapter {
    public func updateItemsIfNeed() {
        let modelTable = NSHashTable<AnyObject>.weakObjects()
        self.dataArray.lazy
            .flatMap({$0.items.map({$0.value})})
            .forEach(modelTable.add)
        self.timer?.invalidate()
        self.timer = Timer.scheduleTimer(0.01) {[weak self] (timer) in
            guard let self = self else { return }
            guard let item = modelTable.anyObject else {
                timer?.invalidate()
                return
            }
            guard let tableView = self.tableView else { return }
            guard let heightItem = item as? TableCellHeightProtocol else { return }
            modelTable.remove(item)
            if heightItem.cellHeightLayoutType.isNeedLayout {
                heightItem.calculateCellHeight(tableView, wait: false)
            }
        }
    }
}
