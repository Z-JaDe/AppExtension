//
//  StateDesignable.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/9/6.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol HiddenStateDesignable {
    var isHidden: Bool {get set}
}
public protocol EnabledStateDesignable {
    var isEnabled: Bool {get set}
}
public protocol SelectedStateDesignableReadonly {
    var isSelected: Bool {get}
}
public protocol SelectedStateDesignable: AnyObject, SelectedStateDesignableReadonly {
    var isSelected: Bool {get set}
}
public protocol HighlightedStateDesignable {
    var isHighlighted: Bool {get}
}
