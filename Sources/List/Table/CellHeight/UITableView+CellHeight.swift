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
extension UITableView {
    var cellHeights: [IndexPath: CGFloat] {
        get {return associatedObject(&cellHeightKey, createIfNeed: [:])}
        set {setAssociatedObject(&cellHeightKey, newValue)}
    }
    func changeTempCellHeight(_ newValue: CGFloat, for indexPath: IndexPath) {
        self.cellHeights[indexPath] = newValue
    }
    func tempCellHeight(for indexPath: IndexPath) -> CGFloat {
        return self.cellHeights[indexPath] ?? 0
    }
    func cellHeightLayoutType(for indexPath: IndexPath) -> CellHeightLayoutType {
        switch self.tempCellHeight(for: indexPath) {
        case 0:
            return .neverLayout
        case ..<0:
            return .resetLayout
        case _:
            return .hasLayout
        }
    }
}
