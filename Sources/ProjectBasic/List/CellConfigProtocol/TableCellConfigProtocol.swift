//
//  TableCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

protocol TableCellConfigProtocol: CellConfigProtocol {
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
    func willAppear(in cell: UITableViewCell)
    func didDisappear(in cell: UITableViewCell)

    func createCell(isTemp: Bool) -> TableItemCell
    func recycleCell(_ cell: TableItemCell)
    func getCell() -> TableItemCell?
}
extension TableCellConfigProtocol {
    func _createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String = SNTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SNTableViewCell
        return cell!
    }
}
