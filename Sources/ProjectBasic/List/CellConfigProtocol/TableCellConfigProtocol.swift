//
//  TableCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
/**
 自己实现复用cell，willAppear和didDisappear需要代理里面调用，UITableAdapter默认已经调用
 */
protocol TableCellConfigProtocol: CreateTableCellrotocol {
    func willAppear(in cell: UITableViewCell)
    func didDisappear(in cell: UITableViewCell)
    
    func createCell(isTemp: Bool) -> TableItemCell
    func recycleCell(_ cell: TableItemCell)
    func getCell() -> TableItemCell?
}
extension CreateTableCellrotocol {
    func _createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier: String = SNTableViewCell.reuseIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SNTableViewCell
        return cell!
    }
}
