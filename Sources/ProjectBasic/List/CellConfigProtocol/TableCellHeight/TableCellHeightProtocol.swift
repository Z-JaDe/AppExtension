//
//  TableCellHeightProtocol.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/** ZJaDe:
 使用item来存储高度
 如果改成用tableView根据indexPath来存储高度，刷新时需要清空高度缓存，不可取
 */
protocol TableCellHeightProtocol: AssociatedObjectProtocol {
    /// ZJaDe: 计算高度
    func calculateCellHeight(_ tableView: UITableView, wait: Bool)
    func updateHeight(_ closure: (() -> Void)?)
}
extension UITableView {
    func getItemCellWidth(_ accessoryView: UIView?, _ accessoryType: UITableViewCell.AccessoryType) -> CGFloat {
        var contentViewWidth = self.bounds.size.width
        if let accessoryView = accessoryView {
            contentViewWidth -= 16 + accessoryView.width
        } else {
            switch accessoryType {
            case .none:
                contentViewWidth -= 0
            case .disclosureIndicator:
                contentViewWidth -= 34
            case .detailDisclosureButton:
                contentViewWidth -= 68
            case .checkmark:
                contentViewWidth -= 40
            case .detailButton:
                contentViewWidth -= 48
            @unknown default:
                fatalError()
            }
        }
        if UIScreen.main.scale >= 3 && UIScreen.main.bounds.size.width >= 414 {
            contentViewWidth -= 4
        }
        return contentViewWidth
    }
}
