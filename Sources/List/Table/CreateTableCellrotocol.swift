//
//  CreateTableCellrotocol.swift
//  AppExtension
//
//  Created by Apple on 2019/5/8.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

/**
 创建一个cell
 */
public protocol CreateTableCellrotocol {
    func createCell(in tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
}
