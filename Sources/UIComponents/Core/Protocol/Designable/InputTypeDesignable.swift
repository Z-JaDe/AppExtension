//
//  InputTypeDesignable.swift
//  JDKit
//
//  Created by ZJaDe on 2018/1/30.
//  Copyright © 2018年 Z_JaDe. All rights reserved.
//

import Foundation

public protocol InputTypeDesignable: AnyObject {

}

public extension InputTypeDesignable {
    func datePickerFormat(_ datePickerMode: UIDatePicker.Mode) -> String {
        switch datePickerMode {
        case .date:
            return "yyyy-MM-dd"
        case .dateAndTime:
            return "yyyy-MM-dd HH: mm"
        case .countDownTimer:
            return "ss"
        case .time:
            return "HH: mm: ss"
        @unknown default:
            fatalError("\(datePickerMode.rawValue)")
        }
    }
}
