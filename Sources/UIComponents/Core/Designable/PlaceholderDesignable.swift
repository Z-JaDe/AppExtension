//
//  PlaceholderDesignable.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol PlaceholderDesignable: TextDesignable {
    var placeholder: String? {get set}
    var placeholderTextColor: UIColor? {get set}

    func getPlaceholderTextColor() -> UIColor
}
extension PlaceholderDesignable {
    public func getPlaceholderTextColor() -> UIColor {
        return self.placeholderTextColor ?? Color.placeholder
    }
}