//
//  TextDesignable.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/29.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol TextDesignable {
    var text: String? {get set}
    var textColor: UIColor? {get set}
    var font: UIFont? {get set}
    var textAlignment: NSTextAlignment {get set}
    var attributedText: NSAttributedString? {get set}

    func getTextColor() -> UIColor
    func getFont() -> UIFont
}
extension TextDesignable {
    public func getTextColor() -> UIColor {
        self.textColor ?? Color.black
    }
    public func getFont() -> UIFont {
        self.font ?? Font.h3
    }
}
