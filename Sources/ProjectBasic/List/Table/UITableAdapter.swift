//
//  UITableAdapter.swift
//  PaiBaoTang
//
//  Created by Z_JaDe on 2017/7/10.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

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
    lazy private(set) var tableProxy: UITableViewDelegate = UITableProxy(self)
    /// ZJaDe: 代理
    open weak var delegate: TableViewDelegate?

    public func tableViewInit(_ tableView: UITableView) {
        self.tableView = tableView
        // 注册的用的全部都是InternalTableViewCell, 真正的cell是InternalTableViewCell.contentItem
        tableView.register(InternalTableViewCell.self, forCellReuseIdentifier: InternalTableViewCell.reuseIdentifier)
        //初始化数据源
        bindingDataSource(self.rxDataSource)
        //初始化代理
        bindingDelegate(self.tableProxy)
        allowsSelection(tableView)
    }

    // MARK: -
    public let insertSecionModels: CallBackerReduce = CallBackerReduce<ListDataType>()
    public override var rxDataSource: DataSource {
        if let result = _rxDataSource {
            return result
        }
        let dataSource = DataSource()
        _rxDataSource = dataSource
        dataSource.configureCell = {[weak self] (_, tableView, indexPath, item) in
            guard let self = self else {
                return item.createCell(in: tableView, for: indexPath)
            }
            return self.createCell(in: tableView, for: indexPath, item: item)
        }
        dataSource.didMoveItem = { [weak self] (dataSource, source, destination) in
            guard let self = self else { return }
            self.dataInfo = self.dataInfo?.map({$0.exchange(source, destination)})
        }
        return dataSource
    }
    private func createCell(in tableView: UITableView, for indexPath: IndexPath, item: AnyTableAdapterItem) -> UITableViewCell {
        if let _item = item.value as? TableCellHeightProtocol {
            if _item.cellHeightLayoutType.isNeedLayout {
                _item.calculateCellHeight(tableView, wait: true)
            }
        }
        return item.createCell(in: tableView, for: indexPath)
    }
    // MARK: -
    open override func bindingDataSource(_ dataSource: DataSource) {
        super.bindingDataSource(dataSource)
        guard let tableView = tableView else { return }
        dataArrayObservable()
            .map({$0.map({[weak self] (dataArray) in
                let dataArray = self?.insertSecionModels.callReduce(dataArray) ?? dataArray
                return dataArray.compactMapToSectionModels()
            })})
            .do(onNext: { [weak self] (element) -> Void in
                guard let self = self else {return}
                self.updateItemsIfNeed()
                self.addBufferPool(at: element.data)
            })
            .bind(to: tableView.rx.items(dataSource: self.rxDataSource))
            .disposed(by: disposeBag)
    }
    /**
     设置自定义的代理时，需要注意尽量使用UITableProxy或者它的子类，这样会自动实现一些默认配置
     */
    open func bindingDelegate(_ tableProxy: UITableViewDelegate) {
        self.tableProxy = tableProxy
        tableView?.rx.setDelegate(self.tableProxy)
            .disposed(by: self.disposeBag)
    }
}
extension AnyTableAdapterItem {
    fileprivate func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
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
