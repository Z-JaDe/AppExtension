//
//  UITableView+CellHeight.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/7.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
public enum CellHeightLayoutType {
    case neverLayout
    case hasLayout
    case resetLayout

    var isNeedLayout: Bool {
        return self != .hasLayout
    }
}
private var cellHeightKey: UInt8 = 0
extension TableCellHeightProtocol {
    var tempCellHeight: CGFloat {
        return associatedObject(&cellHeightKey, createIfNeed: 0)
    }
    func changeTempCellHeight(_ newValue: CGFloat) {
        setAssociatedObject(&cellHeightKey, newValue)
    }
    var cellHeightLayoutType: CellHeightLayoutType {
        switch self.tempCellHeight {
        case 0:
            return .neverLayout
        case ..<0:
            return .resetLayout
        case _:
            return .hasLayout
        }
    }

    func setNeedResetCellHeight() {
        self.changeTempCellHeight(-1)
    }
}
