//
//  ListDelegateProtocol.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/13.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//
import Foundation

public protocol _ListDelegate: class {
    func didSelectItem(at indexPath: IndexPath)
    func didDeselectItem(at indexPath: IndexPath)
    func shouldHighlightItem(at indexPath: IndexPath) -> Bool
}
extension _ListDelegate {
    public func didSelectItem(at indexPath: IndexPath) {

    }
    public func didDeselectItem(at indexPath: IndexPath) {

    }
    public func shouldHighlightItem(at indexPath: IndexPath) -> Bool {
        return true
    }
}
