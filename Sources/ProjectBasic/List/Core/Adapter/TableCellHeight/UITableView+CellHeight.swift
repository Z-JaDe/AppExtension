//
//  UITableView+CellHeight.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2019/11/20.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

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
