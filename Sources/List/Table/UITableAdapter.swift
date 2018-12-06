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

open class UITableAdapter: ListAdapter<TableViewDataSource<SectionModelItem<TableSection, TableAdapterItemCompatible>>> {

    public weak private(set) var tableView: UITableView?
    lazy private(set) var tableProxy: UITableProxy = UITableProxy(self)
    /// ZJaDe: 代理
    open weak var delegate: TableViewDelegate?

    public func tableViewInit(_ tableView: UITableView) {
        self.tableView = tableView
        // 注册的用的全部都是SNTableViewCell, 真正的cell是.contentItem
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
    public override func changeSelectState(_ isSelected: Bool, _ item: TableAdapterItemCompatible) {
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
            switch item {
            case .cell(let cell):
                cell.refreshEnabledState(isEnabled)
            case .model(let model):
                model.refreshEnabledState(isEnabled)
            }
        }
    }
    // MARK: - ListDataUpdateProtocol
    public var insertSecionModelsClosure: ((ListDataType) -> (ListDataType))?
    override func loadRxDataSource() -> DataSource {
        let dataSource = DataSource(dataController: DataController())
        dataSource.configureCell = {(_, tableView, _, item) in
            return item.createCell(in: tableView)
        }
        return dataSource
    }
    // MARK: -
    private var timer: Timer?
    public func updateItemsIfNeed() {
        let modelTable = NSHashTable<AnyObject>.weakObjects()
        self.dataArray.forEach { (sectionModel) in
            let (_, items) = sectionModel
            items.forEach({ (item) in
                switch item {
                case .cell(let cell):
                    modelTable.add(cell)
                case .model(let model):
                    modelTable.add(model)
                }
            })
        }
        self.timer?.invalidate()
        self.timer = Timer.scheduleTimer(0) {[weak self] (timer) in
            guard let `self` = self else { return }
            if let item = modelTable.anyObject {
                modelTable.remove(item)
                if let item = item as? TableCellConfigProtocol {
                    if item.cellHeightLayoutType.isNeedLayout, let tableView = self.tableView {
                        item.calculateCellHeight(tableView, wait: false)
                    }
                }
            } else {
                timer?.invalidate()
            }
        }
    }

    // MARK: -
    deinit {
        self.dataArray.forEach { (sectionModel) in
            sectionModel.1.forEach({ (item) in
                if case .model(let model) = item {
                    model.cleanReference()
                }
            })
        }
    }
}
extension UITableAdapter {
    open func configDataSource(_ tableView: UITableView) {
        dataArrayObservable()
            .map({$0.map({[weak self] (dataArray) in
                let dataArray = self?.insertSecionModelsClosure?(dataArray) ?? dataArray
                return dataArray.compactMap(UITableAdapter.compactMap)
            })})
            .do(onNext: { [weak self] (element) -> Void in
                guard let `self` = self else {return}
                self.updateItemsIfNeed()
                element.data.forEach({ (sectionModel) in
                    sectionModel.items.forEach({ (item) in
                        if case .model(let model) = item {
                            model.bufferPool = self.bufferPool
                        }
                    })
                })
            })
            .bind(to: tableView.rx.items(dataSource: self.rxDataSource))
            .disposed(by: disposeBag)
    }

    open func configDelegate(_ tableView: UITableView) {
        tableView.rx.setDelegate(self.tableProxy)
            .disposed(by: self.disposeBag)
    }
}
extension UITableAdapter: TableAdapterDelegate {
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard dataController.indexPathCanBound(indexPath) else {
            return 0.1
        }
        let item = dataController[indexPath]
        if item.cellHeightLayoutType.isNeedLayout {
            item.calculateCellHeight(self.tableView!, wait: true)
        }
        return item.tempCellHeight > 0 ? item.tempCellHeight : Space.cellDefaultHeight
    }
    // MARK: -
    public func heightForHeader(in section: Int) -> CGFloat {
        guard dataController.sectionIndexCanBound(section) else {
            return 0.1
        }
        let sectionModel = dataController[section].section
        return sectionModel.headerView.viewHeight(self.tableView!.width)
    }

    public func heightForFooter(in section: Int) -> CGFloat {
        guard dataController.sectionIndexCanBound(section) else {
            return 0.1
        }
        let sectionModel = dataController[section].section
        return sectionModel.footerView.viewHeight(self.tableView!.width)
    }

    public func viewForHeader(in section: Int) -> UIView? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        let sectionModel = dataController[section].section
        return sectionModel.headerView
    }

    public func viewForFooter(in section: Int) -> UIView? {
        guard dataController.sectionIndexCanBound(section) else {
            return nil
        }
        let sectionModel = dataController[section].section
        return sectionModel.footerView
    }

    public func willDisplay(cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        let itemModel = dataController[indexPath]
        itemModel.willAppear(in: cell)
        if let itemCell = itemModel.getCell() {
            delegate?.didDisplay(item: itemCell)
            if let isEnabled = self.isEnabled {
                itemCell.refreshEnabledState(isEnabled)
            }
        }
    }
    public func didEndDisplaying(cell: UITableViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? SNTableViewCell else {
            return
        }
        if let itemModel = (cell.contentItem as? DynamicTableItemCell)?._model {
            if let itemCell = itemModel.getCell() {
                itemModel.didDisappear(in: cell)
                delegate?.didEndDisplaying(item: itemCell)
            }
        } else if let itemModel = cell.contentItem as? StaticTableItemCell {
            if let itemCell = itemModel.getCell() {
                itemModel.didDisappear(in: cell)
                delegate?.didEndDisplaying(item: itemCell)
            }
        }
    }

    public func shouldHighlightItem(at indexPath: IndexPath) -> Bool {
        if let result = delegate?.shouldHighlightItem(at: indexPath) {
            return result
        }
        let item = dataController[indexPath].getCell()
        return item?.checkShouldHighlight() ?? true
    }
    private func _didSelectItem(at indexPath: IndexPath) {
        let item = dataController[indexPath]
        self.checkCanSelected(item) {[weak self] (isCanSelected) in
            guard let `self` = self else { return }
            if isCanSelected {
                self.whenItemSelected(item)
            } else {
                if self.autoDeselectRow {
                    self.tableView?.deselectRow(at: indexPath, animated: true)
                }
            }
        }
        item.didSelectItem()
    }
    public func didSelectItem(at indexPath: IndexPath) {
        _didSelectItem(at: indexPath)
        delegate?.didSelectItem(at: indexPath)
    }

    private func _didDeselectItem(at indexPath: IndexPath) {
        let item = dataController[indexPath]
        whenItemUnSelected(item)
    }
    public func didDeselectItem(at indexPath: IndexPath) {
        _didDeselectItem(at: indexPath)
        delegate?.didDeselectItem(at: indexPath)
    }
    // MARK: -
    public func editActionsForRowAt(at indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let result = delegate?.editActionsForRowAt(at: indexPath) {
            return result
        }
        return nil
    }
}
