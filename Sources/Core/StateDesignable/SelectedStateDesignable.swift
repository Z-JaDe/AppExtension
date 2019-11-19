//
//  SelectedStateDesignable.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/8.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol SelectedStateDesignable {
    var isSelected: Bool {get set}
}
public protocol CanSelectedStateDesignable: SelectedStateDesignable {

    var canSelected: Bool {get}

    func checkCanSelected(_ closure: @escaping (Bool) -> Void)

}
extension CanSelectedStateDesignable {
    public func checkCanSelected(_ closure: @escaping (Bool) -> Void) {
        closure(self.canSelected)
    }
}
