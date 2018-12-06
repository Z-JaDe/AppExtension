//
//  ValueProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/12.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public let decimalNumberFormat: NumberFormatter = {
    let format = NumberFormatter()
    format.numberStyle = .decimal
    format.positiveFormat = "#0.00#"
    return format
}()
extension FloatLiteralTypeValueProtocol where Self: CustomStringConvertible {
    /// decimal: 保留几位小数, nil保留有效位数, 传整数为保留几位小数
    public func valueFormat(_ decimal: UInt?) -> String {
        if let decimal = decimal {
            return String(format: "%.\(decimal)f", self.value)
        } else {
            decimalNumberFormat.positiveFormat = self.positiveFormat
            return decimalNumberFormat.string(from: self.value as NSNumber) ??
                String(format: "%@", self.value as NSNumber)
        }
    }
}
