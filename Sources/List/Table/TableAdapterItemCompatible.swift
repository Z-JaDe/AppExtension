//
//  TableAdapterItemCompatible.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/17.
//

import Foundation

public enum TableAdapterItemCompatible: AdapterItemType {
    case cell(StaticTableItemCell)
    case model(TableItemModel)

    public var cell: StaticTableItemCell? {
        if case .cell(let cell) = self {
            return cell
        }
        return nil
    }
    public var model: TableItemModel? {
        if case .model(let model) = self {
            return model
        }
        return nil
    }
    internal var value: AnyObject & CanSelectedStateDesignable & TableCellConfigProtocol & HiddenStateDesignable {
        switch self {
        case .cell(let cell):
            return cell
        case .model(let model):
            return model
        }
    }
}

extension TableAdapterItemCompatible: DataSourceItemtype, Hashable {
    public static func == (lhs: TableAdapterItemCompatible, rhs: TableAdapterItemCompatible) -> Bool {
        switch (lhs, rhs) {
        case (.cell(let cell1), .cell(let cell2)):
            return cell1 == cell2
        case (.model(let model1), .model(let model2)):
            return model1 == model2
        case _:
            return false
        }
    }
    public var hashValue: Int {
        switch self {
        case .cell(let cell):
            return cell.hashValue
        case .model(let model):
            return model.hashValue
        }
    }
    public func isContentEqual(to source: TableAdapterItemCompatible) -> Bool {
        switch (self, source) {
        case (.cell(let cell1), .cell(let cell2)):
            return cell1.isContentEqual(to: cell2)
        case (.model(let model1), .model(let model2)):
            return model1.isContentEqual(to: model2)
        case _:
            return false
        }
    }
}
extension TableAdapterItemCompatible: HiddenStateDesignable {
    public var isHidden: Bool {
        get {return value.isHidden}
        set {
            switch self {
            case .cell(let cell):
                cell.isHidden = newValue
            case .model(let model):
                model.isHidden = newValue
            }
        }
    }
}
extension TableAdapterItemCompatible: SelectedStateDesignable & CanSelectedStateDesignable {
    public func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        value.checkCanSelected(closure)
    }
    public func didSelectItem() {
        value.didSelectItem()
    }
    public var isSelected: Bool {
        get {return value.isSelected}
        set {
            switch self {
            case .cell(let cell):
                cell.isSelected = newValue
            case .model(let model):
                model.isSelected = newValue
            }
        }
    }
    public var canSelected: Bool {
        get {return value.canSelected}
        set {
            switch self {
            case .cell(let cell):
                cell.canSelected = newValue
            case .model(let model):
                model.canSelected = newValue
            }
        }
    }
}
extension TableAdapterItemCompatible: CustomStringConvertible {
    public var description: String {
        switch self {
        case .cell(let cell):
            return "cell: \(cell)"
        case .model(let model):
            return "model: \(model)"
        }
    }
}
extension TableAdapterItemCompatible: TableCellConfigProtocol {

    public func createCell(in tableView: UITableView) -> UITableViewCell {
        return value.createCell(in: tableView)
    }

    public func willAppear(in cell: UITableViewCell) {
        value.willAppear(in: cell)
    }

    public func didDisappear(in cell: UITableViewCell) {
        value.didDisappear(in: cell)
    }

    public func createCell(isTemp: Bool) -> TableItemCell {
        return value.createCell(isTemp: isTemp)
    }

    public func getCell() -> TableItemCell? {
        return value.getCell()
    }

    public var tempCellHeight: CGFloat {
        return value.tempCellHeight
    }
    public func changeTempCellHeight(_ newValue: CGFloat) {
        value.changeTempCellHeight(newValue)
    }

}
