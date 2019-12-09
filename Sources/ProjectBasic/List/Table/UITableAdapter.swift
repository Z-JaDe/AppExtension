//
//  UITableAdapter.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/10.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

extension AnyTableAdapterItem: AdapterItemType {}
extension TableItemModel: _AdapterItemType {}
extension TableCellModel: _AdapterItemType {}
extension StaticTableItemCell: _AdapterItemType {}

extension TableSection: _AdapterSectionType {}

public typealias TableSectionModel = SectionModelItem<TableSection, AnyTableAdapterItem>

public typealias TableListData = ListData<TableSection, AnyTableAdapterItem>
public typealias TableStaticData = ListData<TableSection, StaticTableItemCell>

public typealias TableListDataInfo = ListDataInfo<TableListData>
public typealias TableStaticListDataInfo = ListDataInfo<TableStaticData>

open class UITableAdapter: ListAdapter<TableViewDataSource<TableSectionModel>> {
    private var timer: Timer?
    public weak private(set) var tableView: UITableView?
    public func tableViewInit(_ tableView: UITableView) {
        self.tableView = tableView
        // 注册的用的全部都是InternalTableViewCell, 真正的cell是InternalTableViewCell.contentItem
        tableView.register(InternalTableViewCell.self, forCellReuseIdentifier: InternalTableViewCell.reuseIdentifier)

        dataSourceDefaultInit(dataSource)
        setDelegateHooker(delegateHooker?.target)
        setDataSourceHooker(dataSourceHooker?.target)
        dataChanged()
    }
    // MARK: -
    /// ZJaDe: 代理
    private var delegateHooker: DelegateHooker<UITableViewDelegate>?
    public func setDelegateHooker(_ target: AnyObject?) {
        if let tableView = tableView {
            setListHooker(target, &delegateHooker, &tableView.delegate, tableProxy)
        } else {
            setHooker(target, &delegateHooker, tableProxy)
        }
    }
    private var dataSourceHooker: DelegateHooker<UITableViewDataSource>?
    public func setDataSourceHooker(_ target: AnyObject?) {
        if let tableView = tableView {
            setListHooker(target, &dataSourceHooker, &tableView.dataSource, dataSource)
        } else {
            setHooker(target, &dataSourceHooker, dataSource)
        }
    }
    /// ZJaDe: 设置自定义的代理时，需要注意尽量使用UITableProxy或者它的子类，这样会自动实现一些默认配置
    public lazy var tableProxy: UITableProxy = UITableProxy(self)
    public var dataSource: DataSource = DataSource() {
        didSet { dataSourceDefaultInit(dataSource) }
    }
    open func dataSourceDefaultInit(_ dataSource: DataSource) {
        dataSource.configureCell = { (_, tableView, indexPath, item) in
            return item.createCell(in: tableView, for: indexPath)
        }
        dataSource.didMoveItem = {[weak self] (dataSource, source, destination) in
            guard let self = self else { return }
            self.dataInfo = self.dataInfo?.map({$0.move(source, destination)})
        }
    }
    public lazy var updating: Updating = tableView!.createUpdating(.fade)
    var dataInfo: ListDataInfoType?
    public let insertSecionModels: CallBackerReduce = CallBackerReduce<ListDataType>()
}
extension UITableAdapter: ListAdapterType {
    public var dataArray: ListDataType {
        self.dataInfo?.data ?? .init()
    }
    public func changeListDataInfo(_ newData: ListDataInfoType) {
        self.dataInfo = newData
        dataChanged()
    }
    func dataChanged() {
        guard let tableView = tableView else { return }
        guard let dataInfo = dataInfo else { return }
        let mapDataInfo = dataInfo.map({ (dataArray) -> [SectionModelItem<Section, Item>] in
            let dataArray = self.insertSecionModels.callReduce(dataArray)
            return dataArray.compactMapToSectionModels()
        })
        self.updateItemsIfNeed()
        self.addBufferPool(at: mapDataInfo.data)
        dataSource.dataChange(mapDataInfo, tableView.updater)
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
        return (self.value as! CreateTableCellrotocol).createCell(in: tableView, for: indexPath)
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
extension UITableAdapter {
    func addBufferPool(at data: [SectionModelItem<Section, Item>]) {
        data.lazy.flatMap({$0.items}).compactMap({$0.model}).forEach({ (model) in
            model.bufferPool = self.bufferPool
        })
    }
}
