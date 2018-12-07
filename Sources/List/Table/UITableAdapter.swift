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
        dataSource.configureCell = {[weak self] (_, tableView, indexPath, item) in
            guard let `self` = self else {
                return item.value.createCell(in: tableView, for: indexPath)
            }
            return self.createCell(in: tableView, for: indexPath, item: item)
        }
        return dataSource
    }
    // MARK: -
    private var timer: Timer?
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

    // MARK: -
    deinit {
        cleanReference()
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
    open func configDataSource(_ tableView: UITableView) {
        dataArrayObservable()
            .map({$0.map({[weak self] (dataArray) in
                let dataArray = self?.insertSecionModelsClosure?(dataArray) ?? dataArray
                return dataArray.compactMap(UITableAdapter.compactMap)
            })})
            .do(onNext: { [weak self] (element) -> Void in
                guard let `self` = self else {return}
                self.updateItemsIfNeed()
                self.addBufferPool(at: element.data)
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
    private func createCell(in tableView: UITableView, for indexPath: IndexPath, item: TableAdapterItemCompatible) -> UITableViewCell {
        if item.value.cellHeightLayoutType.isNeedLayout {
            item.value.calculateCellHeight(tableView, wait: true)
        }
        return item.value.createCell(in: tableView, for: indexPath)
    }
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        guard dataController.indexPathCanBound(indexPath) else {
            return 0.1
        }
        let height = dataController[indexPath].value.tempCellHeight
        return height > 0 ? height : Space.cellDefaultHeight
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
        itemModel.value.willAppear(in: cell)
        if let itemCell = itemModel.value.getCell() {
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
        let item = dataController[indexPath].value.getCell()
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
