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

public typealias TableSectionModel = SectionModelItem<TableSection, AnyTableAdapterItem>

public typealias TableListData = ListData<TableSection, AnyTableAdapterItem>
public typealias TableStaticData = ListData<TableSection, StaticTableItemCell>

public typealias TableListUpdateInfo = ListUpdateInfo<TableListData>
public typealias TableStaticUpdateInfo = ListUpdateInfo<TableStaticData>

open class UITableAdapter: ListAdapter<TableViewDataSource<TableSectionModel>> {

    public weak private(set) var tableView: UITableView?
    lazy private(set) var tableProxy: UITableProxy = UITableProxy(self)
    /// ZJaDe: 代理
    open weak var delegate: TableViewDelegate?

    public func tableViewInit(_ tableView: UITableView) {
        self.tableView = tableView
        // 注册的用的全部都是SNTableViewCell, 真正的cell是SNTableViewCell.contentItem
        tableView.register(SNTableViewCell.self, forCellReuseIdentifier: SNTableViewCell.reuseIdentifier)
        //初始化数据源
        configDataSource(tableView)
        //初始化代理
        configDelegate(tableView)
        allowsSelection(tableView)
    }
    // MARK: - MultipleSelectionProtocol
    func allowsSelection(_ tableView: UITableView) {
        tableView.allowsSelection = true
        tableView.allowsMultipleSelection = true
    }
    open override func changeSelectState(_ isSelected: Bool, _ item: AnyTableAdapterItem) {
        guard let indexPath = self.dataController.indexPath(with: item) else {
            return
        }
        if isSelected {
            self.tableView?.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            _didSelectItem(at: indexPath)
        } else {
            self.tableView?.deselectRow(at: indexPath, animated: false)
            _didDeselectItem(at: indexPath)
        }
    }
    // MARK: - EnabledStateProtocol
    open override func updateEnabledState(_ isEnabled: Bool) {
        super.updateEnabledState(isEnabled)
        dataArray.flatMap({$0.1}).forEach { (item) in
            item.tableItem.refreshEnabledState(isEnabled)
        }
    }
    // MARK: - ListDataUpdateProtocol
    public let insertSecionModels: CallBackerReduce = CallBackerReduce<ListDataType>()
    override func loadRxDataSource() -> DataSource {
        let dataSource = DataSource(dataController: DataController())
        dataSource.configureCell = {[weak self] (_, tableView, indexPath, item) in
            guard let `self` = self else {
                return item.tableItem.createCell(in: tableView, for: indexPath)
            }
            return self.createCell(in: tableView, for: indexPath, item: item)
        }
        dataSource.didMoveItem = { [weak self] (dataSource, source, destination) in
            guard let `self` = self else { return }
            self.lastListDataInfo = self.lastListDataInfo.map({$0.exchange(source, destination)})
        }
        return dataSource
    }
    // MARK: -
    private var timer: Timer?

    // MARK: -
    deinit {
        cleanReference()
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
            guard let `self` = self else { return }
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
    func cleanReference() {
        self.dataArray.lazy
            .flatMap({$0.items})
            .compactMap({$0.model})
            .forEach({$0.cleanReference()})
    }
    func addBufferPool(at data: [SectionModelItem<Section, Item>]) {
        data.lazy.flatMap({$0.items}).compactMap({$0.model}).forEach({ (model) in
            model.bufferPool = self.bufferPool
        })
    }
}
extension UITableAdapter {
    public func configDataSource(_ tableView: UITableView) {
        dataArrayObservable()
            .map({$0.map({[weak self] (dataArray) in
                let dataArray = self?.insertSecionModels.callReduce(dataArray) ?? dataArray
                return dataArray.compactMapToSectionModels()
            })})
            .do(onNext: { [weak self] (element) -> Void in
                guard let `self` = self else {return}
                self.updateItemsIfNeed()
                self.addBufferPool(at: element.data)
            })
            .bind(to: tableView.rx.items(dataSource: self.rxDataSource))
            .disposed(by: disposeBag)
    }

    public func configDelegate(_ tableView: UITableView) {
        tableView.rx.setDelegate(self.tableProxy)
            .disposed(by: self.disposeBag)
    }
}
