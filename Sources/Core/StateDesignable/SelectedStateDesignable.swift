//
//  SelectedStateDesignable.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/8.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol SelectedStateDesignable {
    var isSelected: Bool {get set}
    func didSelectItem()
}
public protocol CanSelectedStateDesignable: SelectedStateDesignable {

    var canSelected: Bool {get set}

    func checkCanSelected(_ closure: @escaping (Bool) -> Void)

}
