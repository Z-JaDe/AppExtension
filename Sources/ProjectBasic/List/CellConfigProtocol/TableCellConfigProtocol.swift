//
//  TableCellConfigProtocol.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/18.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
/**
 自己实现复用cell，willAppear和didDisappear需要代理里面调用，UITableAdapter默认已经调用
 */
protocol TableCellConfigProtocol: CreateTableCellrotocol {
    func willAppear(in cell: UITableViewCell)
    func didDisappear(in cell: UITableViewCell)
    func shouldHighlight() -> Bool
}
extension CreateTableCellrotocol {
    func _createCell(in tableView: UITableView, for indexPath: IndexPath, _ reuseIdentifier: String) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
    }
}
